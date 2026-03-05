let key_pressed_table = Hashtbl.create 16
let key_just_released_table = Hashtbl.create 16
let key_just_pressed_table = Hashtbl.create 16

let has_key table s = Hashtbl.mem table s

let set_key s =
  Hashtbl.replace key_pressed_table s ();
  Hashtbl.replace key_just_pressed_table s ()

let unset_key s =
  Hashtbl.remove key_pressed_table s;
  Hashtbl.replace key_just_released_table s ()

let register action_table key action =
  Hashtbl.replace action_table key action

let rec get_inputs () =
  match Gfx.poll_event () with
    | KeyDown s ->
      if not (has_key key_pressed_table s) then (set_key s); 
      get_inputs ()
    | KeyUp s ->
      unset_key s;
      get_inputs ()
    | MouseMove(x, y) ->
      Global.mouse_x := x;
      Global.mouse_y := y;
      get_inputs ()
    | MouseButton(i, b, x, y) -> 
      let s = "Mouse" ^ (string_of_int i) in
      if b then set_key s else unset_key s;
      get_inputs ()
    | Quit -> exit 0
    | NoEvent -> ()

let handle_input () =
  Hashtbl.clear key_just_pressed_table;
  Hashtbl.clear key_just_released_table;
  get_inputs ()

let is_pressed key =
  Hashtbl.mem key_pressed_table key

let is_just_pressed key =
  Hashtbl.mem key_just_pressed_table key

let is_just_released key =
  Hashtbl.mem key_just_released_table key

(*
let () =
  
  register action_just_pressed_table "k" (fun () -> ignore (Enemy.create (300., 300., Vector.{x=0. ; y=0.}, Texture.red, 20, 50, 1.)) );
  
  register action_just_pressed_table "g" (fun () -> ignore (Gun.create_laser ()));
*)