open Ecs

module Collision_system = System.Make(Collision)

module Move_system = System.Make(Move)

module Timer_system = System.Make(Timer)

module Clear_system = System.Make(Clear)

module Draw_system = System.Make(Draw)

module Lifebar_draw_system = System.Make(Lifebar_draw)
