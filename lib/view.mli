type t

val create : unit -> t
val render : t -> State.t -> Player.t -> unit
val render_game_over : t -> unit
