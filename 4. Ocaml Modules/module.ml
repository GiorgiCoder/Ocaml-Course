module type Readable = sig
  type t
  type arg
  val begin_read : arg -> t
  val end_read : t -> unit
  val at_end : t -> bool
  val read_line : t -> (t * string)
  end

module ReadableString = struct
  type t = string list
  type arg = string
  let begin_read str = String.split_on_char '\n' str (* Spliting string on new lines (into string list) *)
  let end_read lst = ()
  let at_end lst = (lst = [])
  let read_line lst = List.tl lst, List.hd lst (* Removing first element and and return as a line *)
end

module ReadableFile = struct
  type t = in_channel * string option
  type arg = string
  let at_end (_, str) = (str = None)
  let read_line ((chan, Some str) : t) =   (* Read the first line and update the reader file/string *)
    (try (chan, Some (input_line chan))
    with End_of_file -> (chan, None)), str

  let begin_read name = 
    let file = open_in name in
    fst(read_line (file, Some "")) (* Open the reader and set first line to an empty space *)

  let end_read (chan, _) = close_in chan
end

module Reader (R : Readable) = struct
  include R

  let read_all reader =  (* Read all lines, throw them into an accumulator and return it *)
    let rec read_lines acc reader =
      if at_end reader then
        (reader, acc)
      else
        let (reader1, line) = read_line reader in
        read_lines (line :: acc) reader1
    in
    let (reader1, lines) = read_lines [] reader in
    (reader1, String.concat "\n" (List.rev lines))
end


let rs = ReadableString.begin_read "A multiline\ntext"
let k = ReadableString.at_end rs (* e = false *)
let rs, l1 = ReadableString.read_line rs (* l1 = "A multiline" *)
let rs, l2 = ReadableString.read_line rs (* l2 = "text" *)
let e = ReadableString.at_end rs (* e = true *)
let _ = ReadableString.end_read rs

module R = Reader (ReadableString)
let r = R.begin_read "A multiline\ntext"
let r, t = R.read_all r (* t = "A multiline\ntext" *)
let _ = R.end_read 