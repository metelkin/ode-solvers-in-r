library(dMod)
library(magrittr)

reactions <- NULL %>%
  addReaction(
    from = "Alc_g",
    to = "Alc_b_amt",
    rate = "kabs_Alc * Alc_g"
  ) %>%
  addReaction(
    from = "Alc_b_amt",
    to = "",
    rate = "Vmax_ADH * (Alc_b_amt / V_blood) / (Km_ADH + (Alc_b_amt / V_blood)) * V_blood"
  )

ode <- odemodel(reactions)
x <- Xs(ode)

pars <- c(
  Alc_g = 50,
  Alc_b_amt = 0,
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

times <- seq(0, 12, by = 0.001)

out <- x(times, pars)

plot(out[[1]][, "time"], out[[1]][, "Alc_b_amt"], type = "l")
