module type Ring = sig
  type t
  val zero : t
  val one : t
  val compare : t -> t -> int
  val to_string : t -> string
  val add : t -> t -> t
  val mul : t -> t -> t
end

module type Matrix = sig
  type elem
  type t
  val create : int -> int -> t
  val identity : int -> t
  val from_rows : elem list list -> t
  val to_string : t -> string
  val set : int -> int -> elem -> t -> t
  val get : int -> int -> t -> elem
  val transpose : t -> t
  val add : t -> t -> t
  val mul : t -> t -> t
end



exception Invalid_operation

module IntRing : Ring with type t = int = struct
  type t = int
  let zero = 0
  let one = 1
  let compare = Pervasives.compare
  let to_string = string_of_int
  let add = (+)  let mul = ( * )
end 

module FloatRing : Ring with type t = float = struct
  type t = float
  let zero = 0.
  let one = 1.
  let compare = Pervasives.compare   
  let to_string = string_of_float
  let add = (+.)
  let mul = ( *. )
end

 
module type FiniteRing = sig
  include Ring
  val elems : t list
end

module BoolRing : FiniteRing with type t = bool = struct
  type t = bool
  let zero = false
  let one = true
  let compare = Pervasives.compare
  let to_string = string_of_bool
  let add = (||)
  let mul = (&&)
  let elems = [false;true]
end

module SetRing (D : FiniteRing) : Ring with type t = D.t list = 
struct
  type t = D.t list
  let zero = []
  let one = D.elems
  let compare a b =
    let a = List.sort D.compare a in
    let b = List.sort D.compare b in
    let rec impl l1 l2 = match l1, l2 with
      | [],_ | _,[] -> (List.length l1) - (List.length l2)
      | x::xs, y::ys -> let c = D.compare x y in
        if c <> 0 then c else impl xs ys
    in
    impl a b
  let to_string l = "{" ^ (String.concat ", " (List.map D.to_string l)) ^ "}"
  let add a b = List.sort_uniq D.compare (a @ b)
  let mul a b = List.filter (fun x -> List.find_opt (fun y -> D.compare x y = 0) b <> None) a
end

(* assume all matrices non-empty and rectangular *)
module DenseMatrix (T : Ring) : Matrix with type elem = T.t = struct
  type elem = T.t
  type t = T.t list list

  let create rows cols =
   List.init rows (fun _ -> List.init cols (fun _ -> T.zero))  
  
  let identity size = 
    List.init size (fun r -> List.init size (fun c -> if r = c then T.one 
    else T.zero))



  let from_rows l = l
  let to_string m =
    List.map (fun row -> List.map T.to_string row |> String.concat " ") m |> String.concat "\n"
  let set row col value m = List.mapi (fun r x -> if r <> row then x else List.mapi (fun c x -> if c <> col then x else value) x) m
  let get row col m =
    if row < 0 || row >= List.length m || col < 0 || col >= (List.length (List.hd m)) then raise Invalid_operation;
    List.nth (List.nth m row) col



  let transpose m =
    let ncols = List.length (List.hd m) in
    let new_rows = List.init ncols (fun _ -> []) in
    List.fold_left (fun acc row -> List.fold_left
      (fun acc c -> match acc with [] -> failwith "unreachable" | x::xs -> xs @ [c::x])
      acc row) new_rows m |> List.map List.rev

  let add a b = List.map2 (fun row1 row2 -> List.map2 T.add row1 row2) a b
  
  let mul a b =
    let arows = List.length a in
    let brows = List.length b in
    let acols = List.length (List.hd a) in
    let bcols = List.length (List.hd b) in
    if acols <> brows then raise Invalid_operation;
    let b = transpose b in
    let compute row col =
      List.fold_left2 (fun acc r c -> T.add acc (T.mul r c)) 
       T.zero (List.nth a row) (List.nth b col)
    in
    List.init arows (fun r -> List.init bcols (fun c -> compute r c))
end


module SparseMatrix (T : Ring) : Matrix with type elem = T.t = struct
  type elem = T.t
  type t = { cells : (int * int * T.t) list; nrows : int; ncols : int }
  let create rows cols = { cells=[]; nrows=rows; ncols=cols }
  let identity size = { cells=List.init size (fun s -> s,s,T.one); nrows=size; ncols=size }
  let from_rows l = { nrows=List.length l; ncols=List.length (List.hd l); cells=
    List.mapi (fun r row -> List.mapi (fun c col -> r,c,col) row) l
    |> List.flatten |> List.filter (fun (_,_,x) -> (T.compare x T.zero) <> 0) }

  let add m1 m2 =
    if m1.nrows <> m2.nrows || m1.ncols <> m2.ncols then raise Invalid_operation;
    let rec impl m1 m2 = match m1, m2 with
      | [],m | m,[] -> m
      | (r1,c1,v1)::t1,(r2,c2,v2)::t2 ->
        if r1 < r2 || (r1 = r2 && c1 < c2) then (r1,c1,v1)::impl t1 m2
        else if r1 = r2 && c1 = c2 then (r1,c1,T.add v1 v2)::impl t1 t2
        else (r2,c2,v2)::impl m1 t2
    in
    { cells=impl m1.cells m2.cells; nrows=m1.nrows; ncols=m1.ncols }

  let set row col value m =
    let rec impl = function [] -> [row,col,value]
    | (r,c,v)::cs -> if r < row then (r,c,v)::impl cs
      else if r > row then (row,col,value)::(r,c,v)::cs
      else if c < col then (r,c,v)::impl cs
      else if c > col then (row,col,value)::(r,c,v)::cs
      else (row,col,value)::cs
    in
    { m with cells=impl m.cells }

  let get row col m =
    if row < 0 || row >= m.nrows || col < 0 || col >= m.ncols then raise Invalid_operation;
    let rec impl = function [] -> T.zero
      | (r,c,v)::cs -> if r < row || (r = row && c < col) then impl cs
      else if r = row && c = col then v
      else T.zero
    in impl m.cells

  let to_string m =
    List.init m.nrows (fun r -> List.init m.ncols (fun c -> get r c m) |> List.map T.to_string |> String.concat " ") |> String.concat "\n"

  let transpose m =
    { cells=List.map (fun (r,c,v) -> c,r,v) m.cells
      |> List.sort (fun (r1,c1,_) (r2,c2,_) -> if r1=r2 then compare c1 c2 else compare r1 r2);
      nrows=m.ncols; ncols=m.nrows }

  let mul a b =
    if a.ncols <> b.nrows then raise Invalid_operation;
    let rec compute r c n =
      if n >= a.ncols then T.zero else T.add (T.mul (get r n a) (get n c b)) (compute r c (n+1))
    in
    let rec gen_row r n =
      if n >= b.ncols then [] else
        let v = compute r n 0 in if v = T.zero then gen_row r (n+1) else (r,n,v)::gen_row r (n+1)
    in
    let rec gen n =
      if n >= a.nrows then [] else
        (gen_row n 0) @ gen (n+1)
    in
    { cells=gen 0; nrows=a.nrows; ncols=b.ncols }

end