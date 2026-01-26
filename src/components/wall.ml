let walls () =
  List.map Block.create
    Cst.[ 
      (hwall1_x, hwall1_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity, None, None, 0., 0);
      (hwall2_x, hwall2_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity, None, None, 0., 0);
      (vwall1_x, vwall1_y, Vector.zero, Texture.green, vwall_width, vwall_height, infinity, None, None, 0., 1);
      (vwall2_x, vwall2_y, Vector.zero, Texture.green, vwall_width, vwall_height, infinity, None, None, 0., 1)
    ]