type t

val create : unit -> t
val render : t -> State.t -> unit
val render_game_over : t -> unit
