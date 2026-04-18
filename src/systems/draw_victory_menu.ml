open Ecs
open Component_defs


type t = button

let init _ = Gfx.debug "Draw_victory_menu system initialised\n%!"

let bg_color = Gfx.color 0 0 0 255

let font_color = Gfx.color 0 0 255 255

let update _dt el =
  let Global.{window ; ctx ; player1 ; _} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in

  (* Draw background *)
  Gfx.set_color ctx bg_color;
  Gfx.fill_rect ctx surface 0 0 ww wh;

  (* Draw text *)
  Gfx.set_color ctx font_color;
  let txt_surface = Gfx.render_text ctx "VICTORY" Texture.neon_font in
  Gfx.blit_scale ctx surface txt_surface (ww / 10) (wh / 20) (4 * ww / 5) (2 * wh / 5);

  (* Player, Crown and light *)
  let Rect.{width = pw ; height = ph} = player1#box#get in
  let x = float (ww / 2) -. (float pw) *. 1.5 in
  let y = float (wh / 2) in
  (* Draw light behind player *)
  let lw = pw * 6 in
  let lh = ph * 6 in
  let lx = float (ww / 2) -. (float lw) *. 0.5 in
  let ly = float (wh / 2) -. (float (lh - ph * 3)) *. 0.5 in
  Texture.draw ctx surface
    Vector.{x = lx; y = ly}
    Rect.{width = lw ; height = lh}
    !Texture.light_txt;
  (* Draw player *)
  Texture.draw ctx surface 
    Vector.{x; y} 
    Rect.{width = pw * 3 ; height = ph * 3} 
    !Texture.player_txt;
  (* Draw crown on top of player *)
  let cw = int_of_float (float (pw * 3) *. 0.8) in
  let ch = cw / 2 in
  let cx = float (ww / 2) -. (float cw) *. 0.5 in
  let cy = y -. float ch in
  Texture.draw ctx surface
    Vector.{x = cx; y = cy}
    Rect.{width = cw ; height = ch}
    !Texture.crown_txt;

  (* Draw buttons *)
  Seq.iter (fun (b:t) ->
    Texture.draw ctx surface b#position#get b#box#get b#texture#get;

    let Vector.{x = bx ; y = by} = b#position#get in
    let bx, by = (int_of_float bx, int_of_float by) in
    let Rect.{width = bw ; height = bh} = b#box#get in
    Gfx.set_color ctx b#text_color#get;
    let txt_surface = Gfx.render_text ctx b#text#get Texture.neon_font in
    Gfx.blit_scale ctx surface txt_surface 
      (bx + bw / 10) (by + bh / 10) (4 * bw / 5) (4 * bh / 5);

  ) el;