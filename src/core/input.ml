let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s

let action_table = Hashtbl.create 16
let register key action = Hashtbl.replace action_table key action

let handle_input () =
  let () =
    match Gfx.poll_event () with
      KeyDown s -> set_key s
    | KeyUp s -> unset_key s
    | MouseButton(i, b, x, y) ->  Global.mouse_x := x;
                                  Global.mouse_y := y;
                                  if b then set_key (string_of_int i) else unset_key (string_of_int i)
    | Quit -> exit 0
    | _ -> ()
  in
  Hashtbl.iter (fun key action ->
      if has_key key then action ()) action_table

let () =
  register "z" (fun () -> Block.(move_player (player1()) Cst.player_v_up));
  register "s" (fun () -> Block.(move_player (player1()) Cst.player_v_down));
  register "q" (fun () -> Block.(move_player (player1()) Cst.player_v_left); Block.(camera_move Cst.player_v_left System_defs.(Draw_system.get_elt_list ())));
  register "d" (fun () -> Block.(move_player (player1()) Cst.player_v_right); Block.(camera_move Cst.player_v_right System_defs.(Draw_system.get_elt_list ())));
  register "space" (fun () -> Block.( player_jump (player1 ())));
  register "1" (fun () -> ignore (Block.(fire_laser ())));
  register "n" (fun () -> ignore (Block.create_random ()))