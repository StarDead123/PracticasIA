:-op(1,fx,neg).
:-op(2,xfx,or).
:-op(2,xfx,and).
:-op(2,xfx,imp).
:-op(2,xfx,dimp).
trans(F,F):- atom(F).
trans(neg F, neg G):- trans(F,G).
trans(F1 or F2, G1 or G2):-
        trans(F1,G1),
        trans(F2,G2).
trans(F1 and F2, neg((neg G1) or (neg G2))):-
        trans(F1,G1),
        trans(F2,G2).
trans(F1 imp F2, neg(G1) or G2):-
        trans(F1,G1),
        trans(F2,G2).
trans(F1 dimp F2, R):-
        trans((F1 imp F2) and (F2 imp F1),R).