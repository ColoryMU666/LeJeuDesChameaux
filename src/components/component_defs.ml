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

class friction () =
  let r = Component.init Vector.{x = 1. ; y = 1.} in
  object
    method friction = r
  end

class mass () =
  let r = Component.init 0.0 in
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

type tag = ..
type tag += No_tag
type tag += Wall_tag
type tag += Player_tag of bool (* is_on_floor *)
type tag += Enemy_tag of bool (* is_on_floor *)

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

class lifespan () = 
  let r = Component.init (-1) in
  object
    method lifespan = r
  end

class elasticity () =
  let r = Component.init 0. in
  object
    method elasticity = r
  end

(** Archetype *)
class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
    inherit friction
    inherit mass
    inherit forces
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

class type physics =
  object 
    inherit Entity.t
    inherit mass
    inherit forces
    inherit velocity
  end

class type drawable =
  object
    inherit Entity.t
    inherit dposition
    inherit position
    inherit box
    inherit texture
  end

class type deletable = 
  object
    inherit Entity.t
    inherit lifespan
  end

class type displayable =
  object
    inherit Entity.t
    inherit position
    inherit dposition
    inherit velocity
  end

(** Real objects *)

class block () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit dposition ()
    inherit box ()
    inherit resolver ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit forces ()
    inherit velocity ()
    inherit friction ()
    inherit tagged ()
    inherit resolver ()
    inherit lifespan ()
    inherit elasticity ()
  end

class player () =
  object
    inherit block ()
    inherit life ()
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
  end