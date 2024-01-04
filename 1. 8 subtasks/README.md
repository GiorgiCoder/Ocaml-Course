8 Tasks:

1. (0.3 points)
   Write a function member, which takes a comparision function c, a term t and a list l and returns true if l contains an element e such that e and t are equal with respect to c.

To remind for the sample runs below: the built-in compare function gives compare t e = 0 if t and e are equal.
# member compare 3 [1; 2; 3];;
- : bool = true
# member compare 4 [1; 2; 3];;
- : bool = false
# member compare 'a' ['a'; 'b'; 'c'];;
- : bool = true
2. ( 0.5 points)
   Write a function count\_occurrences, which takes a list list1 and returns a list list2 of pairs (e,n), where e is an element of list1 and n is the number of occurrences of e in list1. Make sure that list2 is given in a sorted form, in the descending order of the occurrences.

Sample runs:
# count\_occurrences ['a'; 'b'; 'a'; 'c'; 'c'; 'a'; 'd'];;
- : (char \* int) list = [('a', 3); ('c', 2); ('b', 1); ('d', 1)]
# count\_occurrences [0; 0; 0; -2; 3; -1; -1; 3; 3; 0];;
- : (int \* int) list = [(0, 4); (3, 3); (-1, 2); (-2, 1)]
# count\_occurrences
         [("str1", 1); ("str1",2); ("str2",1); ("str2",1); ("str1",2)];;
- : ((string \* int) \* int) list =
  [(("str1", 2), 2); (("str2", 1), 2); (("str1", 1), 1)]
3. (0.5 points)
   Write a function `drop_last : 'a list -> 'a list` which takes a list,
   drops its last element and gives beck the remaining part.

Sample runs:
\# drop\_last [1; 2; 3; 4];;
\- : int list = [1; 2; 3]
\# drop\_last [1];;
\- : int list = []
\# drop\_last [];;
Exception: Failure "Empty list has no last element".

4. (0.2 point)
   Modify drop\_last so that it returns an optional value, instead of raising an exception for empty lists. Let this variant be called drop\_last\_opt. Then its type should be 'a list -> 'a list option and sample runs look as
   # drop\_last\_opt [];;
   - : 'a list option = None
   # drop\_last\_opt [1];;
   - : int list option = Some []
   # drop\_last\_opt [1;2;3];;
   - : int list option = Some [1; 2]
4. (0.5 points)
   Write a function zip\_with that, given a binary function and two lists, constructs a new list as in:

`zip_with f [x1; ...; xm] [y1; ...; yn] = [f x1 y1; ...; f xk yk]`
where k is the minimum between n and m.

Sample runs:

      # zip_with (fun x y -> [x;y]) [1;2;3] [5;6];;
      - : int list list = [[1; 5]; [2; 6]]
      # zip_with (fun x y -> [x;y]) [1;2;3] [5;6;7;8];;
      - : int list list = [[1; 5]; [2; 6]; [3; 7]]
      # zip_with (fun x y -> (x,y)) [1;2;3] ['a';'b'];;
      - : (int * int) list = [(1, 'a'); (2, 'b')]
      # zip_with (+) [1;2;3] [5;6];;
      - : int list = [6; 8]
      # zip_with (^) ["aa";"bb";"cc"] ["1";"2"];;
      - : string list = ["aa1"; "bb2"]

 
6. (0.5 points)
   Write a function unzip on lists (i.e., a list of pairs is ‘unzipped’ into a pair of lists) using one of the fold functions you already know. For instance, unzip [('a',1); ('b',2)] = (['a';'b'], [1;2])
6. (0.2 points)
   Show the evaluation steps of unzip [('a',1);('b',2)]

Problem 8: (2.5 points). (1.25 points for the table, 1.25 for the scorers)
Assume an information about a football game is given by a tuple (team1, scorers1,team2, scorers2) where scorers1 (resp. scorers2) is the list of players who scored goals in this game for team1 (resp. for team2).

For instance, the information about the World Cup 2018 final game, France - Croatia 4-2, would be given like this:

(Fra, ["OG"; "Griezmann"; "Pogba"; "Mbappe"], Cro, ["Perisic"; "Mandzukic"])

"OG" indicates that it was an own-goal by a Croatian player, without giving the name.

We assume that a list of such game data is given. They give information about games in a round-robin tournament (e.g., World Cup or Euro groups, or league games).

Your task is to write a function table\_and\_scorers, which takes the list of above defined tuples and returns two lists:

(a) The list of tuples for each team of the form (t, g, w, d, l, gf, ga, p), where t stands for a team, g for games played, w for wins, d for draws, l for losses, gf for goals for (scored goals), ga for goals against (conseded goals), p for points, which records the summary of all the games played by the team.

Sort the list of such tuples

