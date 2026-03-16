open Ecs

module Player_manager_system = System.Make(Player_manager)

module Collision_system = System.Make(Collision)

module Room_loader_system = System.Make(Room_loader)

module Move_system = System.Make(Move)

module Timer_system = System.Make(Timer)

module Clear_system = System.Make(Clear)

module Draw_system = System.Make(Draw)

module Lifebar_draw_system = System.Make(Lifebar_draw)

module Interact_system = System.Make(Interact)