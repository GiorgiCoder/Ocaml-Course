(* N1 test succeed *)
let rec member c t list = match list with
[] -> false
|x::xs -> if c t x = 0 then true else member c t xs

let equal_second_components (_, x) (_, y) = compare x y

let evens_eq_evens_odds_eq_odds n1 n2 = compare (n1 mod 2) (n2 mod 2)


(* N2 test succeed *)
let rec occ e list = match list with
[] -> 0
| x::xs -> if x = e then 1+(occ e xs) else occ e xs

let rec count_occurrences_unsorted list = match list with
  | [] -> []
  | h::tail -> let count = occ h list in
               let remove_dupl = List.filter (fun x -> x <> h) tail in
               (h, count) :: count_occurrences remove_dupl

let count_occurrences list1 = List.sort(fun (_, x1) (_, x2) -> compare x2 x1) (count_occurrences_unsorted list1)

(* N3 test succeed *)
let rec drop_last l = match l with
[] -> failwith "Exception: Failure \"Empty list has no last element\"."

|[_] -> []
|x::xs -> x::drop_last xs


(* N4 test succeed *)
let rec drop_last_opt list = match list with
  | [] -> None
  | [_] -> Some []
  | x::xs -> (match drop_last_opt xs with
              | None -> None
              | Some t -> Some (x::t))

(* N5 test succeed *)

let rec zip_with f l1 l2 = match l1, l2 with
|[], _ -> []
|_, [] -> []
|h1::tail1, h2::tail2 -> (f h1 h2)::(zip_with f tail1 tail2)


(* N6 test succeed *)

let rec unzip  list = List.fold_right(fun(x,y)(xs,ys)->(x::xs, y::ys)) list ([],[])

(* N7 *)
(* Show the evaluation steps of unzip [('a',1);('b',2)]:
   Our function unzip takes list's first pair ('a',1) as (x,y).
   ('a',1) then is combined with accumulators, which in the beginning are [][] so we get (['a'], [1])
   Then ('b', 2) is combined with accumulators which now are (['a'], [1]) and we get a pair of lists (['b';'a'],[2;1]) *)

(* N8 test succeed *)

type team = Arg | Sau | Mex | Pol | Por | Kor | Uru | Gha

let wc22_C = 
  [(Arg, ["Messi"], Sau, ["Al-Shehri"; "Al-Dawsari"]);
   (Mex, [], Pol, []);
   (Pol, ["Zielinski"; "Lewandowski"], Sau, []);
   (Arg, ["Messi"; "Fernandez"], Mex, []);
   (Pol, [], Arg, ["Mac Allister"; "Alvarez"]);
   (Sau, ["Al-Dawsari"], Mex, ["Martin"; "Chavez"])
  ]

let wc22_H = 
  [(Uru, [], Kor, []);
   (Por, ["Ronaldo"; "Felix"; "Leao"], Gha, ["Ayew"; "Bukari"]);
   (Kor, ["Cho Gue-sung"; "Cho Gue-sung"], Gha, ["Salisu"; "Kudus"; "Kudus"]);
   (Por, ["Fernandes"; "Fernandes"], Uru, []);
   (Kor, ["Kim Young-gwon"; "Hwang Hee-chan"], Por, ["Horta"]);
   (Gha, [], Uru, ["De Arrascaeta"; "De Arrascaeta"])
  ]

(*table*)

let table_helper ((t1 : team), (s1 : string list), (t2 : team), (s2 : string list)) =
    if List.length(s1) > List.length(s2) then
      (t1, 1, 1, 0, 0, List.length s1, List.length s2, 3)
    else if List.length(s1) < List.length(s2) then
      (t1, 1, 0, 0, 1, List.length s1, List.length s2, 0)
    else
      (t1, 1, 0, 1, 0, List.length s1, List.length s2, 1)
  
let rec table_unsorted list = match list with
    | [] -> []
    | ((t1 : team), s1, (t2 : team), s2) :: tail ->
        table_helper (t1, s1, t2, s2) :: table_helper (t2, s2, t1, s1) :: table_unsorted tail

let sum_by_team list =
   let rec sum acc list =
      match list with
      | [] -> List.rev acc
      | ((t : team), b, c, d, e, f, g, h) :: tail ->
          let (sum_b, sum_c, sum_d, sum_e, sum_f, sum_g, sum_h) =
            List.fold_left
              (fun (acc_b, acc_c, acc_d, acc_e, acc_f, acc_g, acc_h) (_, x, y, z, w, p, q, r) ->
                   (acc_b + x, acc_c + y, acc_d + z, acc_e + w, acc_f + p, acc_g + q, acc_h + r))
                   (b, c, d, e, f, g, h)
                   (List.filter (fun (x, _, _, _, _, _, _, _) -> x = t) tail)
              in
              sum ((t, sum_b, sum_c, sum_d, sum_e, sum_f, sum_g, sum_h) :: acc)
                (List.filter (fun (x, _, _, _, _, _, _, _) -> x <> t) tail)
              in
              sum [] list

let compare_elems (_,_,_,_,_,a5,a6,(a7:int)) (_,_,_,_,_,b5,b6,(b7:int)) = 
    if a7>b7 then -1
    else if b7>a7 then 1
    else if (a5-a6)>(b5-b6) then -1        
    else if (b5-b6)>(a5-a6) then 1  
    else if a5>b5 then -1
    else if b5>a5 then 1
    else 0 

let compared_list list = List.sort compare_elems list;;

let table list = compared_list (sum_by_team (table_unsorted list))
        
(*scorers*)

let rec scorers_helper (t1 : team) (s1 : string list) (t2 : team) (s2 : string list) = match s1 with
  | [] -> []
  | pl::tail -> (pl, t1, 1) :: scorers_helper t1 tail t2 s2
  

let rec scorers_unsorted list = match list with
  | [] -> []
  | (t1, s1, t2, s2) :: tail ->
      (scorers_helper t1 s1 t2 s2) @ (scorers_helper t2 s2 t1 s1) @ scorers_unsorted tail
  
let sum_goals list =
  let rec sum acc lst = match lst with
    | [] -> List.rev acc
    | (player, team, goals) :: tail ->
       let (total_goals, rest) = List.fold_left (fun (acc_goals, acc_rest) (p, t, g) ->
          if p = player && t = team then (acc_goals + g, acc_rest)
          else (acc_goals, (p, t, g)::acc_rest))
          (goals, []) tail in
          sum ((player, team, total_goals)::acc) rest in
          sum [] list

let compare_goalscorers (p1, _, g1) (p2, _, g2) =
    if g1 > g2 then -1
    else if g1 < g2 then 1
    else String.compare p1 p2

let sorted_goalscorers list = List.sort compare_goalscorers list

let scorers list = sorted_goalscorers (sum_goals (scorers_unsorted list))

let table_and_scorers list = table list, scorers list