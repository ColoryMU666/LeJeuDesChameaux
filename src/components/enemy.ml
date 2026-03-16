open Ecs
open Component_defs
open System_defs

let resolve (v : Vector.t) (enemy : enemy) (reacter : tag) =
  (match reacter with
  | Ally_projectile_tag {damage} -> enemy#life#set (enemy#life#get -. damage);
  | _ -> ());
  (*enemy#velocity#set (Vector.mult 10. v);*)
  
  (*Gfx.debug "The enemy has been hit\n%!"*)
  ()

let create (pos_x, pos_y, velocity, texture, width, height, mass) =
  let e = new enemy () in
  Block.set_block e {Block.default_set_values with
    pos_x;
    pos_y;
    velocity;
    texture;
    width;
    height;
    mass;
    friction_x = 0.5;
    friction_y = 1.;
    default_forces = Some(Cst.g);
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v e reacter);
    tag = Enemy_tag {is_on_floor = false}
  };
  Lifebar_draw_system.(register (e:>t));
  e

let enemy () = create (300., 300., Vector.{x=0. ; y=0.}, Texture.red, 20, 50, 1.)