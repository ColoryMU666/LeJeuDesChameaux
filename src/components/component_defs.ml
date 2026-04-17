open Ecs

class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class dposition () =
  let r = Component.init Vector.zero in
  object 
    method dposition = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end


class can_move () =
  let r = Component.init true in
  object
    method can_move = r
  end

class friction () =
  let r = Component.init Vector.{x = 1. ; y = 1.} in
  object
    method friction = r
  end

class mass () =
  let r = Component.init 1.0 in
  object
    method mass = r
  end

class forces () =
  let r = Component.init Vector.zero in
  object
    method forces = r
  end

class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

class life () = 
  let r1 = Component.init 100.0 in
  let r2 = Component.init 100.0 in
  object
    method life = r1
    method max_life = r2
  end

class action () = 
  let r = Component.init (fun () -> ()) in
  let b = Component.init true in
  object
    method action = r
    method can_act = b
  end

type tag =
  | No_tag
  | Wall_tag
  | Player_tag of {is_on_floor : bool}
  | Ally_projectile_tag of {damage : float}
  | Enemy_tag of {is_on_floor : bool}
  | Enemy_projectile_tag of {damage : float}
  | Gun_tag of {gunType : int}
  | Door

class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tag) -> ()) in
  object
    method resolve = r
  end

class time_left () = 
  let r1 = Component.init (-1.) in
  let r2 = Component.init (fun (dt: float) -> ()) in
  object
    method time_left = r1
    method time_out_fun = r2
  end

class elasticity () =
  let r = Component.init 0. in
  object
    method elasticity = r
  end

class tokill () = 
  let r = Component.init false in
  object
    method tokill = r
  end

class shoot () =
  let r = Component.init (fun () -> ()) in
  object
    method shoot = r
  end

class gun_id () =
  let r = Component.init 0 in
  object
    method gun_id = r
  end

class can_shoot () =
  let r = Component.init true in
  object
    method can_shoot = r
  end

class fire_rate () =
  let r = Component.init 0. in
  object
    method fire_rate = r
  end

class interact_resolver () =
  let r = Component.init (fun () -> ()) in
  object
    method interact_resolver = r
  end

(** Archetype *)
class type physics =
  object 
    inherit Entity.t
    inherit mass
    inherit forces
    inherit velocity
    inherit friction
  end

class type movable =
  object
    inherit Entity.t
    inherit position
    inherit physics
  end

class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit mass
    inherit velocity
    inherit resolver
    inherit tagged
    inherit forces
    inherit elasticity
  end


class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
    inherit tagged
  end

class type deletable = 
  object
    inherit Entity.t
    inherit tokill
  end

class type killable = 
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit life
  end

class type timeable =
  object
    inherit Entity.t
    inherit time_left
    inherit deletable
  end

class type interactable =
  object
    inherit Entity.t
    inherit interact_resolver
    inherit box
    inherit position
  end

(** Real objects *)

class block () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit resolver ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit forces ()
    inherit velocity ()
    inherit friction ()
    inherit tokill ()
    inherit elasticity ()
  end

class camera () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit velocity ()
    inherit forces ()
    inherit friction ()
    inherit mass ()
  end

class timer () =
  object
    inherit Entity.t ()
    inherit time_left ()
    inherit tokill ()
  end

class ammunition () =
  object
    inherit block ()
  end

class gun () =
  object
    inherit block ()
    inherit shoot ()
    inherit gun_id ()
    inherit can_shoot ()
    inherit fire_rate ()
    inherit interact_resolver ()
  end

class player () =
  let r = Component.init (None : gun option) in
  object
    inherit block ()
    inherit life ()
    inherit can_move ()
    inherit can_shoot ()
    inherit fire_rate ()
    method curent_gun = r;
  end

class enemy () =
  object
    inherit block ()
    inherit life ()
    inherit action ()
  end

type direction =
  | Up
  | Left
  | Right
  | Down

class door () =
  let d = Component.init Up in
  object
    inherit block ()
    inherit interact_resolver ()
    method direction = d
  end

type doors = {
  up : door option;
  left : door option;
  down : door option;
  right : door option;
}

class room () =
  let walls = Component.init ([||] : block array) in
  let doors = Component.init ({up = None; left = None; down = None; right = None} : doors) in
  let temporary_objects = Component.init([] : deletable List.t) in
  object
    inherit Entity.t ()
    method walls = walls
    method doors = doors
    (* temporary objects contains enemies, bullets, weapons on the ground, items, timers *)
    method temporary_objects = temporary_objects
  end

type room_doors = {
  up : bool;
  left : bool;
  down : bool;
  right : bool;
}

type room_tag =
  | Boss_room
  | Start_room
  | Enemy_room
  | Treasure_room

type room_map = {
  room_blueprint_id : int;
  doors : room_doors;
  room_tag : room_tag;
  room_creator : room_doors -> room
}

type dungeon_layout = {
  rooms : room_map option array array;
  links : ((int * int) * (int * int)) list
}

class dungeon () =
  let layout = Component.init ({rooms = [||] ; links = []} : dungeon_layout) in
  let visited = Component.init ([||] : bool array array) in
  let curent = Component.init (None : room option) in
  let change_room = Component.init (None : direction option) in
  let current_room_pos = Component.init (0, 0) in
  let start_room_pos = Component.init (0, 0) in
  let boss_room_pos = Component.init (0, 0) in
  object
    method layout = layout
    method visited = visited
    method current_room = curent
    method current_room_pos = current_room_pos
    method start_room_pos = start_room_pos
    method boss_room_pos = boss_room_pos
    method change_room = change_room
  end