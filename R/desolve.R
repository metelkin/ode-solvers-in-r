# https://cran.r-project.org/web/packages/deSolve/index.html
# https://github.com/tpetzoldt/deSolve/

require(deSolve)

alc_model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    
    # rules
    Alc_b <- Alc_b_amt / V_blood
    vabs_Alc <- kabs_Alc * Alc_g
    v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
    
    # ODEs
    dAlc_g <- -vabs_Alc
    dAlc_b_amt <- vabs_Alc - v_ADH
    
    list(c(dAlc_g, dAlc_b_amt), Alc_b = Alc_b)
  })
}

state <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

parameters <- c(
  kabs_Alc = 0.1,
  Vmax_ADH = 0.5,
  Km_ADH = 0.1,
  V_blood = 5.5
)

times <- seq(0, 120, by = 0.01)

out <- ode(y = state, times = times, func = alc_model, parms = parameters)

plot(out)

out_df <- as.data.frame(out)

plot(out_df$time, out_df$Alc_b, type = "l")
