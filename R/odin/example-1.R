# https://cran.r-project.org/web/packages/odin/index.html
# https://github.com/mrc-ide/odin

library(odin)

# load model in DSL (odin)
alc_generator <- odin::odin({
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  # ODEs
  deriv(Alc_g) <- -vabs_Alc
  deriv(Alc_b_amt) <- vabs_Alc - v_ADH
  
  # initial conditions
  initial(Alc_g) <- 50
  initial(Alc_b_amt) <- 0
  
  # parameters
  kabs_Alc <- 10.0
  Vmax_ADH <- 3
  Km_ADH <- 0.1
  V_blood <- 5.5
  
  # output
  output(Alc_b) <- Alc_b
})

# create model instance
alc_model <- alc_generator$new()

# solve
times <- seq(0, 12, by = 0.001)
out <- alc_model$run(times)

# convert to data.frame
out_df <- as.data.frame(out)

# plot concentration
plot(out_df$t, out_df$Alc_b, type = "l")
