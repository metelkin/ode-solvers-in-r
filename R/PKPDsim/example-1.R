# https://cran.r-project.org/web/packages/PKPDsim/index.html
# https://github.com/InsightRX/PKPDsim

library(PKPDsim)

# load model with DSL ()
alc_model <- new_ode_model(
  code = "
    Alc_b = A[2] / V_blood;
    vabs_Alc = kabs_Alc * A[1];
    v_ADH = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood;

    dAdt[1] = -vabs_Alc;
    dAdt[2] = vabs_Alc - v_ADH;
  ",
  declare_variables = c("Alc_b", "vabs_Alc", "v_ADH"),
  dose = list(cmt = 1),
  obs = list(variable = c("Alc_b"))
)

parameters <- list(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

# first dose only, no second time event
regimen <- new_regimen(
  amt = c(50, 50),
  times = c(0, 2),
  type = "bolus",
  cmt = 1
)

# solve
out <- sim(
  ode = alc_model,
  parameters = parameters,
  regimen = regimen,
  t_obs = seq(0, 12, by = 0.001),
  only_obs = TRUE
)

# plot
plot(out$t, out$y, type = "l", xlab = "Time", ylab = "Alc_b")
