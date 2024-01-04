Task:

We define the signature:

module type Readable = sig

type t

type arg

val begin\_read : arg -> t

val end\_read : t -> unit

val at\_end : t -> bool

val read\_line : t -> (t \* string)

end

to describe a source from which we can read text line by line. Notice, that the arg type is a means for the implementation to specifiy the argument it needs to initialize reading with begin\_read. While at\_end checks whether reading reached the end of the input, read\_line is used to read the next line (text until next newline character '\n') and move the reading position forward.

1. Implement a module ReadableString, that is of type Readable and is used to read from a string. The string is given to begin\_read.
1. Implement a module ReadableFile, that is of type Readable and allows to read from a file. The name of the file is given to begin\_read.
1. Implement a functor Reader that extends a given Readable such that all types and values of the Readable are also available on the Reader. Furthermore, it provides a function read\_all : t -> (t \* string) that reads the entire text that is available.
