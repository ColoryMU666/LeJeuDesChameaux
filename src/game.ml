open System_defs
open Component_defs
open Ecs

let last_dt = ref 0.

let init dt =
  Ecs.System.init_all dt;
  last_dt := dt;
  Some ()

let update dt =
  let real_delta = (dt -. !last_dt) in
  let delta = real_delta /. 25. in
  last_dt := dt;
  let () = Camera.stop_camera () in
  let () = Input.handle_input () in
  let () = Camera.move () in
  Player_manager_system.update delta;
  Move_system.update delta;
  Collision_system.update delta;
  Interact_system.update delta;
  Timer_system.update real_delta;
  Clear_system.update delta;
  Draw_system.update delta;
  Lifebar_draw_system.update delta;
  None

let (let@) f k = f k


let run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:r=presentvsync"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  let _walls = Block.walls () in
  let main_camera = Camera.create () in
  let player1 = Player.create_player () in
  let global = Global.{ window; ctx ; player1 ;main_camera} in
  Global.set global;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in ()








