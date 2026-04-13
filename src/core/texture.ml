type t =
    Image of Gfx.surface
  | Color of Gfx.color

let black = Color (Gfx.color 0 0 0 255)
let white = Color (Gfx.color 255 255 255 255)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)
let yellow = Color (Gfx.color 255 255 0 255)
let cyan = Color (Gfx.color 0 255 255 255)
let magenta = Color(Gfx.color 255 0 255 255)
let purple = Color(Gfx.color 92 34 191 255)
let transparent = Color (Gfx.color 0 0 0 0)
let color_bg        = Color (Gfx.color 0   0   0   130)
let color_visited   = Color (Gfx.color 180 170 160 255)
let color_unvisited = Color (Gfx.color 60  55  50  255)
let color_current   = Color (Gfx.color 240 160 40  255)
let color_link      = Color (Gfx.color 60  55  50  255)

let glock_txt = ref (Color (Gfx.color 0 0 0 0))
let glock_bullet_txt = ref (Color (Gfx.color 0 0 0 0))
let player_txt = ref (Color (Gfx.color 0 0 0 0))
let rl_txt = ref (Color (Gfx.color 0 0 0 0))
let rl_rocket_txt = ref (Color (Gfx.color 0 0 0 0))
let shotgun_txt = ref (Color (Gfx.color 0 0 0 0))
let shotgun_pelet_txt = ref (Color (Gfx.color 0 0 0 0))
let laser_txt = ref (Color (Gfx.color 0 0 0 0))
let laser_laser_txt = ref (Color (Gfx.color 0 0 0 0))

let load_txt ctx =
  glock_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/Glock - P80 [64x48].png"));
  glock_bullet_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Glock - P80/Bullet.png"));

  rl_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/Bazooka - M20 [192x32].png"));
  rl_rocket_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Bazooka - M20 - Copy/M20 Rocket.png"));

  laser_laser_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Laser - L3000/laser.png"));

  shotgun_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/shotgun.png"));
  shotgun_pelet_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Shotgun/Shotgun_pellet.png"));

  player_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/player_assets/player_noweapon.png"))
  

let draw ctx dst pos box src =
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  let Rect.{width;height} = box in
  match src with
    Image img -> Gfx.blit_scale ctx dst img x y width height
  | Color c ->
    Gfx.set_color ctx c;
    Gfx.fill_rect ctx dst x y width height