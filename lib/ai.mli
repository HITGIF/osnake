type t = {
  name: string;
  strategy: State.t -> State.Direction.t
}

val dumb : t
