# https://cran.r-project.org/web/packages/sundialr/index.html
# https://github.com/sn248/sundialr

require(sundialr)

# load model as R function
alc_model <- function(t, y, p) {
  
  # states
  Alc_g <- y[1]
  Alc_b_amt <- y[2]
  
  # parameters
  kabs_Alc <- p[1]
  Vmax_ADH <- p[2]
  Km_ADH <- p[3]
  V_blood <- p[4]
  
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  # ODEs
  dAlc_g <- -vabs_Alc
  dAlc_b_amt <- vabs_Alc - v_ADH
  
  c(dAlc_g, dAlc_b_amt)
}

# time vector
time_vec <- seq(0, 12, by = 0.001)

# initial conditions
IC <- c(
  Alc_g = 50,
  Alc_b_amt = 0
)

# parameters
params <- c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
)

# tolerances
reltol <- 1e-6
abstol <- c(1e-8, 1e-8)

# event: add 50 to state 1 (Alc_g) at time 2
EVENTS <- data.frame(
  ID = 1,
  TIMES = 2,
  VAL = 50
)

# solve
out <- cvsolve(time_vec, IC, alc_model, params, EVENTS, reltol, abstol)

# output is a matrix: first column is time
out <- as.data.frame(out)
names(out) <- c("time", names(IC))

# calculate additional output manually
out$Alc_b <- out$Alc_b_amt / params["V_blood"]

# plot
plot(out$time, out$Alc_b_amt, type = "l",
     xlab = "time", ylab = "state")
lines(out$time, out$Alc_g, lty = 2)
legend("topright", legend = c("Alc_b_amt", "Alc_g"), lty = c(1, 2))
