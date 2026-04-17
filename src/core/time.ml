open Ecs
open Component_defs
open System_defs

let create_timer_no_room_clear time_left f = 
  let t  = new timer () in
  t#time_left#set time_left;
  t#time_out_fun#set f;
  Timer_system.(register (t :> t));
  Clear_system.(register (t :> t))

let create_timer time_left f =
  let t  = new timer () in
  t#time_left#set time_left;
  t#time_out_fun#set f;
  Room_loader.add_current_room (t :> deletable);
  Timer_system.(register (t :> t));
  Clear_system.(register (t :> t))