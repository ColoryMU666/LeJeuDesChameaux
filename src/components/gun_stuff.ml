let fire_laser () =
  let x = (Player.player ())#position#get.x +. float(Cst.player_width) /. 2. in
  let y = (Player.player ())#position#get.y in
  Block.create Block.{ Block.default_set_values with
    pos_x = x;
    pos_y = y;
    velocity = Vector.{x = ((float !Global.mouse_x) -. x) /. 60. ; y = ((float !Global.mouse_y) -. y) /. 60.};
    texture = Texture.(red);
    width = 10;
    height = 10;
    lifespan = Some 60;
    elasticity = 0.;
    tag = Ally_projectile_tag {damage = 10.}
    }