open Ecs
open Component_defs


type t = button

let init _ = Gfx.debug "Draw_death_menu system initialised\n%!"

let bg_color = Gfx.color 0 0 0 180

let font_color = Gfx.color 255 0 0 255

let update _dt el =
  let Global.{window ; ctx ; main_camera ; _} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  Gfx.set_color ctx bg_color;
  Gfx.fill_rect ctx surface 0 0 ww wh;
  Gfx.set_color ctx font_color;
  let txt_surface = Gfx.render_text ctx "YOU DIED" Texture.neon_font in
  Gfx.blit_scale ctx surface txt_surface (ww / 10) (wh / 5) (4 * ww / 5) (2 * wh / 5);

  Seq.iter (fun (b:t) ->
    Texture.draw ctx surface b#position#get b#box#get b#texture#get;

    let Vector.{x = bx ; y = by} = b#position#get in
    let bx, by = (int_of_float bx, int_of_float by) in
    let Rect.{width = bw ; height = bh} = b#box#get in
    Gfx.set_color ctx b#text_color#get;
    let txt_surface = Gfx.render_text ctx b#text#get Texture.neon_font in
    Gfx.blit_scale ctx surface txt_surface 
      (bx + bw / 5) (by + bh / 5) (3 * bw / 5) (3 * bh / 5);

  ) el;