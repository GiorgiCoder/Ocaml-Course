type 'a lambda = Var of 'a | Fun of 'a * 'a lambda | App of 'a lambda * 'a lambda


let rec rename x y t =
    let rec rename t' = match t' with
      | Var v -> Var (if v = x then y else v)
      | Fun (v, body) -> Fun (v, rename body)
      | App (t1, t2) -> App (rename t1, rename t2) in
    rename t

(* example of how rename works:
   Let's take (λx.λy.x). When we call rename x y (λx.λy.x), t' matches with Fun(v, body), where v is x and body is λy.x,
   then we call rename on body λy.x, it again is a function and v is y, body is x, next call of rename body matches with Var v, which
   is x, if x=x (true) then y, we return Var y from the last call, then Fun ("y", Var y) from the inner call and
   Fun ("x", Fun ("y", Var y)) at last call. So we renamed x to y *)

  let rec variables_list t =
    let rec helper acc t' = match t' with
      | Var v -> v :: acc
      | Fun (v, body) -> helper (List.filter (fun x -> x <> v) acc) body
      | App (t1, t2) -> helper (helper acc t1) t2
    in
    List.rev (helper [] t)

(* example of how variables_list works:
   Let's take (λx.λy.x) again. It first matches with Fun(v, body), where v is x and body is λy.x, x then is added to the accumulator,
   then function is called with λy.x and same is done with y. After next call x is already in acc so it won't be added second time and
   we have acc = [y; x]
*)
  

let rec substitute x y lambda = match lambda with
  | Var v -> if v = x then y else Var v (* If variable is equal to our variable, no replacement happens *)
  | Fun (v, body) -> if v = x then Fun (v, body)
                     else if v != x && not (List.mem v (variables_list y)) then Fun (v, substitute x y body) 
                        (* If variable is not equal to our variable but also is not in the variables_list of y, then we leave
                           function variable as it is and continue to search in the body *)
                     else let v' = v ^ "'" in
                     let body' = rename v v' body in
                     Fun (v', substitute x y body')
                        (* If variable is not equal to out variable and is in the list, we need to avoid variable capture,
                           so we change every occurence of this variable to v ^ "'"*)
  | App (l1, l2) -> App (substitute x y l1, substitute x y l2)
                        (* In case of application, we simply call function on both lambda terms *)


(* Lazy evaluation (outermost strategy) *)
let rec beta_reduce t = match t with
  | App (Fun (x, body), arg) -> substitute x arg body  (* This is the form that we want to achieve,
     function of x and r as the argument, we call the substitute function which substitutes it with x if needed *)
  | App (t1, t2) ->
    let t1' = beta_reduce t1 in
    let t2' = beta_reduce t2 in
    App (t1', t2') (* In this case we just continue reducing until we match with the first case *)
  | Fun (x, body) -> Fun (x, beta_reduce body) (* If we have no argument yet, we continue reducing body *)
  | Var v -> Var v

(* Example of how beta_reduce works on (λx.λy.x)yz. App (App (Fun ("x", Fun ("y", Var "x")), Var "y"), Var "z")
   It matches with the second case, we reduce the first part and the second part left is Var "z" which is left till the end.
   In reducing the first part, y is an argument, function variable x is the x, body is a function Fun ("y", Var "x"),
   substitute (x) Fun(y, Var x) (Var y) is called and because y = y and y is in the variables_list, we rename
   the inner y and get (λy'.y)z
   *)


(* (λx.xx)y should reduce to yy *)
let example1 = beta_reduce (App (Fun ("x", App (Var "x", Var "x")), Var "y"))
(* expected output: App (Var "y", Var "y") *)

(* (λx.λy.x)yz should reduce to (λy'.y)z *)
let example2 = beta_reduce (App (App (Fun ("x", Fun ("y", Var "x")), Var "y"), Var "z"))
(* expected output: App (Fun ("y'", Var "y"), Var "z") *)

(* (λx.(λy.xy)z)l should reduce to (λy.ly)z (with outermost strategy) *)
let example3 = beta_reduce (App (Fun ("x", App (Fun ("y", App (Var "x", Var "y")),Var "z")),Var "l"))
(* expected output: App (Fun ("y", App (Var "l", Var "y")), Var "z") *)

(* (λx.λy.x)z should reduce to (λy.z) *)
let example6 = beta_reduce (App (Fun ("x", Fun ("y", Var "x")), Var "z"))
(* Expected output: Fun ("y", Var "z") *)

(* (λx.(λy.x))((λz.zz)(λw.w)) should reduce to (λy.(λz.zz)(λw.w)) (it's not a final form but we are only asked to implement the beta reduce rule)*)
let example4 = beta_reduce (App (Fun ("x", Fun ("y", Var "x")),(App (Fun ("z", App (Var "z", Var "z")), Fun ("w", Var "w")))))
(* expected output: Fun ("y", App (Fun ("z", App (Var "z", Var "z")), Fun ("w", Var "w")))) *)