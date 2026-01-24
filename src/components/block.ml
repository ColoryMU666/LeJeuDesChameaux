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


let walls () =
  List.map create
    Cst.[ 
      (hwall1_x, hwall1_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity, None, None, 0., 0);
      (hwall2_x, hwall2_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity, None, None, 0., 0);
      (vwall1_x, vwall1_y, Vector.zero, Texture.green, vwall_width, vwall_height, infinity, None, None, 0., 1);
      (vwall2_x, vwall2_y, Vector.zero, Texture.green, vwall_width, vwall_height, infinity, None, None, 0., 1)
    ]


let players () =  
  create Cst.(player1_x, player1_y, Vector.zero, player_color, player_width, player_height, 100.,Some Cst.g, None, 0., 2)


let player1 () = 
  let Global.{player1; _ } = Global.get () in
  player1

let stop_players () = 
  let Global.{player1; _ } = Global.get () in
  player1#velocity#set Vector.zero;
  ()

let move_player player v =
  player#velocity#set  (Vector.add v player#velocity#get);
  ()

let player_jump player =
  player#velocity#set (Vector.add Cst.player_v_jump player#velocity#get)

let fire_laser () =
  let x = int_of_float ((player1())#position#get.x) + Cst.player_width in
  let y = int_of_float ((player1())#position#get.y) in
  create (
    x,
    y,
    Vector.{x = ((float !Global.mouse_x) -. (float x)) /. 60. ; y = ((float !Global.mouse_y) -. (float y)) /. 60.},
    Texture.(red),
    10,
    10,
    infinity,
    None,
    Some 60,
    0.,
    3
    )

let camera_move v el = 
  Seq.iter (fun (e) -> e#position#set (Vector.sub e#position#get v)) el