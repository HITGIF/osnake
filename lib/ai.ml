type t = { name : string; strategy : State.t -> State.Direction.t }

let dumb = { name = "Dumb"; strategy = (fun _ -> `Up) }
