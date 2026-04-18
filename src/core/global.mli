open Component_defs
(* A module to initialize and retrieve the global state *)

type game_state =
  | Playing
  | Player_died of button list
  | Player_won
  | Pause
  | Quit_game

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player1 : player;
  main_camera : camera;
  dungeon : dungeon;
  state : game_state;
}

val is_interacting : bool ref
val is_facing_left : bool ref

val mouse_x : int ref
val mouse_y : int ref

val get : unit -> t
val set : t -> unit
