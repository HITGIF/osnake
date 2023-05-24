type t

val create : Controller.t -> View.t -> State.player -> t
val start : t -> speed:float -> unit
