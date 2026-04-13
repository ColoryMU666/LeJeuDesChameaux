open Ecs
open Component_defs


type t = drawable

let init _ = Gfx.debug "Drawn_background system initialised\n%!"

let update dt el =
  let has_link links (r1, c1) (r2, c2) =
    List.exists (fun ((a, b), (c, d)) ->
      (a = r1 && b = c1 && c = r2 && d = c2) ||
      (a = r2 && b = c2 && c = r1 && d = c1)
    ) links
  in

  (* Retrieve global state: rendering context, window, and dungeon *)
  let Global.{ window; ctx; dungeon; _ } = Global.get () in
  let surface = Gfx.get_surface window in

  (* Extract dungeon data from components *)
  let layout = dungeon#layout#get in
  let visited = dungeon#visited#get in
  let (cur_row, cur_col) = dungeon#current_room_pos#get in
  let rooms = layout.rooms in
  let links = layout.links in

  let rows = Array.length rooms in
  (* Nothing to draw if the dungeon has not been generated yet *)
  if rows = 0 then ()
  else begin
    let cols = Array.length rooms.(0) in

    (* Minimap geometry *)
    let cell_size = 15 in  (* size of each room square in pixels *)
    let gap       = 7  in  (* gap between cells, also used for link connectors *)
    let padding   = 15  in  (* margin from the screen edge *)
    let step      = cell_size + gap in  (* distance from one cell origin to the next *)
    let link_size = 3 in

    (* Total map dimensions *)
    let map_w = cols * step - gap in
    let map_h = rows * step - gap in

    (* Top-right corner position *)
    let map_x = Cst.window_width - map_w - padding in
    let map_y = padding in

    let border_pad = 4 in  (* extra padding around the background panel *)

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
        nr >= 0 && nr < rows
        && nc >= 0 && nc < cols
        && has_link links (r, c) (nr, nc)
        && is_visited nr nc
      ) [(-1,0);(1,0);(0,-1);(0,1)]
    in

    (* Draw the dark background panel behind the minimap *)
    Texture.draw ctx surface
      (Vector.{ x = float (map_x - border_pad); y = float (map_y - border_pad) })
      (Rect.{ width = map_w + border_pad * 2; height = map_h + border_pad * 2 })
      Texture.color_bg;

    (* First pass: draw link connectors between adjacent rooms.
      A connector is only drawn if both endpoint rooms are revealed,
      so no floating lines appear in the fog of war. *)
    Array.iteri (fun r row ->
      Array.iteri (fun c cell ->
        match cell with
        | None -> ()  (* empty grid slot, skip *)
        | Some _ ->
          (* Center of the current cell in screen coordinates *)
          let cx = map_x + c * step + cell_size / 2 in
          let cy = map_y + r * step + cell_size / 2 in

          (* Draw a horizontal connector to the right neighbour if both
            rooms are revealed and linked *)
          if c + 1 < cols then (match rooms.(r).(c+1) with
            | Some _ when has_link links (r, c) (r, c+1)
                      && (is_visited r c || is_visited r (c+1)) ->
              Texture.draw ctx surface
                (Vector.{ x = (float cx) +. (float cell_size) /. 2.; y = float cy })
                (Rect.{ width = gap; height = link_size })
                Texture.color_link
            | _ -> ());

          (* Draw a vertical connector to the bottom neighbour if both
            rooms are revealed and linked *)
          if r + 1 < rows then (match rooms.(r+1).(c) with
            | Some _ when has_link links (r, c) (r+1, c)
                      && is_revealed r c
                      && is_revealed (r+1) c ->
              Texture.draw ctx surface
                (Vector.{ x = float cx; y = float (cy + cell_size/2) })
                (Rect.{ width = link_size; height = gap })
                Texture.color_link
            | _ -> ())
      ) row
    ) rooms;

    (* Second pass: draw room cells on top of the connectors *)
    Array.iteri (fun r row ->
      Array.iteri (fun c cell ->
        match cell with
        | None -> ()  (* empty grid slot, skip *)
        | Some _ ->
          (* Determine the color based on the room's visibility state.
            Rooms that are neither visited nor adjacent to a visited room
            are completely hidden and not drawn at all. *)
          let color_opt =
            if r = cur_row && c = cur_col then Some Texture.color_current
            else if is_visited r c          then Some Texture.color_visited
            else if is_revealed r c         then Some Texture.color_unvisited
            else                                 None  (* hidden, fog of war *)
          in
          (match color_opt with
          | None -> ()
          | Some color ->
            Texture.draw ctx surface
              (Vector.{ x = float (map_x + c * step); y = float (map_y + r * step) })
              (Rect.{ width = cell_size; height = cell_size })
              color)
      ) row
    ) rooms;

    (* Flush all draw calls to the screen *)
    Gfx.commit ctx
  end