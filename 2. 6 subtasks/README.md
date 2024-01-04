6 Tasks:

Problem 1: 0.8 points.

Find functions f1, f2, and f3, such that

fold\_left f1 [] [(a1, b1) ; ... ; (an, bn)] for arbitrary ai, bi computes the list [(b1, a1); ... ; (bn, an) ]

fold\_left f2 [] [a\_0 ; ... ; a\_{n−3} ; a\_{n−2}; a\_{n−1}; a\_n] for arbitrary elements a\_i computes the list [a\_n; a\_{n−2} ; ... ; a\_0 ; ... ; a\_{n−3} ; a\_{n−1}]

fold\_left f3 (fun \_ -> 0) [(k1 , v1) ; ... ; (kn, vn) ] computes a function g such that g(ki) = vi for all 1 ≤ i ≤ n. The k's are assumed to be pairwise distinct.

WRITE YOUR IMPLEMENTATIONS OF f1, f2, AND f3.



Problem 2: 0.8 points.

Rewrite the following functions in a tail-recursive form:

let rec map f = function

| [] -> []

| x :: xs -> f x :: map f xs


let rec replicate n x =

if n < 1 then [] else x :: replicate (n-1) x

Call the tail recursive variants respectively map\_tr and replicate\_tr

\*

Definition of lazy lists

(\* -----------------------------------------------------------------------------

* 'a custom\_llist
* -----------------------------------------------------------------------------
* Defines custom lazy lists.

\*)

type 'a custom\_llist = (unit -> 'a custom\_cell) and 'a custom\_cell = NilC | ConsC of ('a \* 'a custom\_llist)

type 'a ocaml\_llist = 'a ocaml\_cell Lazy.t and 'a ocaml\_cell = NilO | ConsO of ('a \* 'a ocaml\_llist)



Problem 3: 0.8 points

Implement a mapping function that maps a function over a lazy list. Implement it both for custom and OCaml lazy list variants. Call them respectively map\_over\_custom\_llist and map\_over\_ocaml\_llist.



Problem 4: 0.8 points

Implement a merging function that combines two sorted lazy lists.

The idea of merging two lists: merge [1;4;6;7;8; ... ] [1;2;3;4;10; ... ] = [1;1;2;3;4;4;6;7;8;10; ... ]

Implement the function both for custom and OCaml lazy list variants. Call them respectively merge\_custom\_llists and merge\_ocaml\_llists.



Problem 5: 0.8 points

Implement a function that drops duplicates from a sorted lazy list.

Implement it both for custom and OCaml lazy list variants. Call them respectively drop\_dupl\_custom\_llist and drop\_dupl\_ocaml\_llist.



Problem 6: 1.0 points

Implement a function hamming that lazily computes the infinite sequence of Hamming numbers (i.e., all natural numbers whose only prime factors are 2, 3, and 5), e.g., hamming = [1;2;3;4;5;6;8;9;10;12;15;16;18;20; ... ]

Implement it both for custom and OCaml lazy list variants. Call them respectively hamming\_custom\_llist and hamming\_ocaml\_llist.

