type t = unit
type message = [ State.Direction.t | `Quit | `Restart ]

let char_code_to_message c =
  match c with
  | 97 -> Some `Left (* a *)
  | 100 -> Some `Right (* d *)
  | 119 -> Some `Up (* w *)
  | 115 -> Some `Down (* s *)
  | 27 -> Some `Quit (* esc *)
  | 114 -> Some `Restart (* r *)
  | _ -> None

let create () = ()

let rec get_key_message () =
  if Graphics.key_pressed () then
    Graphics.read_key () |> Char.code |> char_code_to_message |> function
    | Some _ as message -> message
    | None -> get_key_message ()
  else None

let rec poll t =
  match get_key_message () with Some m -> m :: poll t | None -> []

let rec wait_for t f =
  Graphics.read_key () |> Char.code |> char_code_to_message |> function
  | Some message when f message -> message
  | _ -> wait_for t f
