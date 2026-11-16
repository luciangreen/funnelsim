% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/funnelsim').

% Domain: funnels of 1..3 stages with rates 0, 25, 50, 100; leads 0..60; targets 0..5.
rate(R) :- member(R, [0, 25, 50, 100]).
funnel(Fs) :- between(1, 3, N), numlist(1, N, Is), maplist([I, stage(I, R)]>>rate(R), Is, Fs).

% 1. Counts never rise from one stage to the next.
theorem(counts_nonincreasing) :- forall(( funnel(Fs), between(0, 60, L) ), ( simulate(L, Fs, Cs), forall(nextto(A, B, Cs), A >= B) )).

% 2. More leads never give fewer sales.
theorem(monotone_in_leads) :- forall(( funnel(Fs), between(0, 59, L) ), ( sales(L, Fs, S), L1 is L + 1, sales(L1, Fs, S1), S1 >= S )).

% 3. leads_needed is the smallest: it reaches the target and one fewer lead does not.
theorem(leads_needed_minimal) :- forall(( funnel(Fs), between(0, 5, T), leads_needed(Fs, T, 200, L) ), ( sales(L, Fs, S), S >= T, ( L =:= 0 -> true ; L0 is L - 1, sales(L0, Fs, S0), S0 < T ) )).

% 4. Raising any stage's rate never lowers sales.
theorem(better_rate_never_hurts) :- forall(( funnel(Fs), nth1(I, Fs, stage(N, R), Rest), rate(R2), R2 > R, between(0, 60, L) ), ( nth1(I, Fs2, stage(N, R2), Rest), sales(L, Fs, S), sales(L, Fs2, S2), S2 >= S )).
