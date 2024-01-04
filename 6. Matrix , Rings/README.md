We define the signature

module type Ring = sig

type t

val zero : t

val one : t

val add : t -> t -> t

val mul : t -> t -> t

val compare : t -> t -> int

val to\_string : t -> string

end

of an algebraic ring structure, where add and mul are the two binary operations on the set of elements of type t. Values zero and one represent the identity elements regarding addition and multiplication. The function compare establishes a total order on the elements of the set. The auxiliary function to\_string is used to generate a string representation of an element.

Furthermore, a matrix is given by the signature:

module type Matrix = sig

type elem

type t

val create : int -> int -> t

val identity : int -> t

val from\_rows : elem list list -> t

val set : int -> int -> elem -> t -> t

val get : int -> int -> t -> elem

val transpose : t -> t

val add : t -> t -> t

val mul : t -> t -> t

val to\_string : t -> string

end

Here, elem and t represent the types of the elements of the matrix and the matrix itself, respectively. The functions have the following semantics:

create n m creates an empty (all zeroes) nÃ—m matrix.

identity n creates an nÃ—n identity matrix.

from\_rows l creates a matrix from the given list of rows (lists of elements). You may assume that l is non-empty and all lists have the same length.

set r c v m sets the element at row r and column c in matrix m to value v.

get r c m returns the element at row r and column c from matrix m.

transpose m returns the transpose of matrix m.

add a b adds matrices a and b component-wise.

mul a b computes the matrix multiplication of a and b.

to\_string m produces a string representation of m. Columns shall be separated by single whitespaces and rows by a newline character \ n.

Perform these tasks:

1. Implement a module IntRing that implements the Ring signature for the int type.
1. Implement a module FloatRing that implements the Ring signature for the float type.
1. Define a signature FiniteRing that extends the Ring signature with a value elems that represents a list of all elements of the ring's finite set. Make sure that everything in the Ring signature is part of FiniteRing (without copy-pasting them)!
1. Implement a module BoolRing that implements the FiniteRing signature for the bool type.
1. Implement a functor SetRing that models a ring over the power set of the set in the FiniteRing passed as the functor's argument. SetRing has to implement the Ring signature. We use union and intersection as add and mul operations. The representation produced by to\_string is "{e1,â€¦,en}". For compare we use a bit of an unconventional order. First, we order the elements in the set by their own order and then compare the sets lexicographically, e.g. {}<{1,2,3}<{2}<{2,3}<{3}

1. Implement a functor DenseMatrix that satisfies the Matrix signature. The argument of the functor is a Ring that provides everything to implement the matrix operations. The DenseMatrix is supposed to store all elements in the matrix in a list of rows, which are lists of elements.
1. Implement a functor SparseMatrix that satisfies the Matrix signature. The argument of the functor is a Ring that provides everything to implement the matrix operations. The SparseMatrix stores only those elements of the matrix that are non-zero.
