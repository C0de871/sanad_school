
% :- dynamic is_exist/3.
% addSquare(X,Y,Z) :- is_exist(X,Y,Z),!.
% addSquare(X,Y,Z) :- Z is (X+Y)*(X+Y), assert(is_exist(X,Y,Z)).

% :- dynamic is_match/3.
% matchy(W1,W2,Result):- is_match(W1,W2,Result),!.
% matchy(W1,W2,Result):- (W1==W2 -> Result = true ; Result = false),  assert(is_match(W1,W2,Result)).

% happy(a).
% happy(b).
% happy(c).

% writeallhappy:- happy(X),write(X), nl,fail.
% writeallhappy.

getnum(To,To,To):-!.
getnum(From,To,From):- From<To.
getnum(From,To,N):- From<To ,write("* "), F is From+1, getnum(F,To,N).

grid(_,0):-!.

grid(Column,Row):- getnum(0,Column,Column),nl,Row1 is Row-1 ,grid(Column,Row1).
