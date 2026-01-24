open Component_defs

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  player1 : block;
}

let state = ref None

let mouse_x = ref 0
let mouse_y = ref 0

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s
