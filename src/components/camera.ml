open Ecs
open System_defs
open Component_defs

let move v el = 
  Seq.iter (fun (e) -> e#position#set (Vector.sub e#position#get v)) el