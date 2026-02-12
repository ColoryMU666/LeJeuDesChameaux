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

type tag =
  | No_tag
  | Wall_tag
  | Player_tag of {is_on_floor : bool}
  | Ally_projectile_tag of {damage : float}
  | Enemy_tag of {is_on_floor : bool}
  | Enemy_projectile_tag of {damage : float}

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
    inherit resolver
    inherit elasticity
  end


class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
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

class player () =
  object
    inherit block ()
    inherit life ()
    inherit can_move ()
  end

class enemy () =
  object
    inherit block ()
    inherit life ()
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

class ammunition () =
  object
    inherit block ()
  end

class timer () =
  object
    inherit Entity.t ()
    inherit time_left ()
    inherit tokill ()
  end
