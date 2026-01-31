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
  if x >= (float Cst.window_width) /. 2. then
    Camera.(move v (camera()))
  else
    ()

let jump player =
  if !Global.player_on_ground then
    player#velocity#set (Vector.add Cst.player_v_jump player#velocity#get)

let is_on_ground el = 
  let res = ref false in
  let player1 = player1 () in
  let rect = Rect.{width = Cst.player_width ; height = 2} in
  let pos = Vector.add player1#position#get (Vector.{x = 0. ; y = float Cst.player_height}) in
  Seq.iter (fun e -> 
    let mdif = Rect.mdiff pos rect e#position#get e#box#get in
    res := !res || Rect.has_origin (fst mdif) (snd mdif)
    ) el;
  !res