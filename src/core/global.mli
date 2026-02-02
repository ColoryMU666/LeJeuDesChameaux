open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  main_camera : camera;
}

val mouse_x : int ref
val mouse_y : int ref

val get : unit -> t
val set : t -> unit
