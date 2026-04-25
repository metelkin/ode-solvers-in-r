# ode-solvers-in-r
Repository for testing ODE solvers in R

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
- PKPDsim
- SimInf
- EpiModel => deSolve
- PBSddesolve
- deTestSet
- reticulate + SciPy => Python
- rstan / Stan
- phaseR
- sundialr
- cvodes
- odeintr
- FME => Depend on => deSolve
- EpiModel => Depend on => deSolve
- adaptivetau - stochastic
- pmxTools
- PKADVAN
- r2sundials 
- rodeo 
- bvpSolve
- diffeqr / JuliaCall => Julia

### enterprise ecosystem

- RsNLME - Certara
- RDarwin - Certara
- IQRTools
- mlxR - Monolix / Lixoft

### removed

- nlmixr2 => Depend on => rxode2
- cOde => Code generation for deSolve, bvpSolve, dMod

## Classification

By the way of defining the ODE system:

1. Function-based (ручное задание ODE)
2. DSL-based (декларативное описание)
3. Framework-based (модель как объект / проект)

By the way of solving:

1. Packages with bundled/native solvers
2. Packages built on top of other R packages
3. Interfaces to external ecosystems

## Example 1: PK with MM elimination

```
[ode]
Alc_g ~ - vabs_Alc;
Alc_b_amt ~ vabs_Alc - v_ADH;
[rules]
Alc_b = Alc_b_amt / V_blood;
vabs_Alc = kabs_Alc * Alc_g;
v_ADH = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * blood;
[initial]
Alc_g = 50;
Alc_b_amt = 0;
[parameters]
kabs_Alc = 0.1;
Vmax_ADH = 0.5;
Km_ADH = 0.1;
V_blood = 5.5;
[events]
Alc_g [time >= 2] = Alc_g + 50;
```

## Example 2: Robertson problem stiff ODE

```[ode]
A ~ -0.04 * A + 1e4 * B * C
B ~ 0.04 * A - 1e4 * B * C - 3e7 * B^2
C ~ 3e7 * B^2
[initial]
A = 1;
B = 0;
C = 0;
```
