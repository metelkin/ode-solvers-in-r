library(mrgsolve)
library(magrittr)

# load model as DLS (C++ like)
mod <- mcode("rob_model", '
$CMT
A B C

$ODE
dxdt_A = -0.04 * A + 1e4 * B * C;
dxdt_B =  0.04 * A - 1e4 * B * C - 3e7 * pow(B, 2);
dxdt_C =  3e7 * pow(B, 2);
')

# solve
out <- mod %>%
  init(A = 1, B = 0, C = 0) %>%
  mrgsim(start = 0, end = 1, delta = 1e-2)

plot(out)