- first by points,
- in case of a tie by goal difference (`gf` - `ga`),
- in case of a tie by `goals_for`,
- in case of a tie randomly.

In other words, the first task in to construct the tournament table.
(b) The list of goalscorers as triples (player, team, goals). Sort the list first by goals, in case of a tie by the player name alphabetically.

Example: Assume that the type team is defined as type team = Arg | Sau | Mex | Pol | Por | Kor | Uru | Gha and the information about WC 2023 C and H group games (https://en.wikipedia.org/wiki/2022\_FIFA\_World\_Cup#Group\_C https://en.wikipedia.org/wiki/2022\_FIFA\_World\_Cup#Group\_H)

is given as

let wc22\_C =
[(Arg, ["Messi"], Sau, ["Al-Shehri"; "Al-Dawsari"]);
(Mex, [], Pol, []);
(Pol, ["Zielinski"; "Lewandowski"], Sau, []);
(Arg, ["Messi"; "Fernandez"], Mex, []);
(Pol, [], Arg, ["Mac Allister"; "Alvarez"]);
(Sau, ["Al-Dawsari"], Mex, ["Martin"; "Chavez"])
]
let wc22\_H =
[(Uru, [], Kor, []);
(Por, ["Ronaldo"; "Felix"; "Leao"], Gha, ["Ayew"; "Bukari"]);
(Kor, ["Cho Gue-sung"; "Cho Gue-sung"], Gha, ["Salisu"; "Kudus"; "Kudus"]);
(Por, ["Fernandes"; "Fernandes"], Uru, []);
(Kor, ["Kim Young-gwon"; "Hwang Hee-chan"], Por, ["Horta"]);
(Gha, [], Uru, ["De Arrascaeta"; "De Arrascaeta"])
]

Your function tableandscorers should behave, e.g., as follows:
# table\_and\_scorers wc22\_C;;
- : (team \* int \* int \* int \* int \* int \* int \* int) list \*
  (string \* team \* int) list
  =
  ([(Arg, 3, 2, 0, 1, 5, 2, 6); (Pol, 3, 1, 1, 1, 2, 2, 4);
  (Mex, 3, 1, 1, 1, 2, 3, 4); (Sau, 3, 1, 0, 2, 3, 5, 3)],
  [("Al-Dawsari", Sau, 2); ("Messi", Arg, 2); ("Al-Shehri", Sau, 1);
  ("Alvarez", Arg, 1); ("Chavez", Mex, 1); ("Fernandez", Arg, 1);
  ("Lewandowski", Pol, 1); ("Mac Allister", Arg, 1); ("Martin", Mex, 1);
  ("Zielinski", Pol, 1)])
# table\_and\_scorers wc22\_H;;
- : (team \* int \* int \* int \* int \* int \* int \* int) list \*
  (string \* team \* int) list
  =
  ([(Por, 3, 2, 0, 1, 6, 4, 6); (Kor, 3, 1, 1, 1, 4, 4, 4);
  (Uru, 3, 1, 1, 1, 2, 2, 4); (Gha, 3, 1, 0, 2, 5, 7, 3)],
  [("Cho Gue-sung", Kor, 2); ("De Arrascaeta", Uru, 2); ("Fernandes", Por, 2);
  ("Kudus", Gha, 2); ("Ayew", Gha, 1); ("Bukari", Gha, 1); ("Felix", Por, 1);
  ("Horta", Por, 1); ("Hwang Hee-chan", Kor, 1); ("Kim Young-gwon", Kor, 1);
  ("Leao", Por, 1); ("Ronaldo", Por, 1); ("Salisu", Gha, 1)])

Defining football team type

type team = Arg | Sau | Mex | Pol | Por | Kor | Uru | Gha

Sample data, from the groups of the WC 2022 tournament

let wc22\_C =
[(Arg, ["Messi"], Sau, ["Al-Shehri"; "Al-Dawsari"]);
(Mex, [], Pol, []);
(Pol, ["Zielinski"; "Lewandowski"], Sau, []);
(Arg, ["Messi"; "Fernandez"], Mex, []);
(Pol, [], Arg, ["Mac Allister"; "Alvarez"]);
(Sau, ["Al-Dawsari"], Mex, ["Martin"; "Chavez"])
]
let wc22\_H =
[(Uru, [], Kor, []);
(Por, ["Ronaldo"; "Felix"; "Leao"], Gha, ["Ayew"; "Bukari"]);
(Kor, ["Cho Gue-sung"; "Cho Gue-sung"], Gha, ["Salisu"; "Kudus"; "Kudus"]);
(Por, ["Fernandes"; "Fernandes"], Uru, []);
(Kor, ["Kim Young-gwon"; "Hwang Hee-chan"], Por, ["Horta"]);
(Gha, [], Uru, ["De Arrascaeta"; "De Arrascaeta"])
]
