type t = Human | AI of Ai.t

val is_AI : t -> bool
val is_human : t -> bool
