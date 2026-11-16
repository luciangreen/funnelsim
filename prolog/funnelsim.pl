% funnelsim: a sales funnel. Each stage passes on a whole-number percentage of the people who
% reached it (rounded down). simulate/3 gives the count at every stage; leads_needed/4 finds the
% fewest leads that give a target number of sales (searching up to a limit); bottleneck/2 names
% the stage with the lowest rate.
%?- simulate(1000, [stage(visit, 40), stage(trial, 25), stage(buy, 50)], C).   % C = [1000, 400, 100, 50]
%?- leads_needed([stage(a, 50), stage(b, 50)], 3, 1000, L).                   % L = 12
:- module(funnelsim, [simulate/3, sales/3, leads_needed/4, bottleneck/2]).
:- use_module(library(lists)).
:- use_module(library(apply)).

simulate(Leads, Stages, [Leads|Cs]) :- foldl([stage(_, R), N0-A0, N-[N|A0]]>>( N is N0 * R // 100 ), Stages, Leads-[], _-Rev), reverse(Rev, Cs).
sales(Leads, Stages, S) :- simulate(Leads, Stages, Cs), last(Cs, S).

leads_needed(Stages, Target, Max, L) :- between(0, Max, L), sales(L, Stages, S), S >= Target, !.

bottleneck(Stages, Name) :- Stages = [_|_], foldl([stage(N, R), B0-R0, B-R1]>>( R < R0 -> B = N, R1 = R ; B = B0, R1 = R0 ), Stages, none-101, Name-_).
