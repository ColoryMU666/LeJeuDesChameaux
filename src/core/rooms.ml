open Component_defs
open Rect

let () = Random.self_init ()
let small_door_size = {width = 50 ; height = 100}

let create_door x y size =
  Block.create {Block.default_set_values with
    tag = Door;
    pos_x = x -. float(size.width) /. 2.;
    pos_y = y -. float(size.height);
    width = size.width;
    height = size.height;
    z_level = Background;
  }

module IntMap = Map.Make(Int)

let default_room () =
  let res = new room () in
  res#walls#set (Block.walls ());
  res#enemies#set [|(Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size);
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size);
  };
  res


let boss_room () =
  let res = new room () in
  res#walls#set (Block.walls ());
  res#enemies#set [|(Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size);
    down = None;
    right = None;
  };
  res

let room_1 () =
  let res = new room () in
  res#walls#set (Block.walls ());
  res#enemies#set [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size);
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size);
  };
  res

let room_2 () =
  let res = new room () in
  res#walls#set (Block.walls ());
  res#enemies#set [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = None;
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size);
  };
  res

let room_id_map, _ = 
  let l = [(default_room, 2); (boss_room, 1);  (room_1, 2); (room_2, 1)] in
  List.fold_left 
    (fun (acc, i) (room, door_number) -> 
      (IntMap.add i (room, door_number) acc, i+1))
  (IntMap.empty, 0) l


type room_doors = {
  up : bool;
  left : bool;
  down : bool;
  right : bool;
}
type room_map = {
  room_blueprint_id : int;
  doors : room_doors;
}

type dungeon = {
  rooms : room_map option array array;
  links : ((int * int) * (int * int)) list
}

type direction =
  | Up
  | Left
  | Right
  | Down

let has_link links (r1, c1) (r2, c2) =
    List.exists (fun ((a, b), (c, d)) ->
      (a = r1 && b = c1 && c = r2 && d = c2) ||
      (a = r2 && b = c2 && c = r1 && d = c1)
    ) links

let print_dungeon (m : bool array array)
                  (links : ((int * int) * (int * int)) list)
                  (start_room : int * int)
                  (boss_room : int * int) =
  let rows = Array.length m in
  let cols = Array.length m.(0) in
  let row_prefix_width = String.length (string_of_int (rows - 1)) + 1 in
  let pad = String.make row_prefix_width ' ' in
  (* Print column header *)
  print_string pad;
  for c = 0 to cols - 1 do
    print_string (string_of_int c);
    if c < cols - 1 then print_string " "
  done;
  print_newline ();
  for r = 0 to rows - 1 do
    let row_label = string_of_int r in
    print_string row_label;
    print_string (String.make (row_prefix_width - String.length row_label) ' ');
    (* Print nodes and horizontal links *)
    for c = 0 to cols - 1 do
      let node_char =
        if (r, c) = start_room then "S"
        else if (r, c) = boss_room then "B"
        else if m.(r).(c) then "#"
        else " "
      in
      print_string node_char;
      if c < cols - 1 then
        if has_link links (r, c) (r, c + 1) then
          print_string "-"
        else
          print_string " "
    done;
    print_newline ();
    (* Print vertical links *)
    if r < rows - 1 then begin
      print_string pad;
      for c = 0 to cols - 1 do
        if has_link links (r, c) (r + 1, c) then
          print_string "|"
        else
          print_string " ";
        if c < cols - 1 then print_string " "
      done;
      print_newline ();
    end
  done

let create_path tab path_size start =
  let size = Array.length tab in
  let h = Hashtbl.create 4 in
  
  let rec main_path n curent links = 
    let i, j = curent in
    tab.(i).(j) <- true;

    if n = path_size then
      curent, links
    else begin
      Hashtbl.clear h;
      if i > 0 && not tab.(i - 1).(j) then Hashtbl.add h Up ();
      if j > 0 && not tab.(i).(j - 1) then Hashtbl.add h Left ();
      if i < (size - 1) && not tab.(i + 1).(j) then Hashtbl.add h Down ();
      if j < (size - 1) && not tab.(i).(j + 1) then Hashtbl.add h Right ();

      let nb_dir = Hashtbl.length h in
      if nb_dir = 0 then
        curent, links
      else begin
        let dir = List.nth (Hashtbl.fold (fun dir _ acc -> dir :: acc) h []) (Random.int nb_dir) in
        match dir with
        | Up    -> main_path (n + 1) (i - 1, j) ((curent, (i - 1, j)) :: links)
        | Left  -> main_path (n + 1) (i, j - 1) ((curent, (i, j - 1)) :: links)
        | Down  -> main_path (n + 1) (i + 1, j) ((curent, (i + 1, j)) :: links)
        | Right -> main_path (n + 1) (i, j + 1) ((curent, (i, j + 1)) :: links);
      end
    end
  in

  let add_annex_room links start_room boss_room =
    let new_links = ref links in
    let directions = [| (-1, 0); (1, 0); (0, -1); (0, 1) |] in

    let queue = Queue.create () in
    for i = 0 to size - 1 do
      for j = 0 to size - 1 do
        if (i, j) <> start_room
        && (i, j) <> boss_room
        && tab.(i).(j) then Queue.add (i, j) queue
      done
    done;

    while not (Queue.is_empty queue) do
      let (i, j) = Queue.pop queue in
      Array.iter (fun (di, dj) ->
        let ni = i + di in
        let nj = j + dj in
        if ni >= 0 && ni < size && nj >= 0 && nj < size then
          if not tab.(ni).(nj) && Random.int 3 = 0 then begin
            tab.(ni).(nj) <- true;
            new_links := ((i, j), (ni, nj)) :: !new_links;
            Queue.add (ni, nj) queue
          end
      ) directions
    done;
    !new_links
  in

  let add_more_links links start_room boss_room =
    let new_links = ref links in
    let directions = [| (-1, 0); (1, 0); (0, -1); (0, 1) |] in
    for i = 0 to size - 1 do
      for j = 0 to size - 1 do
        if (i, j) <> start_room
        && (i, j) <> boss_room
        && tab.(i).(j) then
          Array.iter (fun (di, dj) ->
            let ni = i + di in
            let nj = j + dj in
            if ni >= 0 && ni < size && nj >= 0 && nj < size then
              if tab.(ni).(nj)
              && (ni, nj) <> start_room
              && (ni, nj) <> boss_room
              && not (has_link !new_links (i, j) (ni, nj))
              && Random.int 4 = 0 then
                new_links := ((i, j), (ni, nj)) :: !new_links
          ) directions
      done
    done;
    !new_links
  in

  let boss_room, links = main_path 0 start [] in
  let links = add_annex_room links start boss_room in
  let links = add_more_links links start boss_room in
  boss_room, links
  
let create_dungeon size : unit =
  let tab = Array.init size (fun _ -> Array.init size (fun _ -> false)) in
  let path_size = (size * size / 5 - 3) +  Random.int (7) in
  let spawn = (Random.int size, Random.int size) in
  let boss, links = create_path tab path_size spawn in
  print_dungeon tab links spawn boss;
  let i, j = spawn in
  let x, y = boss in
  print_endline ("path size : " ^ (string_of_int path_size));
  print_endline ("start : " ^ (string_of_int i) ^ " " ^ (string_of_int j) ^ " | end : " ^ (string_of_int x) ^ " " ^ (string_of_int y));
  ()
