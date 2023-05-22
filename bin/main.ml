open Osnake

let () =
  let controller = Controller.create () in
  let view = View.create () in
  let game = Game.create controller view in
  Game.start game
