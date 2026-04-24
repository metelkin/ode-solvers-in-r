# https://cran.r-project.org/web/packages/rxode2/index.html
# https://nlmixr2.github.io/rxode2/

library(rxode2)
library(dplyr)

alc_model <- rxode2({
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood

  # ODEs
  d/dt(Alc_g) <- -vabs_Alc
  d/dt(Alc_b_amt) <- vabs_Alc - v_ADH
})

parameters <- c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

state <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

events <- et(timeUnits = "hours") %>%
  et(amt = 50, time = 2, cmt = "Alc_g") %>%
  et(seq(0, 12, by = 0.001))

out <- rxSolve(
  alc_model,
  params = parameters,
  events = events,
  inits = state
)

plot(out)
