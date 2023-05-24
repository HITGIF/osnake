open! Base

type t = unit

let base = (10, 10)
let body_width = 10

let draw_rect (x0, y0) w h =
  let a, b = Graphics.current_point () and x1 = x0 + w and y1 = y0 + h in
  Graphics.moveto x0 y0;
  Graphics.lineto x0 y1;
  Graphics.lineto x1 y1;
  Graphics.lineto x1 y0;
  Graphics.lineto x0 y0;
  Graphics.moveto a b

let fill_rect (x0, y0) w h =
  let x1 = x0 + w and y1 = y0 + h in
  Graphics.fill_poly [| (x0, y0); (x0, y1); (x1, y1); (x1, y0) |]

let draw_text (x, y) s =
  Graphics.moveto x y;
  Graphics.set_font "-*-fixed-medium-r-semicondensed--20-*-*-*-*-*-iso8859-1";
  Graphics.draw_string s

let draw_snake_body (r, c) =
  let x0 = fst base + (r * body_width) and y0 = snd base + (c * body_width) in
  fill_rect (x0, y0) body_width body_width

let create () =
  Graphics.open_graph " 600x420";

  (* background *)
  Graphics.set_color Graphics.black;
  fill_rect (0, 0) 600 420;

  (* board outline *)
  Graphics.set_color Graphics.white;
  draw_rect base 400 400

let render _ state player =
  (* clear board *)
  Graphics.set_color Graphics.black;
  fill_rect base 400 400;
  fill_rect (420, 0) 180 420;
  Graphics.set_color Graphics.white;
  draw_rect base 400 400;

  let open State in
  let open Printf in
  sprintf "Score: %d" state.score |> draw_text (420, 390);

  (match player with
  | Player.Human -> "[W A S D] move"
  | AI { name; _ } -> sprintf "AI: %s" name)
  |> draw_text (420, 360);

  "[esc] quit" |> draw_text (420, 330);

  (* snake *)
  let Snake.{ head; tail } = state.snake in
  Core.Deque.iter tail ~f:draw_snake_body;
  Graphics.set_color Graphics.red;
  draw_snake_body head;

  (* food *)
  Graphics.set_color Graphics.green;
  draw_snake_body state.food

let render_game_over _ =
  Graphics.set_color Graphics.black;
  (* Cover up the key bindings *)
  fill_rect (420, 10) 180 380;

  Graphics.set_color Graphics.red;
  draw_text (420, 345) "Game Over";

  Graphics.set_color Graphics.white;
  draw_text (420, 300) "[r]estart";
  draw_text (420, 270) "[esc] quit"
