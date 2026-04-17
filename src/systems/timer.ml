open Ecs
open Component_defs


type t = timer

let init _ = Gfx.debug "Timer system initialised\n%!"

let update dt el =
  el 
  |> Seq.iter (fun (e:t) -> 
    let new_time_left = e#time_left#get -. dt in
    if new_time_left <= 0. then begin
      e#time_out_fun#get (-. new_time_left);
      Room_loader.remove_current_room (e :> deletable);
      e#tokill#set true
    end else
      e#time_left#set new_time_left
  )