open Osnake

let () =
  let view = View.create () in
  let controller = Controller.create () in
  let game = Game.create controller view Player.AI in
  Game.start game ~speed:15.
