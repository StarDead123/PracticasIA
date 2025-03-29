:-op(1,fx,not). %¬
:-op(2,xfx,or). 
:-op(2,xfx,and).
:-op(2,xfx,imp).
:-op(2,xfx,dimp).
:-op(3,xfx,der). %⊢
primer_elemento([Primero|_], Primero).
primer_elemento([], not ⊣).
% Caso base: lista vacía
cuenta_atomos([], ELEMENTOS,ATOM) :- ATOM = 0, ELEMENTOS = 0.

% Caso recursivo para elementos de lista
cuenta_atomos([X|Xs], N_ELEMENTOS,N_ATOM) :-
    cuenta_atomos(Xs, ELEMENTOS_XS, ATOM_XS),
    ((atom(X) -> N_ATOM is ATOM_XS + 1 );N_ATOM is ATOM_XS),
    N_ELEMENTOS is ELEMENTOS_XS + 1.

operaciones_indicadas(LISTA, N_OP):-
    cuenta_atomos(LISTA, N, A), N_OP is N - A.

no_miembro(_, [], 'T').
no_miembro(X, [Y|Ys], B) :-
    (X \= Y, no_miembro(X, Ys, B0), B0 == 'T') -> B = 'T';
    (X \= Y, no_miembro(X, Ys, B0), B0 == 'F') -> B = 'F';
    (X == Y, no_miembro(X, Ys, B0), B0 == 'T') -> B = 'F';
    (X == Y, no_miembro(X, Ys, B0), B0 == 'F') -> B = 'F'.

disjuntas([], _).
disjuntas([X|Xs], Ys) :-
    no_miembro(X, Ys, B),
    disjuntas(Xs, Ys),
    (B == 'T').
    
no_son_disjuntas(A,B) :-
    not(disjuntas(A,B)).



%regla ∧ ⊢
% Φ, Ψ, Γ ⊢ Δ
% -----------
% Φ∧Ψ, Γ ⊢ Δ
valida([PHI and PSI | GAMMA] der DELTA, Validez) :-% Φ∧Ψ, Γ ⊢ Δ
    valida([PHI, PSI | GAMMA] der DELTA, Validez). %Φ, Ψ, Γ ⊢ Δ

%regla ¬⊢
%Γ ⊢ Φ, Δ
%---------
%¬Φ ,Γ ⊢ Δ

valida([not PHI| GAMMA] der DELTA, Validez):- %¬Φ ,Γ ⊢ Δ
    valida(GAMMA der [PHI | DELTA],Validez). %Γ ⊢ Φ, Δ

%regla  ∨ ⊢
%
% Φ,Γ ⊢ Δ  Ψ,Γ ⊢ Δ
% -----------------
% Φ∨Ψ ,Γ ⊢ Δ
valida([PHI or PSI | GAMMA] der DELTA, Validez) :- % Φ∨Ψ ,Γ ⊢ Δ
    valida([PHI | GAMMA] der DELTA, Validez0),
    valida([PSI | GAMMA] der DELTA, Validez1),
    (Validez0 == 'VALIDO',Validez1 == 'VALIDO' -> Validez = 'VALIDO';
    Validez0 == 'VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO').

% →⊢
% Γ ⊢ Φ,Δ  Ψ,Γ ⊢ Δ
% -----------------
% Φ→Ψ, Γ ⊢ Δ
valida([PHI imp PSI | GAMMA] der DELTA, Validez) :-
    %write(GAMMA der [PHI | DELTA]),
    valida(GAMMA der [PHI | DELTA], Validez0),
    %write([PSI | GAMMA] der DELTA),
    valida([PSI | GAMMA] der DELTA, Validez1),
    (Validez0 == 'VALIDO',Validez1 == 'VALIDO' -> Validez = 'VALIDO';
    Validez0 == 'VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO').

% ↔⊢

% ----------------------
% Φ↔Ψ, Γ ⊢ Δ
valida([PHI dimp PSI | GAMMA] der DELTA, Validez) :-
    valida([PHI, PSI | GAMMA] der DELTA, Validez0),
    valida(GAMMA der [PHI, PSI | DELTA], Validez1),
    (Validez0 == 'VALIDO',Validez1 == 'VALIDO' -> Validez = 'VALIDO';
    Validez0 == 'VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO').

% ⊢↔
% Φ, Γ ⊢ Ψ, Δ      Ψ, Γ ⊢ Φ, Δ
% ---------------------------
% Γ ⊢ Φ↔Ψ ,Δ
valida(GAMMA der [PHI dimp PSI | DELTA], Validez) :-
    valida([PHI | GAMMA] der [PSI | DELTA], Validez0),
    valida([PSI | GAMMA] der [PHI | DELTA], Validez1),
    (Validez0 == 'VALIDO',Validez1 == 'VALIDO' -> Validez = 'VALIDO';
    Validez0 == 'VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO').
% regla ⊢→
% Φ,Γ ⊢ Ψ, Δ
% ---------
% Γ ⊢ Φ→Ψ, Δ
valida(GAMMA der [PHI imp PSI | DELTA], Validez) :-
    valida([PHI | GAMMA] der [PSI | DELTA], Validez).

% regla ⊢∨
% Γ ⊢ Φ, Ψ, Δ
% -----------
% Γ ⊢ Φ∨Ψ, Δ

valida(GAMMA der [PHI or PSI | DELTA], Validez) :-
    valida(GAMMA der [PHI, PSI | DELTA], Validez).

%regla ⊢¬
%Γ ⊢ ¬Φ, Δ
%---------
%Φ,Γ ⊢ Δ
valida(GAMMA der [not(PHI) | DELTA], Validez) :-
    valida([PHI | GAMMA] der DELTA, Validez).

% ⊢∧
% Γ ⊢ Φ, Δ     Γ ⊢ Ψ, Δ
% ---------------------
% Γ ⊢ Φ∧Ψ, Δ

valida(GAMMA der [PHI and PSI | DELTA], Validez) :-
    valida(GAMMA der [PHI | DELTA], Validez0),
    valida(GAMMA der [PSI | DELTA], Validez1),
    (Validez0 == 'VALIDO',Validez1 == 'VALIDO' -> Validez = 'VALIDO';
    Validez0 == 'VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'VALIDO' -> Validez = 'NO ES VALIDO';
    Validez0 == 'NO ES VALIDO',Validez1 == 'NO ES VALIDO' -> Validez = 'NO ES VALIDO').

valida(Q der P,Validez):- %p ⊢ p
    operaciones_indicadas(Q, N_OP_Q)
    ,operaciones_indicadas(P, N_OP_P)
    ,N_OP_P == 0
    ,N_OP_Q == 0
    ,format('~w ⊢ ~w~n', [Q, P])
    ,(no_son_disjuntas(P,Q) -> Validez = 'VALIDO'
    ;disjuntas(P,Q) -> Validez = 'NO ES VALIDO').

valida(Q der P,Validez):- %p ⊢ p
    primer_elemento(Q,Qp)
    ,primer_elemento(P,Pp)
    ,(atom(Pp);Pp == not ⊣)->(ultimo_al_principio(P,P2);P2 = P)
    ,(atom(Qp);Qp == not ⊣)->(ultimo_al_principio(Q,Q2);Q2 = Q),
    valida(Q2 der P2,Validez).

% Predicado principal: ultimo_al_principio/2
ultimo_al_principio(Lista, NuevaLista) :-
    append(Prefijo, [Ultimo], Lista),  % Divide la lista en Prefijo + [Último]
    append([Ultimo], Prefijo, NuevaLista).  % Une [Último] + Prefijo