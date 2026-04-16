open Ecs
open Component_defs
open System_defs

type z_level =
  | Background
  | Front

type set_block_values ={
  pos_x : float;
  pos_y : float;
  velocity : Vector.t;
  texture : Texture.t;
  width : int;
  height : int;
  mass : float;
  friction_x : float;
  friction_y : float;
  default_forces : Vector.t option;
  elasticity : float;
  resolve : Vector.t -> tag -> unit;
  tag : tag;
  z_level : z_level
}

let default_set_values = {
  pos_x = 0.;
  pos_y = 0.;
  velocity = Vector.zero;
  texture = Texture.black;
  width = 100;
  height = 100;
  mass = 1.;
  friction_x = 1.;
  friction_y = 1.;
  default_forces = None;
  elasticity = 1.0;
  resolve = (fun (_ : Vector.t) (_ : tag) -> ());
  tag = No_tag;
  z_level = Front

}

let set_block b values =
  b#texture#set values.texture;
  b#position#set Vector.{x = values.pos_x ; y = values.pos_y};
  b#velocity#set values.velocity;
  b#box#set Rect.{width = values.width ; height = values.height};
  b#mass#set values.mass;
  b#friction#set (Vector.{x = values.friction_x ; y = values.friction_y});
  b#elasticity#set values.elasticity;
  b#tag#set values.tag;
  b#resolve#set values.resolve;
  (match values.default_forces with
  | None -> ()
  | Some f -> b#forces#set f
  );
  Collision_system.(register (b:>t));
  Move_system.(register (b:>t));
  (match values.z_level with
  | Front -> Draw_system.(register (b:>t))
  | Background -> Draw_background_system.(register (b:>t)));
  Clear_system.(register (b :> t));
  ()

let create values =
  let b = new block () in
  set_block b values;
  b


let create_random () =
  let values = { default_set_values with
    pos_x = float(Cst.window_width) /. 2.;
    pos_y = float(Cst.window_height) /. 2.;
    velocity = Vector.{x = (Random.float 10.) -. 5. ; y = (Random.float 10.) -. 5.};
    texture = Texture.black;
    width = 20;
    height = 20;
    mass = 1.0 +. (Random.float 20.0);
  } in
  create values


let walls () =
  let hvalues = Cst.{ default_set_values with
    mass = infinity;
    width = hwall_width;
    height = hwall_height;
    texture = Texture.blue;
    elasticity = 0.;
    tag = Wall_tag;
  } in
  let vvalues = Cst.{ default_set_values with
    mass = infinity;
    width = vwall_width;
    height = vwall_height;
    texture = Texture.green;
    elasticity = 0.;
    tag = Wall_tag;
  } in
  Array.map create
    Cst.[| 
      {hvalues with pos_x = float(hwall1_x) ; pos_y = float(hwall1_y) ; texture = !(Texture.ceiling_txt)};
      {hvalues with pos_x = float(hwall2_x) ; pos_y = float(hwall2_y) ; texture = !(Texture.floor_txt)};
      {vvalues with pos_x = float(vwall1_x) ; pos_y = float(vwall1_y) ; texture = !(Texture.left_wall_txt)};
      {vvalues with pos_x = float(vwall2_x) ; pos_y = float(vwall2_y) ; texture = !(Texture.right_wall_txt)}
    |]


let create_background () = 
  let b = new block () in
  let values = {default_set_values with 
  pos_x = 0.;
  pos_y = 0.;
  width = Cst.window_width;
  height = Cst.window_height;
  texture = Texture.magenta;
  mass = infinity} in
  set_block b values;
  Draw_background_system.(register (b :> t));
  ()