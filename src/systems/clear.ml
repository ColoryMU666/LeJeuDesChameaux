open Ecs
open Component_defs


type t = deletable

let init _ = Gfx.debug "Clear init\n%!"

let update _ el =
  let tmp = Seq.fold_left (fun acc (e:t) -> 
    if e#tokill#get then
      acc @ [e]
    else
      acc
    ) [] el in
  List.iter (fun elt -> Entity.delete elt) tmp;
  Gc.compact ()