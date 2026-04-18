open Component_defs

type game_state =
  | Playing
  | Pause

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player1 : player;
  main_camera : camera;
  dungeon : dungeon;
  state : game_state;
}

let is_interacting = ref false
let is_facing_left = ref false
let game_lost  = ref false
let game_won = ref false
let mouse_x = ref 0
let mouse_y = ref 0
let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s
