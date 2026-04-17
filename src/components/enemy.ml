open Ecs
open Component_defs
open System_defs

let resolve_ammo (v : Vector.t) (ammo : ammunition) (reacter : tag) =
  ammo#tokill#set true

let resolve (v : Vector.t) (enemy : enemy) (reacter : tag) =
  (match reacter with
  | Ally_projectile_tag {damage} -> enemy#life#set (enemy#life#get -. damage);
  | _ -> ());
  if enemy#life#get <= Float.zero then
    enemy#tokill#set true;
  (*enemy#velocity#set (Vector.mult 10. v);*)
  
  (*Gfx.debug "The enemy has been hit\n%!"*)
  ()


let rec create_action_timer (enemy:enemy)=
    Time.create_timer 1000. (fun dt -> 
      if not enemy#tokill#get then
        enemy#action#get () ; create_action_timer enemy)

let act_shooter (src:enemy) = 
  let a = new ammunition () in
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = if src#position#get > player1#position#get then src#position#get.x 
          else src#position#get.x +. float src#box#get.width in
  let y = src#position#get.y +. 5. in
  let target_x = (player1#position#get.x +. float(Cst.player_width) /. 2. -. x) in
  let target_y = (player1#position#get.y +. float(Cst.player_height) /. 2. -. y) in
  let values = Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.(mult 5. (normalize {x = target_x ; y = target_y}));
    texture = !(Texture.enemy_bullet_txt);
    width = 10;
    height = 10;
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve_ammo v a reacter);
    elasticity = 0.;
    tag = Enemy_projectile_tag {damage = 10.}
    } in
  (if target_x < 0. then
    src#texture#set !(Texture.turret_txt_reverted)
  else
    src#texture#set !(Texture.turret_txt));
  Block.set_block a values


let act_boss (src:enemy) = 
  let Global.{main_camera ; player1 ; _} = Global.get () in
  let x = src#position#get.x in
  let y = src#position#get.y in
  let target_x = (player1#position#get.x +. float(Cst.player_width) /. 2. -. x) in
  let target_y = (player1#position#get.y +. float(Cst.player_height) /. 2. -. y) in
  src#velocity#set Vector.{x = target_x ; y = target_y}

let create_shooter (pos_x, pos_y, velocity, texture, width, height, mass) =
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
  e#action#set (fun () -> act_shooter e);
  create_action_timer e;
  Draw_lifebar_system.(register (e:>t));
  e

let create_boss (pos_x, pos_y, velocity, texture, width, height, mass) =
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
  e#action#set (fun () -> act_boss e);
  e#max_life#set 1000.;
  e#life#set e#max_life#get;
  create_action_timer e;
  Draw_lifebar_system.(register (e:>t));
  e

let enemy () = create_shooter (300., 300., Vector.{x=0. ; y=0.}, !(Texture.turret_txt), 40, 50, 1.)
let boss () = create_boss (300., 300., Vector.{x=0. ; y=0.}, (Texture.red), 100, 100, 10.)
