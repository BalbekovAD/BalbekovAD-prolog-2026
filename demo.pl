use_module(library(solution_sequences)).
% if you call `swipl demo.pl` on this file, you will load it in repl
% alternatively you can just start `swipl` and do `[demo].` in REPL
% REPL starts with `?-` meaning we can write "queries" to our "database" of facts and rules

plus(z, N, N).
plus(s(M), N, s(P)) :- plus(M, N, P). % z and s are functional symbols (you can call `z' a constant)
% ?- plus(s(z), s(z), X). add as usual
% ?- plus(s(z), X, s(s(s(z)))). subtraction
% lt(z, s(_)).
% lt(s(X), s(Y)) :- lt(X, Y).
lt(X, Y) :- plus(X, s(_), Y). % you do not even need to write it in usual functional way, declarative world is just like pure mathematics
% _ unifies with everything

% order of execution in Prolog is top-down, left to right
mother(trude, sally).
father(tom, sally).
father(tom, erica).
father(mike, tom).
 
sibling(X, Y) :- parent(Z, X), parent(Z, Y).
parent(X, Y) :- father(X, Y).
parent(X, Y) :- mother(X, Y).
% ?- trace. to do it step by step
% ?- sibling(sally, erica). returns yes

times(z, _, z).
times(s(X), Y, Z) :- plus(M, Y, Z), times(X, Y, M).
% as Prolog is declarative, we can factorize numbers with only `times` declared
% ?- lt(s(z), X), lt(s(z), Y), times(X, Y, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))
bugtimes(z, _, z).
bugtimes(s(N1), N2, N3_2) :- bugtimes(N1, N2, N3), plus(N3, N2, N3_2).
% ?- lt(s(z), X), lt(s(z), Y), bugtimes(X, Y, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))
% it loops! let's use `trace.` to debug. it appears that this code tries to multiply two random numbers and then tries to obtain appropriate sum, that's why it diverges

append([], Y, Y).                           % this is a fact
append([X|T], Y, [X|R]) :- append(T, Y, R). % this is a rule
% [] is empty list constructor, [X|T] is "cons X T", [X,Y] is "cons X (cons Y nil)"
% beware that `append` is not a function, but a **relation** (predicate), so it does not "return" anything, it **relates** different things
% ?- append([1, 2], [3, 4], Result). % variables are Capitalized
% ?- append([1, 2], Y, [1, 2, 3, 4]). % declarative programming: the description of the problem and the way how to solve it are split, so we can obtain different "programs" from the save problem description
% ?- append(X, Y, [1,2,3,4]). % we can even do this: `;' allows us to get different answers, as there could be many in general
% ?- append(X, X, [1,2,1,2]). % this works too
% ?- append(X, X, [1,2,3,4]). % you can even know if there is no answer at all
% ?- append(X, Y, [A, 2, C]). % because of this generality of declarative programming you can place variables anywhere

notelement(_, []).
notelement(X, [Y|T]) :- X \= Y, notelement(X, T).
% if we want to *disunify* two terms, we use disequality \=
% ?- notelement(3, [1,2]). returns true
% ?- notelement(3, [1,2,3]). returns false
% ?- notelement(X, [1,2,3]). returns false, as X might be 1

sum([], 0).
sum([H|T], N) :- sum(T, M), N is M + H.
% you even can do arithmetic in Prolog. `is' operator enforces evaluation order, so this program cannot be run "backwards"
% arithmetic is obviously not a part of pure first-order logic, it is a **first-order theory**
% we will talk on first-order theories in the context of the SMT-solving later









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this predicate is used for testing
test_yes_no(P) :- P -> writeln("Yes"); writeln("No").

% Exercise: Write a Prolog predicate sublist(X,Y) that is true if list X is a sublist of list Y. A sublist is defined as the original list, in the same order, but in which some elements may have been removed. (2 points)
% sublist(X, Y) :- ...
sublist([], _).
sublist(Y, Y).
sublist(X, [_|Y]) :- sublist(X, Y).
sublist([E|X], [E|Y]) :- sublist(X, Y).
% tests
:- test_yes_no(sublist([a,b],[a,e,b,d,s,e])). % Yes
:- test_yes_no(sublist([a,b],[a,e,e,f])). % No
:- test_yes_no(sublist([a,b],[b,a])). % No
:- test_yes_no(sublist([],[a,e,e,f])). % Yes
:- test_yes_no(sublist([a],[])). % No
:- findall(X, sublist(X,[a,b,c]), Res), writeln(Res). % something like [[],[a],[a,b],[a,b,c],[a,c],[b],[b,c],[c]] (inner lists may repeat or be in another order)

% Exercise: Write a Prolog predicate has_duplicates(X) that is true if list X contains duplicated elements (that is at least 2 copies of an element). (2 points)
% has_duplicates(X) :- ...
my_contains(X, [X]).
my_contains(X, [X|_]).
my_contains(X, [_|T]) :- my_contains(X, T).

has_duplicates([E|L]) :- my_contains(E, L).
has_duplicates([_|L]) :- has_duplicates(L).


% tests
:- test_yes_no(has_duplicates([a,e,b,d,s,e])). % Yes
:- test_yes_no(has_duplicates([a,b,d,s,e])). % No
:- test_yes_no(has_duplicates([])). % No

% Prolog can be used as a sophisticate database system in which data is stored in the form of structured predicates. In this problem we consider a database of smoothie stores. Each store has a name, a list of employees, and a list of smoothie that can be purchased in the store, which are encoded in a store predicate. Each smoothie is defined by a name, a list of fruits, and a price, which are encoded in a smoothie predicate. For example, here are three predicates defining three different smoothie stores:
store(best_smoothies, [alan,john,mary],
      [ smoothie(berry, [orange, blueberry, strawberry], 2),
        smoothie(tropical, [orange, banana, mango, guava], 3),
        smoothie(blue, [banana, blueberry], 3) ]).

store(all_smoothies, [keith,mary],
      [ smoothie(pinacolada, [orange, pineapple, coconut], 2),
        smoothie(green, [orange, banana, kiwi], 5),
        smoothie(purple, [orange, blueberry, strawberry], 2),
        smoothie(smooth, [orange, banana, mango],1) ]).

store(smoothies_galore, [heath,john,michelle],
      [ smoothie(combo1, [strawberry, orange, banana], 2),
        smoothie(combo2, [banana, orange], 5),
        smoothie(combo3, [orange, peach, banana], 2),
        smoothie(combo4, [guava, mango, papaya, orange],1),
        smoothie(combo5, [grapefruit, banana, pear],1) ]).

% Exercise: Write a Prolog predicate more_than_four(X) that is true if store X has four or more smoothies on its menu. (2 points)
% more_than_four(X) :- ...
more_than_four(X) :- store(X, _, [_,_,_,_ | _]).

% tests
:- findall(_, more_than_four(best_smoothies), Res), writeln(Res). % []
:- findall(X, more_than_four(X), Res), writeln(Res). % [all_smoothies,smoothies_galore] (is some order)

% Exercise: Write a Prolog predicate exists(X) that is true if there is a store that sells a smoothie named X. (2 points)
% exists(X) :- ...
my_list_contains(S, [S|_]).
my_list_contains(S, [_|R]) :- my_list_contains(S, R).
exists(X) :- store(_, _, L), my_list_contains(smoothie(X, _, _), L).
% tests
:- test_yes_no(exists(combo1)). % Yes
:- test_yes_no(exists(slimy)). % No
:- findall(X, exists(X), Res), writeln(Res). % [berry,tropical,blue,pinacolada,green,purple,smooth,combo1,combo2,combo3,combo4,combo5] (in some order)

% Exercise: Write a Prolog predicate smoothies_in_store(X,L) that is true if there is a store named X, and if L is the list of smoothie names on the store's menu. (2 points)
% smoothies_in_store(X,L) :- ...
my_smoothies_names_list([], []).
my_smoothies_names_list([N | R], [smoothie(N, _, _) | S]) :- my_smoothies_names_list(R, S).
smoothies_in_store(X, L) :- store(X, _, N), my_smoothies_names_list(L, N).
% tests
:- findall(L, smoothies_in_store(all_smoothies,L), Res), writeln(Res). % [[pinacolada,green,purple,smooth]] (in some order)
:- findall(Store/L, smoothies_in_store(Store,L), Res), writeln(Res). % [best_smoothies/[berry,tropical,blue],all_smoothies/[pinacolada,green,purple,smooth],smoothies_galore/[combo1,combo2,combo3,combo4,combo5]] (in some order)

% Exercise: Write a Prolog predicate find_smoothie(Store, Smoothie, Wants, Hates) that is true if Store has a Smoothie which ingredients contain every ingredient in list Wants and have no ingredient in list Hates (5 points)
% NOTE: you may feel temptation to google something like "not in Prolog", and you will find a lot of fancy features, like `!', "cuts", etc. You do not need them in this task, do not complicate it for youself! Instead, just write another predicate based on disequality `\=` operator.
% find_smoothie(Store, Smoothie, Wants, Hates) :- ...
% MY COMMENT find_smoothie(store(_, _, AllSmoothies), Smoothie, Wants, Hates).
% MY COMMENT my_ingredients_wants(Ingredients, Wants).
% MY COMMENT my_ingredient_wants(Ingredient, Wants).
% MY COMMENT my_ingredients_hates(Ingredients, Hates).
% MY COMMENT my_ingredient_hates(Ingredient, Hates).

my_ingredient_wants(Ingredient, [Ingredient|_]).
my_ingredient_wants(Ingredient, [_| Wants]) :- my_ingredient_wants(Ingredient, Wants).

% my_ingredients_wants(_, []).
% my_ingredients_wants([Ingredient | RestIng], Wants) :- my_ingredient_wants(Ingredient, Wants), my_ingredients_wants(RestIng, Wants).

my_ingredient_hates(_, []).
my_ingredient_hates(Ingredient, [Hate | Hates]) :- Ingredient \= Hate, my_ingredient_hates(Ingredient, Hates).

% my_ingredients_hates([Ingredient | RestIng], Hates) :- my_ingredient_hates(Ingredient, Hates), my_ingredients_hates(RestIng, Hates).
% my_ingredients_hates(_, []).

my_ingredients_wants(_, []).
my_ingredients_wants(Ingredients, [Want | Wants]) :- my_ingredient_wants(Want, Ingredients), my_ingredients_wants(Ingredients, Wants).

my_ingredients_hates([], _).
my_ingredients_hates([Ingredient | RestIng], Hates) :- my_ingredient_hates(Ingredient, Hates), my_ingredients_hates(RestIng, Hates).

my_ingredients(Ingredients, Wants, Hates) :- my_ingredients_wants(Ingredients, Wants), my_ingredients_hates(Ingredients, Hates).

my_good_smoothie(smoothie(_, Ingredients, _), Wants, Hates) :- my_ingredients(Ingredients, Wants, Hates).
my_good_smoothies([Smoothie|_], Smoothie, Wants, Hates) :- my_good_smoothie(Smoothie, Wants, Hates).
my_good_smoothies([_|Smoothies], Smoothie, Wants, Hates) :- my_good_smoothies(Smoothies, Smoothie, Wants, Hates).

% find_smoothie(store(_, _, AllSmoothies), smoothie(_, Ingredients, _), [], []).
% find_smoothie(store(_, _, [smoothie(_, Ingredients, _) | _]), smoothie(_, Ingredients, _), Wants, Hates) :- my_ingredients(Ingredients, Wants, Hates).
% find_smoothie(store(_, _, [_ | RestSmoothies]), smoothie(_, Ingredients, _), Wants, Hates) :- find_smoothie(store(_, _, RestSmoothies), smoothie(_, Ingredients, _), Wants, Hates).
find_smoothie(Store, Smoothie, Wants, Hates) :- store(Store, _, Smoothies), my_good_smoothies(Smoothies, smoothie(Smoothie, _, _), Wants, Hates).

% tests
% Basically, if a user wants a smoothie with banana and orange, but hates blueberries and mango, the predicate tells that user about smoothies, and the stores that sells them, that match these requirements. For instance:
:- findall(Store-Smoothie, find_smoothie(Store,Smoothie,[banana,orange],[blueberry,mango]), Res), writeln(Res). % [all_smoothies-green,smoothies_galore-combo1,smoothies_galore-combo2,smoothies_galore-combo3] (in some order)
% Note that the query should give the same results for all possible orders of fruits in lists D and U:
:- findall(Store-Smoothie, find_smoothie(Store,Smoothie,[orange,banana],[mango,blueberry]), Res), writeln(Res). % [all_smoothies-green,smoothies_galore-combo1,smoothies_galore-combo2,smoothies_galore-combo3] (in some order)
% To ask for all smoothies that have mango, one can just type:
:- findall(Store-Smoothie, find_smoothie(Store,Smoothie,[mango],[]), Res), writeln(Res). % [best_smoothies-tropical,all_smoothies-smooth,smoothies_galore-combo4]
% To ask for all smoothies that have no banana:
:- findall(Store-Smoothie, find_smoothie(Store,Smoothie,[],[banana]), Res), writeln(Res). % [best_smoothies-berry,all_smoothies-pinacolada,all_smoothies-purple,smoothies_galore-combo4]
