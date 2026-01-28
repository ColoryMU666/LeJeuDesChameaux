open Ecs
open Component_defs

type t = collidable

let init _ = Gfx.debug "Collision init\n%!"

let rec iter_pairs f s =
  match s () with
    Seq.Nil -> ()
  | Seq.Cons(e, s') ->
    Seq.iter (fun e' -> f e e') s';
    iter_pairs f s'


let update _ el =
  el
  |> iter_pairs (fun (e1:t) (e2:t) ->
  if e1#mass#get <> infinity || e2#mass#get <> infinity then
    let s = Rect.mdiff e1#position#get e1#box#get e2#position#get e2#box#get in
    if not (Rect.has_origin (fst s) (snd s)) then
      ()
    else
      let nvect = Rect.penetration_vector (fst s) (snd s) in
      let n1 = ref 0. in
      let n2 = ref 0. in
      (if e1#velocity#get = Vector.zero && e2#velocity#get = Vector.zero then 
        (n1 := Vector.norm (e1#velocity#get);
        n2 := Vector.norm (e2#velocity#get))
      else
        (n1 := Vector.norm (e1#velocity#get)  /. (Vector.norm (e1#velocity#get) +. Vector.norm (e2#velocity#get));
        n2 := Vector.norm (e2#velocity#get)  /. (Vector.norm (e1#velocity#get) +. Vector.norm (e2#velocity#get)))
        );
      e1#position#set (Vector.add e1#position#get (Vector.mult !n1 nvect));
      e2#position#set (Vector.add e2#position#get (Vector.mult (-1. *. !n2) nvect));
      let nnorm = Vector.normalize nvect in
      let relative_velocity = Vector.sub e1#velocity#get e2#velocity#get in
      let j1 = ( ((-1.) -. e1#elasticity#get )*. (Vector.dot relative_velocity nnorm)) /. (1. /. e1#mass#get +. 1. /. e2#mass#get) in
      let j2 = ( ((-1.) -. e2#elasticity#get )*. (Vector.dot relative_velocity nnorm)) /. (1. /. e1#mass#get +. 1. /. e2#mass#get) in
      e1#velocity#set (Vector.add e1#velocity#get (Vector.mult (j1 /. e1#mass#get) nnorm));
      e2#velocity#set (Vector.sub e2#velocity#get (Vector.mult (j2 /. e2#mass#get) nnorm))
)
