type t = { x : float; y : float }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }

let mult k a = { x = k*. a.x; y = k*. a.y }

let dot a b = a.x *. b.x +. a.y *. b.y
let norm a = sqrt (dot a a)
let zero = { x = 0.0; y = 0.0 }
let is_almost_zero v =
  v.x <= Float.epsilon && v.x >= -.(Float.epsilon) && v.y <= Float.epsilon && v.y >= -.(Float.epsilon)
let normalize a =
  if (a.x = 0. && a.y = 0.) || is_almost_zero a then
    zero
  else
    mult (1.0 /. norm a) a
let pp fmt a = Format.fprintf fmt "(%f, %f)" a.x a.y