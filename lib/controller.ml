type t = unit
type message = Left | Right | Up | Down | Quit

let char_code_to_message c =
  match c with
  | 97 -> Some Left (* a *)
  | 100 -> Some Right (* d *)
  | 119 -> Some Up (* w *)
  | 115 -> Some Down (* s *)
  | 27 -> Some Quit (* esc *)
  | _ -> None

let create () = ()

let rec get_key_message () =
  if Graphics.key_pressed () then
    let code = Graphics.read_key () |> Char.code in
    match char_code_to_message code with
    | Some _ as message -> message
    | None -> get_key_message ()
  else None

let poll _ = match get_key_message () with Some m -> [ m ] | None -> []
