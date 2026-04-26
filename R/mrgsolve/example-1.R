# https://cran.r-project.org/web/packages/mrgsolve/index.html
# https://github.com/metrumresearchgroup/mrgsolve

library(mrgsolve)
library(magrittr)

# load model as DLS (C++ like)
code <- '
$PARAM
kabs_Alc = 10.0
Vmax_ADH = 3
Km_ADH = 0.1
V_blood = 5.5

$CMT
Alc_g Alc_b_amt

$ODE
double Alc_b = Alc_b_amt / V_blood;
double vabs_Alc = kabs_Alc * Alc_g;
double v_ADH = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood;

dxdt_Alc_g = -vabs_Alc;
dxdt_Alc_b_amt = vabs_Alc - v_ADH;

$TABLE
capture Alc_b;
'

mod <- mcode("alc_model", code)

# time event
ev1 <- ev(
  time = 2,
  amt = 50,
  cmt = "Alc_g"
)

# solve
out <- mod %>%
  init(Alc_g = 50, Alc_b_amt = 0) %>%
  ev(ev1) %>%
  mrgsim(start = 0, end = 12, delta = 0.001)

plot(out)
