:-op(1,fx,not).
:-op(2,xfx,or).
:-op(2,xfx,and).
:-op(2,xfx,imp).
:-op(2,xfx,dimp).

valor(P, [[P, Valor] | _], Valor).
valor(P, [_ | Resto], Valor) :-
    valor(P, Resto, Valor).

verificarmodelo(P,VectorBooleano,ValorFinal):-
        atom(P),valor(P,VectorBooleano,ValorFinal).

verificarmodelo(not P,VectorBooleano,ValorFinal):- 
        verificarmodelo(P,VectorBooleano,ValorP),(
        (ValorP == 'T' ->  ValorFinal = 'F');
        (ValorP == 'F' ->  ValorFinal = 'T')).

verificarmodelo(P or Q,VectorBooleano,ValorFinal):- 
        verificarmodelo(P,VectorBooleano,ValorP),
        verificarmodelo(Q,VectorBooleano,ValorQ),(
        (ValorP == 'T',ValorQ == 'F' ->  ValorFinal = 'T');
        (ValorP == 'F',ValorQ == 'T' ->  ValorFinal = 'T');
        (ValorP == 'F',ValorQ == 'F' ->  ValorFinal = 'F');
        (ValorP == 'T',ValorQ == 'T' ->  ValorFinal = 'T')).

verificarmodelo(P and Q,VectorBooleano,ValorFinal):- 
        verificarmodelo(not ((not P) or (not Q)),VectorBooleano,ValorFinal).

verificarmodelo(P imp Q,VectorBooleano,ValorFinal):- 
        verificarmodelo((not P) or Q,VectorBooleano,ValorFinal).

verificarmodelo(P dimp Q,VectorBooleano,ValorFinal):- 
        verificarmodelo((P imp Q) and (Q imp P),VectorBooleano,ValorFinal).
%verificarmodelo((not (p or q) dimp (r and (q imp p))) and ((not r and p) and (not q dimp (not p or r))),[[q,'T'],[r, 'F'],[p,'T']],F).
%verificarmodelo((not (p or q) dimp (r and (q imp p))) and ((not r and p) and (not q dimp (not p or r))),[[q,'F'],[r, 'F'],[p,'T']],F).