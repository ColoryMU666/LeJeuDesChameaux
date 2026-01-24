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
let player1_x = wall_thickness
let player1_y = window_height - wall_thickness - player_height
let player_color = Texture.black

let player_v_up = Vector.{ x = 0.0; y = -5.0 }
let player_v_down = Vector.sub Vector.zero player_v_up
let player_v_left = Vector.{ x = -5.0 ; y = 0.0 }
let player_v_right = Vector.sub Vector.zero player_v_left
let player_v_jump = Vector.{ x = 0.0 ; y = -30.0 }

let g = Vector.{x = 0.0; y = 3.1 }
let gy = 1.1