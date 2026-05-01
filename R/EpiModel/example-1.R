# https://cran.r-project.org/web/packages/EpiModel/index.html
# https://github.com/EpiModel/EpiModel

library(EpiModel)

alc_model <- function(t, state, parms) {
  with(as.list(c(state, parms)), {
    # rules
    Alc_b <- Alc_b_amt / V_blood
    vabs_Alc <- kabs_Alc * Alc_g
    v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
    
    # ODEs
    dAlc_g <- -vabs_Alc
    dAlc_b_amt <- vabs_Alc - v_ADH
    
    list(c(dAlc_g, dAlc_b_amt), Alc_b = Alc_b) # rule Alc_b to output
  })
}

param <- param.dcm(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

init <- init.dcm(
  Alc_g = 50,
  Alc_b_amt = 0
)

control <- control.dcm(
  type = NULL,
  nsteps = seq(0, 12, by = 0.001),
  odemethod = "lsoda",
  new.mod = alc_model
)

mod <- dcm(param, init, control)

out <- as.data.frame(mod)
plot(out$time, out$Alc_b_amt, type = "l")
