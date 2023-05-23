type t

val create : Controller.t -> View.t -> t
val start : t -> speed:float -> unit
