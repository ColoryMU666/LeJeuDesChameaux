open Ecs
open Component_defs
open System_defs

(*
Glock id = 0
Laser id = 1
*)

let resolve (v : Vector.t) (ammo : ammunition) (reacter : tag) =
  ammo#tokill#set true

let interact_resolver (gun : gun) =
  let Global.{player1; _} = Global.get () in
  player1#gun_id#set gun#gun_id#get;
  gun#tokill#set true

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

let fire_glock () =
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
    texture = Texture.cyan;
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 1.}
    } in
    Block.set_block a values;
    a

let create_laser () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
  pos_x = 200.;
  pos_y = 100.;
  texture = Texture.magenta;
  width = 10;
  height = 10;
  default_forces = Some(Cst.g);
  tag = Gun_tag {gunType = 1};
  };
  g#fire_seter#set  (fun() -> ignore (fire_laser ()));
  g#gun_id#set 1;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g 

let create_glock () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
  pos_x = 200.;
  pos_y = 100.;
  texture = Texture.yellow;
  width = 10;
  height = 10;
  default_forces = Some(Cst.g);
  tag = Gun_tag {gunType = 0};
  };
  g#fire_seter#set  (fun() -> ignore (fire_glock ()));
  g#gun_id#set 0;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g

let fire_func_ar = [|fire_glock; fire_laser|]

let handle_fire () = 
  let Global.{player1; _} = Global.get () in
  fire_func_ar.(player1#gun_id#get) ()