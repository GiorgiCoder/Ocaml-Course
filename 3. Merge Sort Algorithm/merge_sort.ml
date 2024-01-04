let merge_sort list =
  let rec merge1 acc = function
    | ([], []) -> List.rev acc
    | (xs, [])
    | ([], xs) -> List.rev_append acc xs
    | ((x::xs), (y::ys)) ->
        if x < y
        then merge1 (x::acc) (xs, y::ys)
        else merge1 (y::acc) (x::xs, ys)
  in
  let rec merge acc = function
    | xs::ys::t -> merge ((merge1 [] (xs, ys))::acc) t
    | t -> t @ acc
  in
  let rec loop = function
    | _::_::_ as list -> loop (merge [] list)
    | list -> list
  in
  loop (List.map (fun x -> [x]) list);;