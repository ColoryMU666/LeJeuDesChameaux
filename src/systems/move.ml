open Ecs
open Component_defs

type t = movable

let init _ = Gfx.debug "Move init\n"

let update _ el =
  Seq.iter (fun (e:t) ->
      (if e#forces#get = Vector.zero then
        ()
      else
      e#velocity#set (Vector.add e#velocity#get e#forces#get)
      );
      e#position#set Vector.(add e#velocity#get e#position#get)
    ) el
