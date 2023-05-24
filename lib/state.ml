open Base

module Direction = struct
  type t = [ `Left | `Right | `Up | `Down ] [@@deriving equal]

  let opposite = function
    | `Left -> `Right
    | `Right -> `Left
    | `Up -> `Down
    | `Down -> `Up
end

module Snake = struct
  type t = { head : int * int; tail : (int * int) Core.Deque.t }

  let create head = { head; tail = Core.Deque.create () }

  let move t direction ~extend =
    let x, y = t.head in
    let x, y =
      match direction with
      | `Left -> (x - 1, y)
      | `Right -> (x + 1, y)
      | `Up -> (x, y + 1)
      | `Down -> (x, y - 1)
    in
    Core.Deque.enqueue_front t.tail t.head;
    if not extend then Core.Deque.dequeue_back_exn t.tail |> ignore;
    { t with head = (x, y) }
end

type t = {
  snake : Snake.t;
  direction : Direction.t;
  food : int * int;
  score : int;
  width : int;
  height : int;
}

let equal2 (x, y) (x', y') = x = x' && y = y'

let rec gen_food width height ~valid =
  match (Random.int width, Random.int height) with
  | x, y when valid (x, y) -> (x, y)
  | _ -> gen_food width height ~valid

let create () =
  {
    snake = Snake.create (0, 0);
    direction = `Right;
    food = gen_food 40 40 ~valid:(Fn.compose not (equal2 (0, 0)));
    score = 0;
    width = 40;
    height = 40;
  }

let transition t =
  let ate = equal2 t.snake.head t.food in
  let snake = Snake.move t.snake t.direction ~extend:ate in
  let score = t.score + if ate then 1 else 0 in
  let food =
    let is_not_in_snake coord =
      let open Snake in
      (not (Core.Deque.exists snake.tail ~f:(equal2 coord)))
      && not (equal2 coord snake.head)
    in
    if ate then gen_food t.width t.height ~valid:is_not_in_snake else t.food
  in
  { t with snake; food; score }

let is_valid t =
  let open Snake in
  let x, y = t.snake.head in
  let is_in_bounds = x >= 0 && x < t.width && y >= 0 && y < t.height in
  let is_in_tail = Core.Deque.exists t.snake.tail ~f:(equal2 (x, y)) in
  is_in_bounds && not is_in_tail
