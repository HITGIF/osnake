open! Base
open! Core_thread

exception Game_over

type t = { controller : Controller.t ref; view : View.t ref }

let create controller view = { controller = ref controller; view = ref view }

let handle _ message =
  Stdio.printf "Message: %s\n%!"
    (match message with
    | Controller.Left -> "L"
    | Right -> Caml.raise_notrace Game_over)

let tick t =
  let messages = Controller.poll !(t.controller) in
  List.iter messages ~f:(handle t);
  View.render !(t.view)

let start t =
  try
    while true do
      tick t;
      Thread.delay 1.;
      ()
    done
  with Game_over -> ()
