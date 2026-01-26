open Ecs
open Component_defs
open System_defs

type tag += HWall of block | VWall of block | Player of block | Box of block

let create (x, y, v, txt, width, height, mass, default_forces, life, elasticity, tag) =
  let e = new block () in
  e#texture#set txt;
  e#position#set Vector.{x=float x;y = float y};
  e#velocity#set v;
  e#box#set Rect.{width;height};
  e#mass#set mass;
  (match life with
  | None -> e#lifespan#set (-1)
  | Some i -> e#lifespan#set i
  );
  (match default_forces with
  | None -> ()
  | Some f -> e#forces#set f
  );
  e#tag#set (match tag with 
  | 0 -> HWall e 
  | 1 -> VWall e 
  | 2 -> Player e 
  | 3 -> Box e);
  e#elasticity#set elasticity;
  Collision_system.(register (e:>t));
  Move_system.(register (e:>t));
  Draw_system.(register (e:>t));
  Clear_system.(register (e :> t));
  e


let create_random () =
  let x = Cst.window_width / 2 in
  let y = Cst.window_height / 2 in
  let vx = (Random.float 10.) -. 5. in
  let vy = (Random.float 10.) -. 5. in
  let txt = Texture.black in 
  let width = 20 in
  let height = 20 in
  let mass = 1.0 +. (Random.float 99.0) in
  create (x, y, Vector.{x = vx; y = vy}, txt, width, height, mass, Some Cst.g, Some 60, 1., 3)
