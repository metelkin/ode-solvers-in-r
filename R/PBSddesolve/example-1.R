# https://cran.r-project.org/web/packages/PBSddesolve/
# https://github.com/pbs-software/pbs-ddesolve

require(PBSddesolve)

alc_model <- function(t, y, parms) {
  with(as.list(c(y, parms)), {
    
    # rules
    Alc_b <- Alc_b_amt / V_blood
    vabs_Alc <- kabs_Alc * Alc_g
    v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
    
    # ODEs
    dAlc_g <- -vabs_Alc
    dAlc_b_amt <- vabs_Alc - v_ADH
    
    list(c(dAlc_g, dAlc_b_amt))
  })
}

yinit <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

parms <- c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

times <- seq(0, 12, by = 0.001)

# no events supported

out <- dde(
  y = yinit,
  times = times,
  func = alc_model,
  parms = parms
)

matplot(out[, "time"], out[, c("Alc_g", "Alc_b_amt")],
        type = "l", lty = 1)
legend("topright", legend = c("Alc_g", "Alc_b_amt"), lty = 1)
