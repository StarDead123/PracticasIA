:-op(1,fx,neg).
:-op(2,xfx,or).
:-op(2,xfx,and).
:-op(2,xfx,imp).
:-op(2,xfx,dimp).
valida([P ⊢ P],Validez):-
        Validez = 'Valida'.