open Ecs
open Component_defs
open System_defs

let resolve (v : Vector.t) (ammo : ammunition) (reacter : tag) =
  ammo#tokill#set true

let fire_laser () =
  let a = new ammunition () in
  let Global.{main_camera ; _} = Global.get () in
  let x = (Player.player ())#position#get.x +. float(Cst.player_width) /. 2. in
  let y = (Player.player ())#position#get.y in
  let target_x = ((float !Global.mouse_x) -. x) +.  main_camera#position#get.x in
  let target_y = ((float !Global.mouse_y) -. y) +. main_camera#position#get.y in
  let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.{x = target_x /. 60. ; y = target_y /. 60.};
    texture = Texture.(red);
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 10.}
    } in
    Block.set_block a values;
    a 