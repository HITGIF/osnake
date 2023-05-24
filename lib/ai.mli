type t = {
  name: string;
  strategy: State.t -> State.Direction.t
}

val basic : t
