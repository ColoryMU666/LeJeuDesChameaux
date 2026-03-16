open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player1 : player;
  main_camera : camera;
  room : room
}

val is_interacting : bool ref

val mouse_x : int ref
val mouse_y : int ref

val get : unit -> t
val set : t -> unit
