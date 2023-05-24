open! Base
open! Core_thread

exception Quit
exception Game_over

type t = {
  controller : Controller.t ref;
  view : View.t ref;
  mutable state : State.t;
}

let create controller view player =
  { controller = ref controller; view = ref view; state = State.create player }

let handle_controller_command t =
  let rec loop () =
    let open State in
    match Controller.poll !(t.controller) with
    | None -> ()
    | Some message -> (
        match message with
        | `Quit -> Caml.raise_notrace Quit
        | #Direction.t as direction
          when Player.is_human t.state.player
               && not Direction.(opposite t.state.direction |> equal direction)
          ->
            t.state <- { t.state with direction }
        | _ -> loop ())
  in
  loop ()

let choose_direction _ = `Up

let tick t =
  handle_controller_command t;

  if Player.is_AI t.state.player then
    t.state <- { t.state with direction = choose_direction t.state }
  else ();

  let new_state = State.transition t.state in
  if not (State.is_valid new_state) then Caml.raise_notrace Game_over;

  t.state <- new_state;
  View.render !(t.view) t.state

let start t ~speed =
  let rec loop () =
    try
      while true do
        tick t;
        Thread.delay (1. /. speed)
      done
    with
    | Quit -> ()
    | Game_over -> (
        View.render_game_over !(t.view);
        Controller.wait_for !(t.controller) (function
          | `Quit | `Restart -> true
          | _ -> false)
        |> function
        | `Quit -> ()
        | `Restart ->
            t.state <- State.create t.state.player;
            loop ()
        | _ -> assert false)
  in
  loop ()
