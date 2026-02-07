open Ecs
open System_defs
open Component_defs

let create () =
  let e = new camera () in
  e#position#set Vector.zero;
  e#velocity#set Vector.zero;
  e#forces#set Vector.zero;
  Move_system.(register (e :> t)); 
  e

let camera () = 
  let Global.{main_camera; _ } = Global.get () in
  main_camera

let move () = 
  let Global.{player1; main_camera; _} = Global.get () in
  let target_position = Vector.(sub player1#position#get Cst.camera_offset) in
  main_camera#velocity#set (Vector.sub target_position main_camera#position#get)

let stop_camera () =
  let Global.{main_camera; _ } = Global.get () in
  main_camera#velocity#set Vector.zero;
  ()