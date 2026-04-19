# Neon PFA

## Description

Neon PFA is a roguelike game made for a university project where you have to traverse a futuristic city while having to deal with several enemies along the way. The state of the game right now is a demo in which you can go through the first level.

## Badges

![Static Badge](https://img.shields.io/badge/build-passing-light_green) <br>
![Static Badge](https://img.shields.io/badge/game%20%3D-amazing-light_green)

## Important notice for our teachers

If you are one of the teachers who will be marking this project, please find our repport at the root of our project in the file named **Rapport_projet_pfa_Matthieu_Urios_Hector_Bonhoure.pdf**

## Installation

### Requirements

#### Global requirements :

To use our game you will need `ocaml` installed on your computer as well as `dune`.<br>
You can get more informations about the `ocaml` insatllation here : [Installing OCaml](https://ocaml.org/docs/installing-ocaml)<br>
To get `dune` you need to complet the `opam` and `ocaml` installations first then open a new terminal and run the following commands <br>
- ```opam install dune``` to install the last stable version of dune via opam
- ```eval $(opam env)```  to update the environment variables of the current shell
- ```dune --version``` to check if the installation was succesful. `dune` sould be accessible from anywhere on your computer.

#### Web browser version requirements :

You will need the `js_of_ocaml` and `js_of_ocaml-ppx` libraries which you can install by running the following commands in your terminal :
- ```opam install js_of_ocaml```
- ```opam install js_of_ocaml-ppx```
- ```eval $(opam env)```  to update the environment variables of the current shell

Additionnaly you will need to open a local port on you computer. The easiest way to do that is using python. <br>
You can get python here : [Getting started with python](https://www.python.org/about/gettingstarted/)

#### Native build version requirements (tested only on Linux/Ubuntu):

You will need the `tsdl`, `tsdl-image` and `tsdl-ttf` libraries which you can install by running the following commands in your terminal :
- ```opam install tsdl```
- ```opam install tsdl-image```
- ```opam install tsdl-ttf```
- ```eval $(opam env)```  to update the environment variables of the current shell

### Game building

Now that you got all the dependencies necessary to run our game you will be able to proceed to the installion of the game. <br>
First you will need to clone our reposotory available here : [Neon PFA](https://github.com/ColoryMU666/LeJeuDesChameaux) <br>
Once you diid that, open a terminal and go to the root of our project and run the following commands depending of the version you want to build. <br>
`dune build @js`for the **web brower version** or `dune build @sdl`for the **native build version**. <br>
To delete all generated files, run `dune clean`.

### Game running

You almost made it, one last stretch and the fun is yours ! <br>
Once again you'll need to do follow different steps based on the version you will be running.

#### Web version : 
Go to the root of our project and run : ```python3 -m http.server```. A line saying a local port was opened should be appearing in your terminal. `Ctrl + left click` on the link in between parenthesis. At this point your internet browser should open a new tab called **Neon PFA**. If nothing appear on the screen, press `Ctrl + Shift + R` to reaload the tab while clearing the cache. Now the game should be running on your internet browser

#### Native build version :
Go to the root of our project and run ```./prog/game_sdl.exe```. A new window with the game should open.

## How to play

Now that the game is running I'll give you a quick run down on the commands.
- `W`,`A`,`S`,`D` keys to move your character.
- `E` key to interact with doors or pickup items and guns
- `Left_click` to shoot

Now try to cross the city and make to the boss ;)

## References and Acknoledgment

### Game textures

Huge thanks to :
- Coloritmic for the free version of their Neon City Pixel Art Asset pack which we used to make the walls, plateforms, doors, floors and ceilings of this game as well as the background. You can find their work here : [Neon City Assets by Coloritmic](https://coloritmic.itch.io/neoncityasset)
- Arcade island for their GUNS asset pack which we used for our glock and rocket launcher as well as their ammo/rocket. You can find their work here : [GUNS V1.01 by Arcade island](https://arcadeisland.itch.io/guns-asset-pack-v1)
- MisterDII for their Smooth Shotgun Animations pack which we used to make our shotgun sprite. You can fin their work here : [Smooth Shotgun Animations by MisterDII](https://misterdll.itch.io/shotgun)
- dinhaz for their Laser Gun asset which we used to mak our laser gun.  You can fin their work here : [Laser Gun #1 by dinhaz](https://dinhaz.itch.io/laser-gun-1)
- RustyBulletGames for their Colored Explosions Asset Pack which we used to make our rocket launcher rocket's explosion. You can find their work here : [Colored Explosion Asset Pack by RustyBulletGames](https://rustybulletgames.itch.io/colored-explosions-asset-pack)
- GGBotNet for their NEON SANS Font which we use to write text in the native build version. You can find their work here : [NEON SANS Font by GGBotNet](https://ggbot.itch.io/neon-sans-font)

The rest of the textures where made by ourselves.

### ECS
The game was made using the Entity component system (ECS) software architectual patern. If you are curious about it you can check the following links.

https://en.wikipedia.org/wiki/Entity_component_system
https://austinmorlan.com/posts/entity_component_system/
https://tsprojectsblog.wordpress.com/portfolio/entity-component-system/
https://savas.ca/nomad
https://github.com/skypjack/entt
https://ajmmertens.medium.com/building-an-ecs-2-archetypes-and-vectorization-fe21690805f9
https://github.com/SanderMertens/flecs

### Physique/Collision
The implementation of physics in out game was made based on the informations found on thos websites

https://medium.com/@brazmogu/physics-for-game-dev-a-platformer-physics-cheatsheet-f34b09064558
https://www.gamedeveloper.com/design/platformer-controls-how-to-avoid-limpness-and-rigidity-feelings
https://blog.hamaluik.ca/posts/simple-aabb-collision-using-minkowski-difference/
https://www.toptal.com/game/video-game-physics-part-i-an-introduction-to-rigid-body-dynamics
https://www.toptal.com/game/video-game-physics-part-ii-collision-detection-for-solid-objects
https://www.toptal.com/game/video-game-physics-part-iii-constrained-rigid-body-simulation
https://gdcvault.com/play/1021921/Designing-with-Physics-Bend-the