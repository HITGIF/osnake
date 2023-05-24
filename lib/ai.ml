type t = { name : string; strategy : State.t -> State.Direction.t }

let basic = { name = "Basic"; strategy = (fun _ -> `Up) }
