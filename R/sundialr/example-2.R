library(sundialr)

# RHS function
rob_model <- function(t, y, p) {
  
  # states
  A <- y[1]
  B <- y[2]
  C <- y[3]
  
  # ODEs
  dA <- -0.04 * A + 1e4 * B * C
  dB <- 0.04 * A - 1e4 * B * C - 3e7 * B^2
  dC <- 3e7 * B^2
  
  c(dA, dB, dC)
}

# time vector
time_vec <- seq(0, 1, by = 1e-2)

# initial conditions
IC <- c(
  A = 1,
  B = 0,
  C = 0
)

# parameters (empty but must exist)
params <- numeric(0)

# tolerances (важно для stiff системы)
reltol <- 1e-6
abstol <- c(1e-8, 1e-14, 1e-6)

# solve
out <- cvode(time_vec, IC, rob_model, params, reltol, abstol)

# format output
out <- as.data.frame(out)
names(out) <- c("time", "A", "B", "C")

# plot
matplot(out$time, out[, c("A", "B", "C")],
        type = "l", lty = 1,
        xlab = "time", ylab = "state")

legend("right", legend = c("A", "B", "C"), lty = 1)
