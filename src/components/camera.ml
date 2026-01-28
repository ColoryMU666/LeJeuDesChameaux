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

let move v cam = 
  cam#velocity#set v

let stop_camera () =
  let Global.{main_camera; _ } = Global.get () in
  main_camera#velocity#set Vector.zero;
  ()