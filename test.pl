


arith(First, Diff, Num, Sum) :-
    Num > 0,
    Num1 is Num -1,
    Res is First + Diff * (Num1),
    arith(First, Diff, Num1, Sum1),
    Sum is Res + Sum1.
    
arith(First, _Diff, Num, Sum) :- Num=:=1 , Sum is First.
