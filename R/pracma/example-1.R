# https://cran.r-project.org/web/packages/pracma/index.html
# https://github.com/cran/pracma

library(pracma)

# load model as R function
alc_model <- function(t, y) {
  Alc_g <- y[1]
  Alc_b_amt <- y[2]
  
  # parameters
  kabs_Alc <- 10.0
  Vmax_ADH <- 3
  Km_ADH <- 0.1
  V_blood <- 5.5
  
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  # ODEs
  dAlc_g <- -vabs_Alc
  dAlc_b_amt <- vabs_Alc - v_ADH
  
  c(dAlc_g, dAlc_b_amt)
}

state <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

# no time event

# solve
out <- ode45(
  f = alc_model,
  t0 = 0,
  tfinal = 12,
  y0 = state
)

# convert to data.frame
out_df <- data.frame(
  time = out$t,
  Alc_g = out$y[, 1],
  Alc_b_amt = out$y[, 2]
)

plot(out_df$time, out_df$Alc_b_amt, type = "l")
