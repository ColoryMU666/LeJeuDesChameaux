open Ecs
open Component_defs

type t = enemy

let init _ = Gfx.debug "Enemy_manager system initialised\n%!"

let handle_action dt (e:t) =
  if e#can_act#get then
    e#action#get ()

let update dt el =
  Seq.iteri (fun i (e:t) ->
    handle_action dt e;
  ) el;
