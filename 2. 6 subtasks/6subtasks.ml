(* Problem 1 *)
let f1 acc (a, b) = List.rev((b, a) :: (List.rev acc))

let f2 acc x = if (List.length acc) mod 2 = 0 then x :: acc else acc @ [x];;

let f3 f (k, v) =
  fun x -> if x = k then v else f x

let g = List.fold_left f3 (fun _ -> 0) [('a',3); ('z', -9); ('d', 18)]

(* Tester doesn't seem to work but I tested all inputs from it and outputs are the same*)


(* Problem 2 *)
let map_tr f lst = let rec aux acc lst = match lst with
| [] -> List.rev acc
| x :: xs -> aux (f x::acc) xs
in aux [] lst


let replicate_tr n x = let rec aux n acc = 
  if n < 1 then acc else aux (n-1) (x::acc)
in aux n []

        
(* Problem 3 *)

type 'a custom_llist = (unit -> 'a custom_cell) and 'a custom_cell = NilC | ConsC of ('a * 'a custom_llist)

type 'a ocaml_llist = 'a ocaml_cell Lazy.t and 'a ocaml_cell = NilO | ConsO of ('a * 'a ocaml_llist)

let rec map_over_custom_llist f l = match l() with
| NilC -> (fun () -> NilC)
| ConsC (x, xs) -> (fun () -> ConsC (f x, map_over_custom_llist f xs))

(* Same here but we need Lazy.force. Lazy function won't be evaluated when needed unless it's forced *)
let rec map_over_ocaml_llist f l = lazy (match Lazy.force l with
 | NilO -> NilO
 | ConsO (x, xs) -> ConsO (f x, map_over_ocaml_llist f xs))


 
(* Problem 4 *)

let rec merge_custom_llists l1 l2 = match l1(), l2() with
| NilC, _ -> l2
| _, NilC -> l1
| ConsC(x, xs), ConsC(y, ys) ->
  if x <= y then
    fun () -> ConsC(x, merge_custom_llists xs l2) (* We return a function that places x first and then lazily continues with the tail of l1 and whole l2*)
  else
    fun () -> ConsC(y, merge_custom_llists l1 ys) (* Else whole l1 and the tail of l2*)

(* Same here but matching is lazy (evaluates only when needed) *)
let rec merge_ocaml_llists l1 l2 = lazy (match Lazy.force l1, Lazy.force l2 with
| NilO, _ -> Lazy.force l2
| _, NilO -> Lazy.force l1
| ConsO(x, xs), ConsO(y, ys) -> if x <= y then ConsO(x, merge_ocaml_llists xs l2) 
                                else ConsO(y, merge_ocaml_llists l1 ys))


(* Problem 5 *)
  
let rec drop_dupl_custom_llist l = match l() with
| NilC -> (fun () -> NilC)
| ConsC (x, xs) -> let rest = drop_dupl_custom_llist xs in match rest() with
          | NilC -> (fun () -> ConsC (x, rest))
          | ConsC (y, ys) -> if x = y then rest (* If x is equal first element of rest then we only return rest and remove x *)
                             else (fun () -> ConsC (x, rest)) (* Else return a lazy function with x and rest *)
      
let rec drop_dupl_ocaml_llist l = lazy (match Lazy.force l with
| NilO -> NilO
| ConsO (x, xs) -> let rest = drop_dupl_ocaml_llist xs in match Lazy.force rest with
          | NilO -> ConsO (x, rest)
          | ConsO (y, ys) -> if x = y then Lazy.force rest
                             else ConsO (x, rest))


(* Problem 6 *)
  
let rec is_hamming n =
  if n <= 1 then n = 1
  else if n mod 2 = 0 then is_hamming (n / 2)
  else if n mod 3 = 0 then is_hamming (n / 3)
  else if n mod 5 = 0 then is_hamming (n / 5)
  else false

let hamming_custom = 
  let rec helper n =
    if is_hamming n then fun () -> ConsC(n, helper (n + 1))
    else helper (n + 1) in
  helper 1

let hamming_ocaml = 
      let rec helper n =
        if is_hamming n then lazy (ConsO(n, helper (n + 1)))
        else helper (n + 1) in
      helper 1