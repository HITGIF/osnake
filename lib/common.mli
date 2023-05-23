type direction = Left | Right | Up | Down

module Body : sig
  type t = { head : int * int; tail : (int * int) Core.Deque.t }

  val create : int * int -> t
  val move : t -> direction -> extend:bool -> t
end

type state = {
  snake : Body.t;
  direction : direction;
  food : int * int;
      (* score : int;
         width : int;
         height : int; *)
}
