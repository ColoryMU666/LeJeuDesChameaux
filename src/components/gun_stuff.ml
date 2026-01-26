let fire_laser () =
  let x = int_of_float ((Player.player1())#position#get.x) + Cst.player_width in
  let y = int_of_float ((Player.player1())#position#get.y) in
  Block.create (
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