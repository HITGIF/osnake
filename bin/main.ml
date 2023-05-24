open Osnake

let () =
  let view = View.create () in
  let controller = Controller.create () in
  let game = Game.create controller view (Player.AI Ai.basic) in
  Game.start game ~speed:15.
