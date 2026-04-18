open System_defs
open Component_defs
open Ecs

let last_dt = ref 0.

let init dt =
  Ecs.System.init_all dt;
  (*let () = Block.create_background () in*)
  last_dt := dt;
  Some ()

let update dt =
  let g = Global.get () in
  match g.state with
  | Playing -> begin
    let real_delta = (dt -. !last_dt) in
    Timer_system.update real_delta;
    let delta = real_delta /. 25. in
    last_dt := dt;
    let () = Camera.stop_camera () in
    let () = Input.handle_input () in
    let () = Camera.move () in
    Player_manager_system.update delta;
    Enemy_manager_system.update delta;
    Interact_system.update delta;
    Move_system.update delta;
    Collision_system.update delta;
    Room_loader_system.update delta;
    Clear_system.update delta;
    Draw_background_system.update delta;
    Draw_system.update delta;
    Draw_lifebar_system.update delta;
    Draw_map_system.update delta;
    Gfx.commit g.ctx;
    None
  end
  | Player_died bl ->
    (match bl with
    | [] ->
      Gfx.debug "loading death menu buttons...%!";
      let buttons = Button.create_death_menu_buttons () in
      Global.set {g with state = Player_died buttons };
      Gfx.debug " ok\n%!";
    | _ -> ());
    let real_delta = (dt -. !last_dt) in
    Timer_system.update real_delta;
    let delta = real_delta /. 25. in
    last_dt := dt;
    let () = Camera.stop_camera () in
    let () = Input.handle_input () in
    let () = Camera.move () in
    Click_system.update delta;
    Enemy_manager_system.update delta;
    Move_system.update delta;
    Collision_system.update delta;
    Room_loader_system.update delta;
    Clear_system.update delta;
    Draw_background_system.update delta;
    Draw_system.update delta;
    Draw_lifebar_system.update delta;
    Draw_map_system.update delta;
    Draw_death_menu_system.update delta;
    Gfx.commit g.ctx;

    None
  | Player_won bl ->
    (match bl with
    | [] ->
      Gfx.debug "loading victory menu buttons...%!";
      let buttons = Button.create_victory_menu_buttons () in
      Global.set {g with state = Player_won buttons };
      Gfx.debug " ok\n%!";
    | _ -> ());
    let real_delta = (dt -. !last_dt) in
    let delta = real_delta /. 25. in
    last_dt := dt;
    let () = Input.handle_input () in
    Click_system.update delta;
    Draw_victory_menu_system.update delta;
    Gfx.commit g.ctx;
    None
  | Pause ->
    None
  | Quit_game ->
    Some ()

let (let@) f k = f k


let run () =
  Random.self_init ();
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:r=presentvsync"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx Cst.window_width Cst.window_height in
  (*let () = Texture.load_txt ctx in*)
  let () = Texture.load_ressources_correctly ctx in
  let _walls = Block.walls () in
  let main_camera = Camera.create () in
  let player1 = Player.create_player () in
  let dungeon = Dungeon.create_dungeon Cst.dungeon_size in
  let state = Global.Playing in
  let global = Global.{
    window;
    ctx;
    player1;
    main_camera;
    dungeon;
    state;
  } in
  Global.set global;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in ()
