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
let color_bg = Color (Gfx.color 0 0 0 130)
let color_visited = Color (Gfx.color 180 170 160 255)
let color_unvisited = Color (Gfx.color 60 55 50 255)
let color_current = Color (Gfx.color 240 160 40 255)
let color_start = Color (Gfx.color 40 240 40 255)
let color_boss = Color (Gfx.color 240 40 40 255)
let color_link = Color (Gfx.color 60 55 50 255)

let glock_txt = ref (Color (Gfx.color 0 255 0 255))
let glock_bullet_txt = ref (Color (Gfx.color 0 255 0 255))
let glock_bullet_txt_reverted = ref (Color (Gfx.color 0 255 0 255))
let player_txt = ref (Color (Gfx.color 0 255 0 255))
let player_txt_reverted = ref (Color (Gfx.color 0 255 0 255))
let rl_txt = ref (Color (Gfx.color 0 255 0 255))
let rl_rocket_txt = ref (Color (Gfx.color 0 255 0 255))
let rl_rocket_txt_reverted = ref (Color (Gfx.color 0 255 0 255))
let explosion_txt = ref (Color (Gfx.color 0 255 0 255))
let shotgun_txt = ref (Color (Gfx.color 0 255 0 255))
let shotgun_pelet_txt = ref (Color (Gfx.color 0 255 0 255))
let shotgun_pelet_txt_reverted = ref (Color (Gfx.color 0 255 0 255))
let laser_txt = ref (Color (Gfx.color 0 255 0 255))
let laser_laser_txt = ref (Color (Gfx.color 0 255 0 255))
let left_wall_txt = ref (Color (Gfx.color 0 255 0 255))
let right_wall_txt = ref (Color (Gfx.color 0 255 0 255))
let floor_txt = ref (Color (Gfx.color 0 255 0 255))
let ceiling_txt = ref (Color (Gfx.color 0 255 0 255))
let lighted_door_txt = ref (Color (Gfx.color 0 255 0 255))
let unlighted_door_txt = ref (Color (Gfx.color 0 255 0 255))
let turret_txt = ref (Color (Gfx.color 0 255 0 255))
let turret_txt_reverted = ref (Color (Gfx.color 0 255 0 255))
let enemy_bullet_txt = ref (Color (Gfx.color 0 255 0 255))
let plateform_txt = ref (Color (Gfx.color 0 255 0 255))
let bg_txt = ref (Color (Gfx.color 0 255 0 255))



let load_txt ctx =
  glock_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/Glock - P80 [64x48].png"));
  glock_bullet_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Glock - P80/Bullet.png"));
  glock_bullet_txt_reverted := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Glock - P80/Bullet_reverted.png"));

  rl_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/Bazooka - M20 [192x32].png"));
  rl_rocket_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Bazooka - M20 - Copy/M20 Rocket.png"));
  rl_rocket_txt_reverted := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Bazooka - M20 - Copy/M20 Rocket_reverted.png"));
  explosion_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/explosions/orange_explosion.png"));

  laser_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/Laser - L3000.png"));
  laser_laser_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Laser - L3000/laser.png"));

  shotgun_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Guns/shotgun.png"));
  shotgun_pelet_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Shotgun/Shotgun_pellet.png"));
  shotgun_pelet_txt_reverted := Image (Gfx.get_resource (Gfx.load_image ctx "resources/gun_assets/individual_sprites/Bullets & Ammo/Shotgun/Shotgun_pellet_reverted.png"));

  player_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/player_assets/player_noweapon.png"));
  player_txt_reverted := Image (Gfx.get_resource (Gfx.load_image ctx "resources/player_assets/player_noweapon_reverted.png"));

  left_wall_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/left_wall.png"));
  right_wall_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/right_wall.png"));
  floor_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/floor.png"));
  ceiling_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/ceiling.png"));
  plateform_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/plateform.png"));
  bg_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/BG.png"));

  lighted_door_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/lighted_door.png"));
  unlighted_door_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/terrain/unlighted_door.png"));

  turret_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/enemy_assets/turret.png"));
  turret_txt_reverted := Image (Gfx.get_resource (Gfx.load_image ctx "resources/enemy_assets/turret_reverted.png"));
  enemy_bullet_txt := Image (Gfx.get_resource (Gfx.load_image ctx "resources/enemy_assets/shot.png"))
  

let draw ctx dst pos box src=
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  let Rect.{width;height} = box in
  match src with
    Image img -> 
      Gfx.blit_scale ctx dst img x y width height
  | Color c ->
    Gfx.set_color ctx c;
    Gfx.fill_rect ctx dst x y width height