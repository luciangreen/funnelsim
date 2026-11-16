:- module(cases, [title/1, case/3]).
:- use_module('../prolog/funnelsim').
:- use_module(engine).
title('funnelsim').
funnel_g(Fs) :- rnd_int(1, 5, N), length(Ns, N), append(Ns, _, [visit, signup, trial, demo, buy]), maplist([Nm, stage(Nm, R)]>>rnd_int(5, 90, R), Ns, Fs).
case(simulate, [L, Fs], simulate) :- rnd_int(0, 10000, L), funnel_g(Fs).
case(leads_needed, [Fs, T, 100000], leads_needed) :- funnel_g(Fs), rnd_int(0, 20, T).
case(bottleneck, [Fs], bottleneck) :- funnel_g(Fs).
