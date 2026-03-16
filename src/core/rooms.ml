open Component_defs
open Rect
let small_door_size = {width = 50 ; height = 100}

let create_door x y size =
  Block.create {Block.default_set_values with
    tag = Door;
    pos_x = x -. float(size.width) /. 2.;
    pos_y = y -. float(size.height);
    width = size.width;
    height = size.height;
    z_level = Background;
  }

let default_room () =
  let res = new room () in
  res#walls#set (Block.walls ());
  res#enemies#set [|(Enemy.enemy ())|];
  res#doors#set [|
    create_door 100. (float(Cst.hwall2_y)) small_door_size;
    create_door 700. (float(Cst.hwall2_y)) small_door_size;
  |];
  res