open Ecs
open Component_defs

type t = displayable

let init _ = Gfx.debug "Camera init\n%!"

let update _ el =
  let Global.{main_camera; _} = Global.get () in
  Seq.iter (fun (e:t) -> 
    e#dposition#set (Vector.sub e#position#get main_camera#position#get)) el