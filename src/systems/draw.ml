open Ecs
open Component_defs


type t = drawable

let init _ = Gfx.debug "Drawn system initialised\n%!"

let update _dt el =
  let Global.{window;ctx;main_camera;player1} = Global.get () in
  let surface = Gfx.get_surface window in
  Seq.iter (fun (e:t) ->
      let pos = (Vector.sub e#position#get main_camera#position#get) in
      let box = e#box#get in
      let txt = e#texture#get in
      Texture.draw ctx surface pos box txt
    ) el;