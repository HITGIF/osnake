type direction = Left | Right | Up | Down

module Body = struct
  type t = { head : int * int; tail : (int * int) Core.Deque.t }

  let create head = { head; tail = Core.Deque.create () }

  let move t direction ~extend =
    let x, y = t.head in
    let x, y =
      match direction with
      | Left -> (x - 1, y)
      | Right -> (x + 1, y)
      | Up -> (x, y + 1)
      | Down -> (x, y - 1)
    in
    Core.Deque.enqueue_front t.tail t.head;
    if not extend then Core.Deque.dequeue_back_exn t.tail |> ignore;
    { t with head = (x, y) }
end

type state = {
  snake : Body.t;
  direction : direction;
       food : int * int;
      (*   score : int;
         width : int;
         height : int; *)
}
