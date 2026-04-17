open Ecs
open Component_defs

type t = player

let init _ = Gfx.debug "Player_manager system initialised\n%!"

let handle_movement dt e =
  let direction_x =
    let left = if Input.is_pressed "q" then -1. else 0. in
    let right = if Input.is_pressed "d" then 1. else 0. in
    left +. right
  in
  let () = (if Input.is_pressed "q" then begin
              e#texture#set !(Texture.player_txt_reverted);
              Global.is_facing_left := true
            end
            else if Input.is_pressed "d" then begin
              e#texture#set !(Texture.player_txt);
              Global.is_facing_left := false
            end) in
  let target_speed_x = direction_x *. Cst.player_speed in
  let Vector.{x ; y} = e#velocity#get in
  let speed_x = dt *. (target_speed_x -. x) +. x in
  let speed_y =
    (if Input.is_pressed "s" then
      Cst.player_fast_falling_speed
    else
      0.)
    +. 
    (match (e#tag#get) with 
    | Player_tag {is_on_floor = true} -> 
      if Input.is_pressed "space" || Input.is_pressed " " then
        -. Cst.player_jump_speed
      else
        y
    | _ -> y)
  in
  e#velocity#set Vector.{x = speed_x ; y = speed_y};
  ()

let handle_fire dt (e:t) =
  if Input.is_pressed "Mouse1" then
    match e#curent_gun#get with
    | None -> Gfx.debug "hit with fist\n%!"
    | Some(gun) ->
      gun#shoot#get ();
  ;
  ()

let handle_interactions dt (e:t) =
  Global.is_interacting := Input.is_just_pressed "e"

let update dt el =
  Seq.iter (fun (e:t) ->
    handle_movement dt e;
    handle_fire dt e;
    handle_interactions dt e;
  ) el
