open Ecs
open Component_defs
open System_defs

let resolve (v : Vector.t) (player : player) (reacter : tag) =
  player#velocity#set (Vector.mult 2. v);
  player#life#set (player#life#get -. 10.);
  Gfx.debug "The player has been hit : %f/%f\n%!" player#life#get player#max_life#get

let create (pos_x, pos_y, velocity, texture, width, height, mass) =
  let p = new player () in
  Block.set_block p {Block.default_set_values with
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
    resolve = (fun (v:Vector.t) (reacter:tag) -> resolve v p reacter);
    tag = Player_tag {is_on_floor = false}
  };
  p#curent_gun#set (Some (Gun.create_glock ()));
  Lifebar_draw_system.(register (p:>t));
  Player_manager_system.(register (p:>t));
  p


let create_player () = create (100., 100., Vector.{x=0. ; y=0.}, Texture.blue, 20, 50, 1.)

let player () = 
  let Global.{player1; _} = Global.get () in
  player1

let move_direction d =
  let Global.{player1; _} = Global.get () in
  player1#forces#set Vector.(add {x = (d *. Cst.player_speed) ; y = 0.} player1#forces#get)

let jump () =
  let Global.{player1; _} = Global.get () in
  match player1#tag#get with
    | Player_tag {is_on_floor = true} ->
      player1#tag#set (Player_tag {is_on_floor = false});
      player1#velocity#set Vector.{x = player1#velocity#get.x ; y = -.Cst.player_jump_speed}
    | _ -> ()

let fast_falling d =
  let Global.{player1; _} = Global.get () in
  player1#forces#set Vector.(add {x = 0.; y = (d *. Cst.player_fast_falling_speed)} player1#forces#get)