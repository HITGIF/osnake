module Direction : sig
  type t = [ `Left | `Right | `Up | `Down ] [@@deriving equal]

  val opposite : t -> t
end

module Snake : sig
  type t = { head : int * int; tail : (int * int) Core.Deque.t }

  val create : int * int -> t
  val move : t -> Direction.t -> extend:bool -> t
end

type t = {
  snake : Snake.t;
  direction : Direction.t;
  food : int * int;
  score : int;
  width : int;
  height : int;
  player : Player.t;
}

val create : Player.t -> t
val transition : t -> t
val is_valid : t -> bool
