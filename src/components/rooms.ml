open Component_defs
open Rect
open System_defs

let small_door_size = {width = 50 ; height = 100}

let door_interact_resolver direction () =
  let Global.{dungeon; _} as g = Global.get () in
  dungeon#change_room#set (Some(direction))

let create_door x y size dir =
  let d = new door () in
  d#direction#set dir;
  Block.set_block d {Block.default_set_values with
    tag = Door;
    pos_x = x -. float(size.width) /. 2.;
    pos_y = y -. float(size.height);
    width = size.width;
    height = size.height;
    z_level = Background;
    texture = !(Texture.unlighted_door_txt)
  };
  d#interact_resolver#set (door_interact_resolver dir);
  Interact_system.register (d :> interactable);
  d

let create_platform x y w h =
  Block.(create {default_set_values with
    pos_x = x -. float(w) /. 2.;
    pos_y = y -. float(h);
    width = w;
    height = h;
    tag = Wall_tag;
    mass = infinity;
    texture = !(Texture.plateform_txt)
  })

let default_room () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let boss_room_left () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = None;
  };
  res

let boss_room_right () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = None;
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let room_left_right () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let room_left () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = None;
  };
  res

let room_right () =
  let res = new room () in
  res#walls#set (Block.walls ());
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = None;
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let room_up () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 500. 100 15;
      create_platform 166. 420. 268 15;
      create_platform 634. 420. 268 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;
      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = None;
    down = None;
    right = None;
  };
  res

let room_down () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = None;
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = None;
  };
  res

let room_up_left_down_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = Some (create_door 82. 500. small_door_size Left);
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = Some (create_door 718. 340. small_door_size Right);
  };
  res

let room_up_left_down () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = Some (create_door 82. 500. small_door_size Left);
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = None;
  };
  res

let room_up_left_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 500. 100 15;
      create_platform 166. 420. 268 15;
      create_platform 634. 420. 268 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;
      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let room_up_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 500. 100 15;
      create_platform 166. 420. 268 15;
      create_platform 634. 420. 268 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;
      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = None;
    down = None;
    right = Some (create_door 700. (float(Cst.hwall2_y)) small_door_size Right);
  };
  res

let room_up_left () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 500. 100 15;
      create_platform 166. 420. 268 15;
      create_platform 634. 420. 268 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;
      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = Some (create_door 100. (float(Cst.hwall2_y)) small_door_size Left);
    down = None;
    right = None;
  };
  res

let room_up_down () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = None;
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = None;
  };
  res

let room_left_down () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 82. 340. small_door_size Left);
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = None;
  };
  res

let room_down_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = None;
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = Some (create_door 718. 340. small_door_size Right);
  };
  res

let room_up_down_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = Some (create_door 400. 180. small_door_size Up);
    left = None;
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = Some (create_door 718. 340. small_door_size Right);
  };
  res

let room_left_down_right () =
  let res = new room () in
  res#walls#set (Array.concat [
    Block.walls ();
    [|create_platform 400. 420. 450 15;

      create_platform 82.  500. 100 15;
      create_platform 82.  340. 100 15;
      create_platform 232. 260. 100 15;

      create_platform 718. 500. 100 15;
      create_platform 718. 340. 100 15;
      create_platform 568. 260. 100 15;

      create_platform 400. 180. 150 15;|]
  ]);
  Array.iter (fun e -> Room_loader.add res (e :> deletable)) [|(Enemy.enemy ()); (Enemy.enemy ())|];
  res#doors#set {
    up = None;
    left = Some (create_door 82. 340. small_door_size Left);
    down = Some (create_door 400. (float(Cst.hwall2_y)) small_door_size Down);
    right = Some (create_door 718. 340. small_door_size Right);
  };
  res