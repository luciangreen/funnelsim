# funnelsim

a sales funnel. Each stage passes on a whole-number percentage of the people who reached it (rounded down). simulate/3 gives the count at every stage; leads_needed/4 finds the fewest leads that give a target number of sales (searching up to a limit); bottleneck/2 names the stage with the lowest rate.

## Use

```prolog
?- use_module(prolog/funnelsim).
?- simulate(1000, [stage(visit, 40), stage(trial, 25), stage(buy, 50)], C).   % C = [1000, 400, 100, 50]
?- leads_needed([stage(a, 50), stage(b, 50)], 3, 1000, L).                   % L = 12
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. funnels of 1..3 stages with rates 0, 25, 50, 100; leads 0..60; targets 0..5.

1. Counts never rise from one stage to the next.
2. More leads never give fewer sales.
3. leads_needed is the smallest: it reaches the target and one fewer lead does not.
4. Raising any stage's rate never lowers sales.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
