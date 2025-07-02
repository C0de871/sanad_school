married(jehad, amal).
married(lina,ali).

married(X):- married(X,_), !; married(_,X).

