(*
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
V                               V
V  1                         2  V
V  1 B                       2  V
V  1                         2  V
V  1                         2  V
V                               V
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
*)


let window_width = 800
let window_height = 600

let wall_thickness = 32

let hwall_width = window_width
let hwall_height = wall_thickness
let hwall1_x = 0
let hwall1_y = 0
let hwall2_x = 0
let hwall2_y = window_height -  wall_thickness

let vwall_width = wall_thickness
let vwall_height = window_height - 2 * wall_thickness
let vwall1_x = 0
let vwall1_y = wall_thickness
let vwall2_x = window_width - wall_thickness
let vwall2_y = vwall1_y

let player_width = 20
let player_height = 50
let player_color = Texture.black
let g = Vector.{x = 0.0; y = 2. }
let player_speed = 10.
let player_jump_speed = 20.
let player_fast_falling_speed = 0.5

let minimal_speed = 0.1
let elasticity = 0.

let camera_offset = Vector.{
    x = Float.round(float(window_width) *. 0.5 -. float(player_width) /. 2.);
    y = Float.round(float(window_height) *. 0.65)
}