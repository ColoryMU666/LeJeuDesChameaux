open Ecs
open Component_defs


type t = drawable

let init _ = Gfx.debug "Draw_map system initialised\n%!"

let update dt el =
  let Global.{ window; ctx; dungeon; _ } = Global.get () in
  let surface = Gfx.get_surface window in

  (* Extract dungeon data from components *)
  let {rooms; links} = dungeon#layout#get in
  let visited = dungeon#visited#get in
  let (cur_row, cur_col) = dungeon#current_room_pos#get in
  let (boss_row, boss_col) = dungeon#boss_room_pos#get in
  let (start_row, start_col) = dungeon#start_room_pos#get in

  let grid_size = Array.length rooms in

  (* Minimap geometry *)
  let cell_size = 14 in
  let gap = 8  in  
  let padding = 15 in
  let step = cell_size + gap in
  let link_size = 4 in
  let border_pad = 4 in
  let map_size = grid_size * step - gap in

  (* Top-left corner position *)
  let map_x = Cst.window_width - map_size - padding in
  let map_y = padding in

  let has_link = Room_loader.has_link in

  (* Helper: true if a room at (r, c) has been visited *)
  let is_visited r c =
    Array.length visited > r
    && Array.length visited.(r) > c
    && visited.(r).(c)
  in

  (* Helper: true if a room at (r, c) should be revealed on the map,
    i.e. it is either visited itself or linked to at least one visited room *)
  let is_revealed r c =
    is_visited r c
    || List.exists (fun (dr, dc) ->
      let nr = r + dr and nc = c + dc in
      nr >= 0 && nr < grid_size
      && nc >= 0 && nc < grid_size
      && has_link links (r, c) (nr, nc)
      && is_visited nr nc
    ) [(-1,0);(1,0);(0,-1);(0,1)]
  in

  (* Draw the dark background panel behind the minimap *)
  Texture.draw ctx surface
    (Vector.{ x = float (map_x - border_pad); y = float (map_y - border_pad) })
    (Rect.{ width = map_size + border_pad * 2; height = map_size + border_pad * 2 })
    Texture.color_bg;

  Array.iteri (fun r row ->
    Array.iteri (fun c cell ->
      match cell with
      | None -> ()  (* empty grid slot *)
      | Some _ ->
        (* Top-left corner of the current cell *)
        let cell_x = map_x + c * step in
        let cell_y = map_y + r * step in

        (* Draw a horizontal connector to the right neighbour if they are linked 
          and one of the room has been visited *)
        if c + 1 < grid_size then (match rooms.(r).(c+1) with
          | Some _ when has_link links (r, c) (r, c+1)
                    && (is_visited r c || is_visited r (c+1)) ->
            Texture.draw ctx surface
              (Vector.{ x = float cell_x; y = float (cell_y + cell_size / 2 - link_size / 2) })
              (Rect.{ width = step * 2 - gap ; height = link_size })
              Texture.color_link
          | _ -> ());

        (* Draw a vertical connector to the bottom neighbour if they are linked 
          and one of the room has been visited *)
        if r + 1 < grid_size then
          (match rooms.(r+1).(c) with
          | Some _ when has_link links (r, c) (r+1, c)
                    && (is_visited r c || is_visited (r+1) (c)) ->
            Texture.draw ctx surface
              (Vector.{ x = float (cell_x + cell_size / 2 - link_size / 2); y = float cell_y })
              (Rect.{ width = link_size; height = step * 2 - gap })
              Texture.color_link
          | _ -> ());
          
        (* Determine the color based on the room's visibility state.
          Rooms that are neither visited nor adjacent to a visited room
          are completely hidden and not drawn at all. *)
        let color_opt =
          if r = cur_row && c = cur_col then Some Texture.color_current
          else if is_visited r c then begin
            if r = start_row && c = start_col then Some Texture.color_start
            else if r = boss_row && c = boss_col then Some Texture.color_boss
            else Some Texture.color_visited
          end else if is_revealed r c then begin
            if r = start_row && c = start_col then Some Texture.color_start
            else if r = boss_row && c = boss_col then Some Texture.color_boss
            else Some Texture.color_unvisited
          end else None
        in
        (match color_opt with
        | None -> ()
        | Some color ->
          Texture.draw ctx surface
            (Vector.{ x = float (map_x + c * step); y = float (map_y + r * step) })
            (Rect.{ width = cell_size; height = cell_size })
            color)
          
    ) row
  ) rooms