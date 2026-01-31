open System_defs
open Component_defs
open Ecs


let init dt =
  Ecs.System.init_all dt;
  Some ()


let update dt =
  let () = Player.stop_players () in
  let () = Camera.stop_camera () in
  let () = Input.handle_input () in
  Global.player_on_ground := Player.is_on_ground (Collision_system.get_elt_list ());
  Move_system.update dt;
  Collision_system.update dt;
  Display_system.update dt;  
  Draw_system.update dt;
  Clear_system.update dt;
  None

let (let@) f k = f k


let run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  let _walls = Wall.walls () in
  let player1 = Player.players () in
  let main_camera = Camera.create () in
  let global = Global.{ window; ctx; player1; main_camera } in
  Global.set global;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in ()








