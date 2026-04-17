open Ecs
open Component_defs


type t = drawable

let init _ = Gfx.debug "Drawn_background system initialised\n%!"

let white = Gfx.color 0 255 255 255

let update dt el =
  let Global.{window;ctx;main_camera;player1} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  (*Gfx.set_color ctx white;
  Gfx.fill_rect ctx surface 0 0 ww wh;*)
  Texture.draw ctx surface Vector.{x = 0. ; y = 0.} Rect.{width = ww ; height = wh} !(Texture.bg_txt);
  
  Draw.update dt el