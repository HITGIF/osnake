type t
type message = Left | Right

val create : unit -> t
val poll : t -> message list
