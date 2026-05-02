# ode-solvers-in-r

This repository contains **minimal, reproducible examples** for solving ODE systems using different R packages.

It accompanies the article:

👉 **[Landscape of ODE Solvers in R (2025)](https://metelkin.me/landscape-of-ode-solvers-in-r/)**

## Structure

All implementations are located in the [`/R/`](./R) directory.

Each subfolder corresponds to a specific package and contains code for running the same test models.

## Test cases

Two simple models are used to ensure consistency across packages:

### Example 1: PK with MM elimination

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

For the packages without build-in time events, the event is skipped.

### Example 2: Robertson problem stiff ODE

```[ode]
A ~ -0.04 * A + 1e4 * B * C
B ~ 0.04 * A - 1e4 * B * C - 3e7 * B^2
C ~ 3e7 * B^2
[initial]
A = 1;
B = 0;
C = 0;
```

These examples are intentionally minimal and are designed to:

- verify that each package works in practice  
- provide a starting point for comparison  
- illustrate differences in model definition and execution

## Purpose

This repository is not a benchmark.

Its goal is to provide a **practical reference** showing how different ODE tools in R can be used on the same problems.

## Notes

- Implementations are kept simple and comparable
- Package-specific features are not explored in depth  
- Some tools rely on underlying solvers (e.g., `deSolve`) or external ecosystems  

## Packages covered

See the article for a full overview and comparison table.

---

## License

MIT License. See [LICENSE](./LICENSE) for details.