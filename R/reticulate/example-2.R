library(reticulate)

scipy <- import("scipy.integrate")

# define model
rob_model <- function(t, y) {
  y <- as.numeric(y)
  
  A <- y[1]
  B <- y[2]
  C <- y[3]
  
  # ODEs
  dA <- -0.04 * A + 1e4 * B * C
  dB <-  0.04 * A - 1e4 * B * C - 3e7 * B^2
  dC <-  3e7 * B^2
  
  c(dA, dB, dC)
}

# initial state
y0 <- c(1, 0, 0)

# solve
sol <- scipy$solve_ivp(
  rob_model,
  c(0, 1),
  y0,
  method = "BDF",
  t_eval = seq(0, 1, by = 1e-2)
)

# extract
time <- sol$t
A <- sol$y[1, ]
B <- sol$y[2, ]
C <- sol$y[3, ]

# plot
matplot(time, cbind(A, B, C), type = "l", lty = 1,
        xlab = "time", ylab = "state")
legend("right", legend = c("A", "B", "C"), lty = 1, col = 1:3)
