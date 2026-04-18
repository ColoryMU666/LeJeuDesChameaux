open Ecs
open Component_defs

type t = interactable

let init _ = Gfx.debug "Click system initialised\n%!"

let update _ el =
  let mouse_x, mouse_y = !Global.mouse_x, !Global.mouse_y in
  if Input.is_just_pressed "Mouse1" || Input.is_just_pressed "Mouse0" then begin
    let e_opt = Seq.find (fun (e:t) ->
      let Vector.{x ; y} = e#position#get in
      let x, y = int_of_float x, int_of_float y in
      let Rect.{width ; height} = e#box#get in
      mouse_x >= x && mouse_y >= y
      && mouse_x <= x + width
      && mouse_y <= y + height
    ) el
    in
    match e_opt with
    | None -> ()
    | Some e -> e#interact_resolver#get ()
  end
  