# https://cran.r-project.org/web/packages/r2sundials/index.html
# https://github.com/sgsokol/r2sundials

library(r2sundials)

rhs <- function(t, y, p, psens) {
  Alc_g <- y[1]
  Alc_b_amt <- y[2]
  
  kabs_Alc <- p[1]
  Vmax_ADH <- p[2]
  Km_ADH <- p[3]
  V_blood <- p[4]
  
  Alc_b <- Alc_b_amt / V_blood
  
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  c(
    -vabs_Alc,
    vabs_Alc - v_ADH
  )
}

pars <- c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

y0 <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

# no events

times <- seq(0, 12, by = 0.001)

out <- r2cvodes(
  y0,
  times,
  rhs,
  param = pars,
  integrator = CV_ADAMS,
  reltol = 1e-8,
  abstol = 1e-8,
  hin = 1e-6
)

out <- data.frame(
  time = times,
  Alc_g = out[1, ],
  Alc_b_amt = out[2, ]
)

out$Alc_b <- out$Alc_b_amt / pars["V_blood"]

plot(out$time, out$Alc_b, type = "l")
