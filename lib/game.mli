type t

val create : Controller.t -> View.t -> Player.t -> t
val start : t -> speed:float -> unit
