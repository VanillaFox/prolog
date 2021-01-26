female('Maria Kruglova').
female('Anna Fad').
female('Galina Nikolina').
female('Natalia Smeyanova').
female('Natalia Kruglova').
female('Alexandra Nignikova').
female('Anna Nikolina').
female('Nina Nikolina').
female('Elizabeth Nikolina').
female('Olga Ryzhikova').
female('Galina Smeyanova').
female('Victoria Simkina').
female('Olga Armyitseva').
female('Alina Armyitseva').
female('Vasilisa Ostrovskaya').
female('Irina Sokolova').
male('Sergey Kruglov').
male('Boris Kruglov').
male('Vladimir Fad').
male('Sergey Lebedev').
male('German Black').
male('Alex Kruglov').
male('Sergey Nikolin').
male('Nick Smeyanov').
male('Evgeniy Maslennicov').
male('Dmitriy Maslennicov').
male('Dmitriy Epifanov').
male('Ivan Epifanov').
male('Eremey Epifanov').
male('Efim Simkin').
male('Anton Armyitsev').
male('Nick Kruglov').
male('Vasiliy Fad').
male('Karl Kruglov').

child('Sergey Kruglov', 'Maria Kruglova').
child('Anna Fad', 'Maria Kruglova').
child('Sergey Kruglov', 'Alex Kruglov').
child('Anna Fad', 'Alex Kruglov').
child('Boris Kruglov', 'Natalia Kruglova').
child('Galina Nikolina', 'Natalia Kruglova').
child('Boris Kruglov', 'Karl Kruglov').
child('Galina Nikolina', 'Karl Kruglov').
child('Boris Kruglov', 'Sergey Kruglov').
child('Galina Nikolina', 'Sergey Kruglov').
child('Vladimir Fad', 'Anna Fad').
child('Natalia Smeyanova', 'Anna Fad').
child('German Black', 'Sergey Lebedev').
child('Natalia Kruglova', 'Sergey Lebedev').
child('Sergey Nikolin', 'Galina Nikolina').
child('Alexandra Nignikova', 'Galina Nikolina').
child('Sergey Nikolin', 'Anna Nikolina').
child('Alexandra Nignikova', 'Antonina Nikolina').
child('Sergey Nikolin', 'Nina Nikolina').
child('Alexandra Nignikova', 'Nina Nikolina').
child('Sergey Nikolin', 'Elizabeth Nikolina').
child('Alexandra Nignikova', 'Elizabeth Nikolina').
child('Nick Smeyanov', 'Natalia Smeyanova').
child('Olga Ryzhikova', 'Natalia Smeyanova').
child('Nick Smeyanov', 'Galina Smeyanova').
child('Olga Ryzhikova', 'Galina Smeyanova').
child('Dmitriy Maslennicov', 'Evgeniy Maslennicov').
child('Galina Smeyanova', 'Evgeniy Maslennicov').
child('Ivan Epifanov', 'Eremey Epifanov').
child('Anna Nikolina', 'Eremey Epifanov').
child('Ivan Epifanov', 'Dmitriy Epifanov').
child('Anna Nikolina', 'Dmitriy Epifanov').
child('Efim Simkin', 'Victoria Simkina').
child('Nina Nikolina', 'Victoria Simkina').
child('Anton Armyitsev', 'Olga Armyitseva').
child('Victoria Simkina', 'Olga Armyitseva').
child('Anton Armyitsev', 'Alina Armyitseva').
child('Victoria Simkina', 'Alina Armyitseva').
child('Nick Kruglov', 'Boris Kruglov').
child('Irina Sokolova', 'Boris Kruglov').
child('Vasiliy Fad', 'Vladimir Fad').
child('Vasilisa Ostrovskaya', 'Vladimir Fad').

dever(X,Y,Z) :- child(X, L), child(Z, L), male(X), male(Y), female(Z), child(R, X), child(R, Y), X\=Y.

father(X, Y):- child(X, Y), male(X).
mother(X, Y):- child(X, Y), female(X).
brother(X, Y):- male(Y), child(Z, X), child(Z, Y), X\=Y.
sister(X, Y):- female(Y), child(Z, X), child(Z, Y), X\=Y.
son(X, Y):- child(X, Y), male(Y).
daught(X, Y):- child(X, Y), female(Y).

relative_status(mother(_,_), mother).
relative_status(father(_,_), father).
relative_status(son(_,_), son).
relative_status(daught(_,_), daught).
relative_status(brother(_, _), brother).
relative_status(sister(_, _), sister).

move(X, Y):- mother(Y, X).
move(X, Y):- father(Y, X).
move(X, Y):- child(X, Y).
move(X, Y):- sister(X, Y).
move(X, Y):- brother(X, Y).

relative_name(X, Y, Pred):- mother(Y, X), relative_status(mother(Y, X), Pred).
relative_name(X, Y, Pred):- father(Y, X), relative_status(father(Y, X), Pred).
relative_name(X, Y, Pred):- child(X, Y), male(Y), relative_status(son(Y, X), Pred).
relative_name(X, Y, Pred):- child(X, Y), female(Y), relative_status(daught(Y, X), Pred).
relative_name(X, Y, Pred):- sister(X, Y), relative_status(sister(Y, X), Pred).
relative_name(X, Y, Pred):- brother(X, Y), relative_status(brother(Y, X), Pred).

prolong([H|T], [X, H|T]):- move(H, X), not(member(X, [H|T])).

path_min(X, Y, R):- bdth([[X]], Y, P), reverse(P, R).

bdth([[X|T]|_], X, [X|T]).
bdth([P|QI], X, R):- findall(Z, prolong(P, Z), T), append(QI, T, QO), !, bdth(QO, X, R).

