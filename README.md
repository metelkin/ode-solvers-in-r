# ode-solvers-in-r
Repository for testing ODE solvers in R


## Properties of the ODE solvers

- DAE
- Algorithms
- Stiffness
- Events
- Delay
- Format of the ODE system


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

## Summary

| Package | Engine | DAE | Algorithms | Stiffness | TimeEvent | CEvent | Delay | Format of the ODE system |
|---------|-------|-----|------------|-----------|--------|-------|-------|-------------------------|
| deSolve  | ODEPACK (Fortran) | Yes (limited) | lsoda, lsode, lsodes, lsodar, vode, daspk, radau, bdf, adams | Yes | Yes | Yes | Yes (limited) | R func / C / C++ / Fortran |
