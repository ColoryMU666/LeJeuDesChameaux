open Ecs
open Component_defs

type t = deletable

let init _ = Gfx.debug "Room_loader system initialised\n%!"

let add (room : room) (obj : t) =
  room#temporary_objects#set (obj :: room#temporary_objects#get)

let remove (room : room) (obj : t) =
  room#temporary_objects#set (List.filter (fun o -> o != obj) room#temporary_objects#get)

let add_current_room (obj : t) =
  let Global.{dungeon; _} = Global.get () in
  let room = Option.get dungeon#current_room#get in
  add room obj

let remove_current_room (obj : t) =
  let Global.{dungeon; _} = Global.get () in
  let room = Option.get dungeon#current_room#get in
  remove room obj

let unload e = e#tokill#set true

let unload_opt e_opt =
  match e_opt with
  | None -> ()
  | Some e -> unload e

let unload_room (room : room) =
  let doors = room#doors#get in
  unload_opt doors.up;
  unload_opt doors.left;
  unload_opt doors.down;
  unload_opt doors.right;
  Array.iter unload room#walls#get;
  List.iter (fun obj -> unload (obj :> t)) room#temporary_objects#get

let get_door_pos (room : room) direction =
  let door = match direction with
    | Up -> Option.get room#doors#get.down
    | Left -> Option.get room#doors#get.right
    | Down -> Option.get room#doors#get.up
    | Right -> Option.get room#doors#get.left
  in
  let pos = door#position#get in
  let size = door#box#get in
  (pos.x +. float(size.width) /. 2., pos.y +. float(size.height))


let has_link links (r1, c1) (r2, c2) =
  List.exists (fun ((a, b), (c, d)) ->
    (a = r1 && b = c1 && c = r2 && d = c2) ||
    (a = r2 && b = c2 && c = r1 && d = c1)
  ) links

let update dt el =
  let g = Global.get () in
  match g.dungeon#change_room#get with
  | None -> ()
  | Some dir -> begin
    unload_room (Option.get g.dungeon#current_room#get);
    let (i, j) = g.dungeon#current_room_pos#get in
    let r_map, ((i', j') as pos) = match dir with
      | Up -> g.dungeon#layout#get.rooms.(i - 1).(j), (i - 1, j)
      | Left -> g.dungeon#layout#get.rooms.(i).(j - 1), (i, j - 1)
      | Down -> g.dungeon#layout#get.rooms.(i + 1).(j), (i + 1, j)
      | Right -> g.dungeon#layout#get.rooms.(i).(j + 1), (i, j + 1)
    in
    match r_map with
    | None -> failwith "Moving to an undefined room"
    | Some r -> begin
      let links = g.dungeon#layout#get.links in
      let visited = g.dungeon#visited#get in
      let doors = {
          up    = has_link links (i', j') (i' - 1, j') && visited.(i' - 1).(j');
          down  = has_link links (i', j') (i' + 1, j') && visited.(i' + 1).(j');
          left  = has_link links (i', j') (i', j' - 1) && visited.(i').(j' - 1);
          right = has_link links (i', j') (i', j' + 1) && visited.(i').(j' + 1);
        } in
      Gfx.debug "doors : up : %b, left : %b, down : %b, right : %b\n%!"
        doors.up doors.left doors.right doors.down;
      let room = r.room_creator doors in
      g.dungeon#current_room#set (Some room);
      let (door_x, door_y) = get_door_pos room dir in
      let p_size = g.player1#box#get in
      g.player1#position#set Vector.{
        x = door_x -. float(p_size.width) /. 2.;
        y = door_y -. float(p_size.height);
      };
      g.dungeon#current_room_pos#set pos;
      g.dungeon#visited#get.(fst pos).(snd pos) <- true;
      g.dungeon#change_room#set None
    end
  end
