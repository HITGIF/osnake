type t
type message = Left | Right | Up | Down | Quit

val create : unit -> t
val poll : t -> message list
