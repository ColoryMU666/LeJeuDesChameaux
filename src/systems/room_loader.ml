open Ecs
open Component_defs

type t = room

let init _ = Gfx.debug "Room_loader system initialised\n%!"

let update dt el =
  Seq.iter (fun (e:t) ->
    ()
  ) el
