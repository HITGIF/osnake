open! Base
open! Core_thread

exception Quit
exception Game_over

type t = {
  controller : Controller.t ref;
  view : View.t ref;
  messages : Controller.message Queue.t;
  mutable state : State.t;
}

let create controller view =
  {
    controller = ref controller;
    view = ref view;
    messages = Queue.create ();
    state = State.create ();
  }

let rec handle_messages t =
  let open State in
  match Queue.dequeue t.messages with
  | None -> ()
  | Some message -> (
      match message with
      | `Quit -> Caml.raise_notrace Quit
      | #Direction.t as direction ->
          if not Direction.(opposite t.state.direction |> equal direction) then
            t.state <- { t.state with direction }
          else handle_messages t
      | `Restart -> t.state <- State.create ())

let tick t =
  Controller.poll !(t.controller)
  |> List.filter ~f:(function `Quit | #State.Direction.t -> true | _ -> false)
  |> Queue.enqueue_all t.messages;
  handle_messages t;

  let new_state = State.transition t.state in
  if not (State.is_valid new_state) then Caml.raise_notrace Game_over;

  t.state <- new_state;
  View.render !(t.view) t.state

let rec start t speed =
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
          t.state <- State.create ();
          start t speed
      | _ -> assert false)
