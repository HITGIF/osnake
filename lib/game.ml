open! Base
open! Core_thread
open! Common

exception Game_over

type t = {
  controller : Controller.t ref;
  view : View.t ref;
  mutable state : state;
}

let tuple_equal (x, y) (x', y') = x = x' && y = y'

let is_not_occupied state coord =
  (not (Core.Deque.exists state.snake.tail ~f:(tuple_equal coord)))
  && (not (tuple_equal coord state.snake.head))
  && not (tuple_equal coord state.food)
(* TODO: can be last tail *)

let rec gen_food ~valid =
  match (Random.int 40, Random.int 40) with
  | x, y when valid (x, y) -> (x, y)
  | _ -> gen_food ~valid

let create controller view =
  {
    controller = ref controller;
    view = ref view;
    state =
      {
        snake = Body.create (0, 0);
        direction = Right;
        food =
          gen_food ~valid:(fun (x, y) -> x <> 0 || y <> 0)
          (* score = 0;
             width = 10;
             height = 10; *);
      };
  }

let handle t message =
  let () =
    match message with
    | Controller.Quit -> Caml.raise_notrace Game_over
    | _ -> ()
  in
  let direction =
    match message with
    | Controller.Left -> Left
    | Right -> Right
    | Up -> Up
    | Down -> Down
    | _ -> t.state.direction
  in
  t.state <- { t.state with direction }

let tick t =
  let messages = Controller.poll !(t.controller) in
  List.iter messages ~f:(handle t);
  let ate = tuple_equal t.state.snake.head t.state.food in
  t.state <-
    {
      t.state with
      snake = Body.move t.state.snake t.state.direction ~extend:ate;
    };
  if ate then
    t.state <- { t.state with food = gen_food ~valid:(is_not_occupied t.state) };
  View.render !(t.view) t.state

let start t =
  try
    while true do
      tick t;
      Thread.delay 0.05
    done
  with Game_over -> ()
