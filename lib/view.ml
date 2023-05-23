open! Base
open! Common

type t = unit

let create () = 
  Graphics.open_graph " 600x420"

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

(* let draw_text (x, y) s =
  Graphics.moveto x y;
  Graphics.draw_string s *)

let draw_snake_body (r, c) =
  let x0 = fst base + r * body_width and y0 = snd base + c * body_width in
  fill_rect (x0, y0) body_width body_width

let render _ state =
  Graphics.clear_graph ();
  Graphics.set_color Graphics.black;
  fill_rect (0, 0) 600 420;
  Graphics.set_color Graphics.white;
  draw_rect base 400 400;
  let head = state.snake.head in
  let tail = state.snake.tail in
  Core.Deque.iter tail ~f:draw_snake_body;
  Graphics.set_color Graphics.red;
  draw_snake_body head;
  Graphics.set_color Graphics.green;
  draw_snake_body state.food;

