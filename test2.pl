


arith(Num, Sum) :-
    Num > 0,
    Res is Num * Num,
    Num1 is Num -1,
    arith(Num1, Sum1),
    Sum is Res + Sum1.
    
arith(Num, Sum) :- Num=:=1 , Sum is 1.
