Task:

A future represents the result of an asynchronous computation. Imagine a time-consuming operation, that is relocated to another thread, then the main thread keeps some kind of "handle" to check whether the operation in the other thread has finished, to query the result or as a means to do other operations with the result. This "handle" is what we call a future.

Implement a module Future with a type 'a t that represents a future object. Furthermore, perform these tasks:

1. Implement create : ('a -> 'b) -> 'a -> 'b t, that applies the function given as the first argument to the data given as second argument in a separate thread. A future for the result of this operation is returned.
1. Implement get : 'a t -> 'a that waits for the asynchronous operation to finish and returns the result.
1. Implement then\_ : ('a -> 'b) -> 'a t -> 'b t such that a call then\_ f x returns a future that represents the result of applying f to the result of the computation referred to by x. The application of f must again be asynchronous, so then\_ must not block!
1. Extend your implementation with exception support, such that if an asynchronous operation throws, this exception is passed to the thread where the future resides and can be caught there.
1. Implement when\_any : 'a t list -> 'a t that constructs a future that provides its result once any of the given futures has finished its computation. Make sure that \mio{when\_any} does not block!
1. Implement when\_all : 'a t list -> 'a list t that constructs a future that corresponds to a list of all the results of the given futures.
1. Find additional useful functions for the Future module and implement them.
