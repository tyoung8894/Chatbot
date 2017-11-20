% reader.pl
% Code from Clocksin-Mellish.
% This code reads a sentence in from standard input and gives
% back a list of words.  Puctuation is returned as its own word.
% All letters are turned to lower-case.

% The top level query is read_in(-List).

% Here's a top-level query you can use to see how it works.
try_it:-read_in(L), write(L).

% Read in a sentence 

read_in([W|Ws]):-
	get0(C), readword(C,W,C1), restsent(W, C1, Ws).

% Given a word and the character after it, read in the rest of the sentence.

restsent(W,_,[]):- lastword(W), !.
restsent(_,C,[W1|Ws]):- readword(C,W1,C1), restsent(W1,C1,Ws).

% Read in a single word, given an initial character and remembering what
% character came after the word.

readword(C,W,C1):- single_character(C), !, name(W,[C]), get0(C1).
readword(C,W,C2):- in_word(C, NewC),!, get0(C1), restword(C1,Cs,C2),
	name(W,[NewC|Cs]).
readword(_,W,C2):- get0(C1), readword(C1,W,C2).
restword(C,[NewC|Cs],C2):-in_word(C, NewC), !, get0(C1), restword(C1,Cs,C2).
restword(C,[],C).

% These characters are words on their own: , ; : ? ! = ( ) { } .
single_character(44).
single_character(59).
single_character(58).
single_character(63).
single_character(33).
single_character(46).
single_character(X):- name('=',[X]).
single_character(X):- name('(',[X]).
single_character(X):- name(')',[X]).
single_character(X):- name('{',[X]).
single_character(X):- name('}',[X]).


% Characters that can appear within a word.

% lower-case
in_word(C,C):- C > 96, C < 123.
% upper-case, convert to lower-case
in_word(C,L):- C > 64, C < 91, L is C + 32.
% Numbers
in_word(C,C):- C > 47, C < 58.
% single quote and hyphen.
in_word(39,39).
in_word(45,45).

% Terminators
lastword('.').
lastword('!').
lastword('?').
