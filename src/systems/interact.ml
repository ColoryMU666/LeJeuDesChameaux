open Ecs
open Component_defs

type t = interactable

let init _ = Gfx.debug "Interact system initialised\n%!"

let update _ el =
  let Global.{player1; _} = Global.get () in
  let playerbox = player1#box#get in
  let playerpos = player1#position#get in
  if !Global.is_interacting then begin
    let e_opt = Seq.find (fun (e:t) ->
      let p, r = Rect.mdiff playerpos playerbox e#position#get e#box#get in
      Rect.has_origin p r
      ) el
    in
    match e_opt with
    | None -> ()
    | Some e -> e#interact_resolver#get ()
  end