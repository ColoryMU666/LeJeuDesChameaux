open Ecs
open Component_defs
open System_defs

(*
Glock id = 0
Laser id = 1
Shotgun id = 2
Rocket launcher id = 3
*)

let resolve (v : Vector.t) (ammo : ammunition) (reacter : tag) =
  ammo#tokill#set true

let resolve_rl (v : Vector.t) (ammo : ammunition) (reacter : tag) =
  ammo#tokill#set true;
  let a  = new ammunition () in
  let values = Block.{ Block.default_set_values with
    pos_x = ammo#position#get.x -. 50.;
    pos_y = ammo#position#get.y -. 50.;
    velocity = Vector.zero;
    texture = !(Texture.explosion_txt);
    width = 100;
    height = 100;
    resolve = (fun (v:Vector.t) (reacter:tag) -> ());
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 50.}
    } in
  Block.set_block a values;
  Time.create_timer 10. (fun dt -> a#tokill#set true)
  
let interact_resolver (gun : gun) =
  Gfx.debug "interaction avec gun d'id %d\n%!" gun#gun_id#get;
  let Global.{player1; _} = Global.get () in
  (match player1#curent_gun#get with
  | Some g -> (if !Global.is_facing_left then
                let dim = g#box#get in
                g#position#set (Vector.add player1#position#get Vector.{ x = -1. -. (float dim.width) ; y = 0.})
              else
                g#position#set (Vector.add player1#position#get Vector.{ x = (float Cst.player_width) +. 1. ; y = 0.}));
   g#tokill#set false;
   Draw_system.(register (g :> t));
   Collision_system.(register (g :> t));
   Clear_system.(register (g :> t));
   Move_system.(register (g :> t));
   Interact_system.(register (g :> t))
  | _ -> ());
  player1#curent_gun#set (Some(gun));
  gun#tokill#set true

let fire_laser () =
  let a = new ammunition () in
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = player1#position#get.x +. float(Cst.player_width) /. 2. in
  let y = player1#position#get.y +. float(Cst.player_height) /. 2. in
  let target_x = ((float !Global.mouse_x) -. x) +. main_camera#position#get.x in
  let target_y = ((float !Global.mouse_y) -. y) +. main_camera#position#get.y in
  let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.(mult 5. (normalize {x = target_x ; y = target_y}));
    texture = !(Texture.laser_laser_txt);
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 10.}
    } in
  Block.set_block a values

let fire_glock () =
  let a = new ammunition () in
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = player1#position#get.x +. float(Cst.player_width) /. 2. in
  let y = player1#position#get.y +. float(Cst.player_height) /. 2. in
  let target_x = ((float !Global.mouse_x) -. x) +. main_camera#position#get.x in
  let target_y = ((float !Global.mouse_y) -. y) +. main_camera#position#get.y in
  let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.(mult 5. (normalize {x = target_x ; y = target_y}));
    texture = if target_x < 0. then !(Texture.glock_bullet_txt_reverted) else !(Texture.glock_bullet_txt);
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 1.}
    } in
  Block.set_block a values

let fire_shotgun () =
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = player1#position#get.x +. float(Cst.player_width) /. 2. in
  let y = player1#position#get.y +. float(Cst.player_height) /. 2. in
  let target_x = ((float !Global.mouse_x) -. x) +. main_camera#position#get.x in
  let target_y = ((float !Global.mouse_y) -. y) +. main_camera#position#get.y in
  for i = -2 to 2 do
    let a = new ammunition () in
    let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.(mult 10. (normalize {x = target_x +. ((float i) *. 20.); y = target_y +. ((float i) *. 20.)}));
    texture = if target_x < 0. then !(Texture.shotgun_pelet_txt_reverted) else !(Texture.shotgun_pelet_txt);
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 25.}
    } in
  Block.set_block a values
  done

let fire_rl () =
  let a = new ammunition () in
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = player1#position#get.x +. float(Cst.player_width) /. 2. in
  let y = player1#position#get.y +. float(Cst.player_height) /. 2. in
  let target_x = ((float !Global.mouse_x) -. x) +. main_camera#position#get.x in
  let target_y = ((float !Global.mouse_y) -. y) +. main_camera#position#get.y in
  let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.(mult 5. (normalize {x = target_x ; y = target_y}));
    texture = if target_x < 0. then !(Texture.rl_rocket_txt_reverted) else !(Texture.rl_rocket_txt);
    width = 32;
    height = 16;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve_rl v a reacter);
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 30.}
    } in
  Block.set_block a values

let fire_func_ar = [|fire_glock; fire_laser; fire_shotgun ; fire_rl|]

let handle_fire (gun : gun) =
  if gun#can_shoot#get then begin
    ignore(fire_func_ar.(gun#gun_id#get) ());
    gun#can_shoot#set false;
    Time.create_timer
      gun#fire_rate#get
      (fun dt -> gun#can_shoot#set true);
  end
  else
    ()

let create_laser () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
    pos_x = 200.;
    pos_y = 100.;
    texture = !(Texture.laser_txt);
    width = 61;
    height = 32;
    default_forces = Some(Cst.g);
    tag = Gun_tag {gunType = 1};
  };
  g#shoot#set (fun () -> handle_fire g);
  g#gun_id#set 1;
  g#fire_rate#set 1.;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g 

let create_glock () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
    pos_x = 200.;
    pos_y = 100.;
    texture = !(Texture.glock_txt);
    width = 30;
    height = 20;
    default_forces = Some(Cst.g);
    tag = Gun_tag {gunType = 0};
  };
  g#shoot#set (fun () -> handle_fire g);
  g#gun_id#set 0;
  g#fire_rate#set 500.;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g

let create_shotgun () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
    pos_x = 200.;
    pos_y = 100.;
    texture = !(Texture.shotgun_txt);
    width = 49;
    height = 16;
    default_forces = Some(Cst.g);
    tag = Gun_tag {gunType = 2};
  };
  g#shoot#set (fun () -> handle_fire g);
  g#gun_id#set 2;
  g#fire_rate#set 1000.;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g

let create_rl () =
  let g = new gun () in
  Block.set_block g {Block.default_set_values with
    pos_x = 200.;
    pos_y = 100.;
    texture = !(Texture.rl_txt) (*Texture.cyan*);
    width = 59;
    height = 11;
    default_forces = Some(Cst.g);
    tag = Gun_tag {gunType = 3};
  };
  g#shoot#set (fun () -> handle_fire g);
  g#gun_id#set 3;
  g#fire_rate#set 1000.;
  g#interact_resolver#set (fun () -> interact_resolver g);
  Interact_system.(register (g :> t));
  g