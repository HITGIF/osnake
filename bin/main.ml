open Osnake

let () =
  let view = View.create () in
  let controller = Controller.create () in
  let game = Game.create controller view in
  Game.start game
