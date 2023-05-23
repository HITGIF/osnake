type t
type message = [ `Left | `Right | `Up | `Down | `Quit | `Restart ]

val create : unit -> t
val poll : t -> message list
val wait_for : t -> (message -> bool) -> message
