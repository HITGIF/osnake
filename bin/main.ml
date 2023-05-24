open Osnake

let () =
  let view = View.create () in
  let controller = Controller.create () in
  let player = Player.AI Ai.dumb in
  let game = Game.create controller view player in
  Game.start game ~speed:15.