path_to_relative([_], Res, Res).
path_to_relative([X, Y|Tail], Rel, Res):- relative_names(X, Y, Pred), path_to_relative([Y|Tail], [Pred|Rel], Res).
path_to_relative(Path, Res):- path_to_relative(Path, [], Res).

relative(Res, X, Y):- path_min(X, Y, Path), path_to_relative(Path, R), print_result(R, Res).

print_result([Res], Res).
print_result([Head|Tail], Res):- minus(Head, Tail, Res).

minus(H, [H1], Res):- Res = H - H1.
minus(H, [Head|Tail], Res):- T = H - Head, minus(T, Tail, Res).

parse(Nums, Res):- char_number(Nums, 32, Head,Word), parse(Head, Res2), append(Res2, [Word], Res).
parse(Nums, [Nums]):- not(char_number(Nums, 32, _, _)).
parsing(Pr, Words):- name(Pr, Nums), parse(Nums, Words_num), to_words(Words_num, Words_s), sym(Words_s, Words).

to_words([HeadN|TailN], [HeadW|TailW]):- name(HeadW, HeadN), to_words(TailN, TailW).
to_words([],[]).

char_number([Head|Tail], Code, [Head|T2], Res2):- char_number(Tail, Code, T2, Res2), !.
char_number([Code|Tail], Code, [], Tail).
char_number([], _, [], []):- fail.

sym(Pr, Res):- last(Pr, Last_w), name(Last_w, Last_wn), not(length(Last_wn, 1)), last(Last_wn,Sym_n), is_sym(Sym_n),
    append(L_word_n, [Sym_n], Last_wn), append(W_l_w, [Last_w], Pr), name(L_word, L_word_n), append(W_l_w, [L_word], Pr_w2),
    name(Sym,[Sym_n]), append(Pr_w2, [Sym], Res).

is_sym(63).
is_sym(46).

switch_pred(Res, Name_s, X4):- X4 = 'mother', string_to_atom(Name_s, Name), mother(Res, Name).
switch_pred(Res, Name_s, X4):- X4 = 'father', string_to_atom(Name_s, Name), father(Res, Name).
switch_pred(Res, Name_s, X4):- X4 = 'child', string_to_atom(Name_s, Name), child(Name, Res).
switch_pred(Res, Name_s, X4):- X4 = 'brother', string_to_atom(Name_s, Name), brother(Name, Res).
switch_pred(Res, Name_s, X4):- X4 = 'sister', string_to_atom(Name_s, Name), sister(Name, Res).
switch_pred(Res, Name_s, X4):- X4 = 'son', string_to_atom(Name_s, Name), son(Name, Res).
switch_pred(Res, Name_s, X4):- X4 = 'daught', string_to_atom(Name_s, Name), daught(Name, Res).
how_many(X3, X5, Res):- X3 = 'childrens', string_to_atom(X5, Name), findall(T, child(Name, T), L), length(L, Res).

pronoud("he").
pronoud("she").
pronoud("her").
pronoud("him").

save(X):- clause(last(_), true), retractall(last(_)), asserta(last(X)), !.
save(X):- not(clause(last(_), true)), asserta(last(X)), !.

interface(Pr):- parsing(Pr, Sp), result(Sp).

%"Who is her/him mother?"
result([X1, _, X3, X4, _]):- string_lower(X1, "who"), string_lower(X3, H),
    pronoud(H), clause(last(_), true), last(Name), switch_pred(Res, Name, X4),
    write(Res), write(" is "), write(Name), write("'s "), write(X4).

%"Who is _name_'s mother/father/brother/sister?"
result([X1, _, Y1, Y2, X4, _]):- concatenation_of_names(Y1, Y2, Names), string_lower(X1, "who"), not(pronoud(Names)),
    string_to_list(Names,Names_n), char_number(Names_n, 39, Name_n,_), string_to_list(Name,Name_n),
    save(Name), !, switch_pred(Res, Name, X4), write(Res), write(" is "), write(Name), write("'s "), write(X4).

%"Is _name_ him child?"
result([X1, Y1, Y2, X3, X4, _]):- string_lower(X1, "is"), concatenation_of_names(Y1, Y2, X2), string_lower(X3, H), pronoud(H),
    clause(last(_), true), last(Name), string_to_atom(X2, Res), switch_pred(Res, Name, X4).

% "Is _name_ _name1_'s child?"
result([X1, Z1, Z2, Y1, Y2, X4, _]):- concatenation_of_names(Y1, Y2, Names), concatenation_of_names(Z1, Z2, X2),
    string_lower(X1, "is"), not(pronoud(Names)), string_to_list(Names, Names_n), char_number(Names_n, 39, Name_n,_),
    string_to_list(Name, Name_n), save(Name), !, string_to_atom(X2, Res), switch_pred(Res, Name, X4).

%"How many childrens does he have?"
result([_, _, X3, _, X5, _, _]):- string_lower(X5, H), pronoud(H), clause(last(_), true), last(Name), how_many(X3, Name, Res),
    write(Name), write(" have "), write(Res), write(" "), write(X3).

% "How many childrens does _name_ have?"
result([_, _, X3, _, Y1, Y2, _, _]):- concatenation_of_names(Y1, Y2, X5), not(pronoud(X5)), save(X5), how_many(X3, X5, Res),
    write(X5), write(" have "), write(Res), write(" "), write(X3).

%2 names to 1
concatenation_of_names(Name, Sur, Res):- string_to_list(Name, Name_n), string_to_list(Sur, Sur_n),
    append(Name_n, [32], T), append(T, Sur_n, Res_n), string_to_list(Res, Res_n).
