
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
+ RxODE => Archived => rxode2
+ rxode2
+ mrgsolve
+ odesolve => Archived => deSolve
+ dMod => Depend on => deSolve
+ pracma
+ odin
+ PKPDsim
+ EpiModel => deSolve (Epidemiological models, same format as deSolve but restricted, Framework with different methods)
+ PBSddesolve (implemented algorithm for DDE solv95, R function format, connected to PBSModeling toolbox)
+ sundialr (r interface to Sundials)
+ r2sundials 
- rstan / Stan
- phaseR
- cvodes
- odeintr
- FME => Depend on => deSolve
- adaptivetau - stochastic
- pmxTools
- PKADVAN
- rodeo 
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