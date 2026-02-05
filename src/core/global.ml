open Component_defs

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player1 : player;
  main_camera : camera;
}

let mouse_x = ref 0
let mouse_y = ref 0

let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s
