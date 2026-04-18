open Ecs
open Component_defs
open System_defs

let create_button x y width height texture text text_color resolver =
  let b = new button () in
  b#position#set Vector.{x; y};
  b#box#set Rect.{width ; height};
  b#texture#set texture;
  b#text#set text;
  b#text_color#set text_color;
  b#interact_resolver#set resolver;
  b

let retry_game ()  =
  Gfx.debug "retry\n%!";
  let g = Global.get () in
  (match g.state with
  | Player_died bl -> List.iter (fun b -> b#tokill#set true) bl
  | _ -> failwith "clicked on retry button when not in Player_died state");
  let player1 = Player.create_player () in
  Room_loader.unload_room (Option.get g.dungeon#current_room#get);
  let dungeon = Dungeon.create_dungeon 5 in
  let state = Global.Playing in
  Global.set {g with player1 ; dungeon ; state }

let create_death_menu_buttons () =
  let Global.{ctx ; _} = Global.get () in
  let ww, wh = Gfx.get_context_logical_size ctx in
  let y, w, h = (float (7 * wh / 10)), (ww / 5), (wh / 10) in
  let b_quit = create_button 
    (float (ww / 5))
    y
    w
    h
    (!Texture.button_txt)
    "QUIT"
    (Gfx.color 0 0 0 255)
    (fun () -> Gfx.debug "Quit"; Global.set {(Global.get ())  with state = Quit_game})
  in
  Draw_death_menu_system.register b_quit;
  Click_system.register (b_quit :> interactable);

  let b_retry = create_button 
    (float (3 * ww / 5))
    y
    w
    h
    (!Texture.button_txt)
    "RETRY"
    (Gfx.color 0 0 0 255)
    retry_game
  in
  Draw_death_menu_system.register b_retry;
  Click_system.register (b_retry :> interactable);
  
  [b_quit; b_retry]