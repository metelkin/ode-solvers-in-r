# https://cran.r-project.org/web/packages/deSolve/index.html
# https://github.com/tpetzoldt/deSolve/

require(deSolve)

# load model as R function
alc_model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    
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

state <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

parameters <- c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

# solve
out <- ode(
  times = seq(0, 12, by = 0.001), 
  func = alc_model,
  y = state, 
  parms = parameters, 
  )

plot(out)

