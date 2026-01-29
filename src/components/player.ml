open Ecs
open Component_defs
open System_defs

let players () =  
  Block.create Cst.(player1_x, player1_y, Vector.zero, player_color, player_width, player_height, 100.,Some Cst.g, None, 0., 2)


let player1 () = 
  let Global.{player1; _ } = Global.get () in
  player1

let stop_players () = 
  let Global.{player1; _ } = Global.get () in
  player1#velocity#set Vector.zero;
  ()

let move player v =
  player#velocity#set  (Vector.add v player#velocity#get);
  let Vector.{x; y} = player#dposition#get in
  Gfx.debug "x = %f ; y = %f\n%!" x y;
  Gfx.debug "%f\n%!" (float Cst.window_width);
  if x >= (float Cst.window_width) /. 2. then
    Camera.(move v (camera()))
  else
    ()

let jump player =
  player#velocity#set (Vector.add Cst.player_v_jump player#velocity#get)