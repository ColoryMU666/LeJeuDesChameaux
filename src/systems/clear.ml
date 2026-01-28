open Ecs
open Component_defs


type t = deletable

let init _ = Gfx.debug "Clear init\n%!"

let update _ el =
  let tmp = Seq.fold_left (fun acc (e:t) -> 
    if e#lifespan#get = 0 then
      acc @ [e]
    else
      (e#lifespan#set (e#lifespan#get - 1);
      acc)
    ) [] el in
  Gc.compact ();
  List.iter (fun elt -> Entity.delete elt) tmp