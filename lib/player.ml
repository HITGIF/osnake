type t = Human | AI of Ai.t

let is_AI = function AI _ -> true | _ -> false
let is_human = function Human -> true | _ -> false
