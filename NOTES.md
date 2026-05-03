
## Properties of the ODE solvers

- Package + ref to CRAN
- Engine + solver type + ref to lib (if available)
- Algorithms
- Stiffness + algorithms
- Model execution type (Interpreted / Compiled)
- Time Events
- Conditional Events
- Format of the ODE system + notes
- DAE
- DDE
- Authors summary
- Download counts (CRAN)
- GitHub stars
- License

## Packages

https://cran.r-project.org/web/views/DifferentialEquations.html

### Open source ecosystem

+ deSolve
+ rxode2
+ mrgsolve
+ dMod => Depend on => deSolve (Toolbox)
+ pracma
+ odin
+ PKPDsim
+ EpiModel => deSolve (Epidemiological models, same format as deSolve but restricted, Framework with different methods)
+ PBSddesolve (implemented algorithm for DDE solv95, R function format, connected to PBSModeling toolbox)
+ sundialr (r interface to Sundials, looks unstable)
+ r2sundials (R interface to Sundials, looks unstable)
+ rstan => Depend on => Stan Math Library (C++) (Stan DSL and solvers)
+ rodeo (own Table format for ODE system, but uses deSolve as engine)
- bvpSolve
- diffeqr / JuliaCall => Julia
- reticulate + SciPy => Python

### enterprise ecosystem

- RsNLME - Certara
- RDarwin - Certara
- IQRTools
- mlxR - Monolix / Lixoft

### removed

- SimInf => Out of scope => Stochastic
- nlmixr2 => Depend on => rxode2
- cOde => Code generation for deSolve, bvpSolve, dMod
- ddesolve => Archived => PBSddesolve
- PBSModeling => Depend on => PBSddesolve
- deTestSet => Archived, non-solver package, but contains test sets for ODE solvers
- Rsundials => Archived
- phaseR => Archived
- RxODE => Archived => rxode2
- odesolve => Archived => deSolve
- odeintr => Archived 2024-02-12
- FME => Depend on => deSolve (Toolbox for parameter estimation, Identifiability, sensitivity analysis, and model selection for ODEs, wraps deSolve)
- adaptivetau - stochastic
- pmxTools => excluded because it provides closed-form analytical PK
calculations for predefined linear compartmental models, not a general ODE solver
- PKADVAN => excluded, not in CRAN, just files on github, provides ADVAN-style analytical solutions
- 