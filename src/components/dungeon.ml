open Component_defs
open Rect
open Rooms
module IntMap = Map.Make(Int)

let room_id_map, _ = 
  let l = [
    (* special rooms *)
    (default_room,
      {up = false; left = true ; down = false; right = true },
      Enemy_room);
    (boss_room_left,
      {up = false; left = true ; down = false; right = false},
      Boss_room);
    (boss_room_right,
      {up = false; left = false; down = false; right = true },
      Boss_room);
    (boss_room_up,
      {up = true; left = false; down = false; right = false },
      Boss_room);
    (boss_room_down,
      {up = false; left = false; down = true; right = false },
      Boss_room);
    

    (* ROOMS HERE ONLY FOR TESTING AND TO COMPLETE ALL THE TYPES OF ROOMS, THEY ARE ENEMY ROOM *)
    (room_up,
      {up = true ; left = false; down = false; right = false},
      Start_room);
    (room_left,
      {up = false; left = true ; down = false; right = false},
      Start_room);
    (room_down,
      {up = false; left = false; down = true ; right = false},
      Start_room);
    (room_right,
      {up = false; left = false; down = false; right = true },
      Start_room);
    
    (* One direction rooms *)
    (room_up,
      {up = true ; left = false; down = false; right = false},
      Enemy_room);
    (room_left,
      {up = false; left = true ; down = false; right = false},
      Enemy_room);
    (room_down,
      {up = false; left = false; down = true ; right = false},
      Enemy_room);
    (room_right,
      {up = false; left = false; down = false; right = true },
      Enemy_room);
    
    
    (* Two directions rooms *)
    (room_up_left,
      {up = true ; left = true ; down = false; right = false},
      Enemy_room);
    (room_up_down,
      {up = true ; left = false; down = true ; right = false},
      Enemy_room);
    (room_up_right,
      {up = true ; left = false; down = false; right = true },
      Enemy_room);
    
    (room_left_down,
      {up = false; left = true ; down = true ; right = false},
      Enemy_room);
    (room_left_right,
      {up = false; left = true ; down = false; right = true },
      Enemy_room);
    
    (room_down_right,
      {up = false; left = false; down = true ; right = true },
      Enemy_room);

    (* Three directions rooms *)
    (room_up_left_down,
      {up = true ; left = true ; down = true ; right = false},
      Enemy_room);
    (room_up_left_right,
      {up = true ; left = true ; down = false; right = true },
      Enemy_room);
    (room_up_down_right,
      {up = true ; left = false; down = true ; right = true },
      Enemy_room);
    (room_left_down_right,
      {up = false; left = true ; down = true ; right = true },
      Enemy_room);
    
    (* Four directions rooms *)
    (room_up_left_down_right,
      {up = true ; left = true ; down = true ; right = true },
      Enemy_room);
  ] in
  List.fold_left 
    (fun (acc, i) (room, door_number, tag) -> 
      (IntMap.add i (room, door_number, tag) acc, i+1))
  (IntMap.empty, 0) l

let has_link = Room_loader.has_link

let print_dungeon (m : bool array array)
                  (links : ((int * int) * (int * int)) list)
                  (start_room : int * int)
                  (boss_room : int * int) =
  let rows = Array.length m in
  let cols = Array.length m.(0) in
  let row_prefix_width = String.length (string_of_int (rows - 1)) + 1 in
  let pad = String.make row_prefix_width ' ' in
  (* Print column header *)
  Gfx.debug "%s" pad;
  for c = 0 to cols - 1 do
    Gfx.debug "%d" c;
    if c < cols - 1 then Gfx.debug " "
  done;
  Gfx.debug "\n";
  for r = 0 to rows - 1 do
    let row_label = string_of_int r in
    Gfx.debug "%s" row_label;
    Gfx.debug "%s" (String.make (row_prefix_width - String.length row_label) ' ');
    (* Print nodes and horizontal links *)
    for c = 0 to cols - 1 do
      let node_char =
        if (r, c) = start_room then "S"
        else if (r, c) = boss_room then "B"
        else if m.(r).(c) then "#"
        else " "
      in
      Gfx.debug "%s" node_char;
      if c < cols - 1 then
        if has_link links (r, c) (r, c + 1) then
          Gfx.debug "-"
        else
          Gfx.debug " "
    done;
    Gfx.debug "\n";
    (* Print vertical links *)
    if r < rows - 1 then begin
      Gfx.debug "%s" pad;
      for c = 0 to cols - 1 do
        if has_link links (r, c) (r + 1, c) then
          Gfx.debug "|"
        else
          Gfx.debug " ";
        if c < cols - 1 then Gfx.debug " "
      done;
      Gfx.debug "\n"
    end;
    Gfx.debug "%!";
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

let find_specific_rooms directions room_tag =
  IntMap.fold (fun id (room_creator, doors, tag) acc -> 
    if tag = room_tag && doors = directions then
      (id, room_creator) :: acc
    else
      acc
  ) room_id_map []

let assign_rooms (tab : bool array array) 
                 (links : ((int * int) * (int * int)) list) 
                 (start_room : int * int)
                 (boss_room : int * int) 
                 : room_map option array array =
  let size = Array.length tab in
  Array.init size (fun i ->
    Array.init size (fun j ->
      if not tab.(i).(j) then None
      else begin
        let doors = {
          up    = has_link links (i, j) (i - 1, j);
          down  = has_link links (i, j) (i + 1, j);
          left  = has_link links (i, j) (i, j - 1);
          right = has_link links (i, j) (i, j + 1);
        } in
        let room_tag =
          if (i, j) = start_room then Start_room
          else if (i, j) = boss_room then Boss_room
          else Enemy_room
        in
        let candidates = find_specific_rooms doors room_tag in
        match candidates with
        | [] -> failwith (Printf.sprintf "No matching room for room %d %d" i j)
        | _ ->
          let idx = Random.int (List.length candidates) in
          let (room_blueprint_id, room_creator) = List.nth candidates idx in
          Some {room_blueprint_id; doors; room_tag; room_creator}
      end
    )
  )

let create_dungeon size : dungeon =
  let tab = Array.init size (fun _ -> Array.init size (fun _ -> false)) in
  let path_size = (size * size / 5 - 3) +  Random.int (7) in
  let start = (Random.int size, Random.int size) in
  let boss, links = create_path tab path_size start in

  (* Some prints for debuging *)
  print_dungeon tab links start boss;
  let start_i, start_j = start in
  let boss_i, boss_j = boss in
  Gfx.debug "path size : %s" (string_of_int path_size);
  Gfx.debug "start : %d %d | end : %d %d\n%!" start_i start_i boss_i boss_j;

  let dg = new dungeon () in
  let rooms = assign_rooms tab links start boss in
  dg#layout#set ({rooms ; links});
  dg#visited#set (Array.init size (fun i -> Array.init size (fun j -> if (i, j) = start then true else false)));
  dg#current_room_pos#set start;
  dg#start_room_pos#set start;
  dg#boss_room_pos#set boss;
  (match rooms.(start_i).(start_j) with
  | None -> failwith "Start room should not be None in the dungeon layout."
  | Some {room_creator; _} -> begin
    let doors = { up = false; left = false; down = false ; right = false} in
    dg#current_room#set (Some (room_creator doors));
  end);
  dg
