open Ecs
open Component_defs


type t = killable

let init _ = Gfx.debug "Life_bar system initialised\n%!"

let black = Gfx.color 0 0 0 255
let green = Gfx.color 0 255 0 255
let red = Gfx.color 255 0 0 255

let offset_x = 10
let offset_y = 10
let bar_height = 5
let border_size = 1.



let update _dt el =
  let Global.{window ; ctx ; main_camera ; _} = Global.get () in
  let surface = Gfx.get_surface window in
  Seq.iter (fun (e:t) ->
      let e_pos = (Vector.sub e#position#get main_camera#position#get) in

      let life_pos = Vector.(sub e_pos {x = float(offset_x) ; y = float(offset_y)}) in
      let bar_pos = Vector.(sub life_pos {x = border_size ; y = border_size}) in

      let Rect.{width ; _} = e#box#get in
      let box_width = width + offset_x * 2 in

      let life_ratio = 
        let life = e#life#get in
        if life < 0. then
          0.
        else
          life /. e#max_life#get in
      let life_box = Rect.{
        width = int_of_float(float(box_width) *. life_ratio);
        height = bar_height
      } in

      let bar_box = Rect.{
        width = box_width + int_of_float(border_size *. 2.) ;
        height = bar_height + int_of_float(border_size *. 2.)
      } in

      Texture.draw ctx surface bar_pos bar_box (Color(black));
      if life_ratio < 0. then
        Texture.draw ctx surface life_pos life_box (Color(red))
      else
        Texture.draw ctx surface life_pos life_box (Color(green))
      
    ) el;