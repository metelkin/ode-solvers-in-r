library(r2sundials)

# load model as R function
rob_model <- function(t, y, p, psens) {
  A <- y[1]
  B <- y[2]
  C <- y[3]
  
  dA <- -0.04 * A + 1e4 * B * C
  dB <-  0.04 * A - 1e4 * B * C - 3e7 * B^2
  dC <-  3e7 * B^2
  
  c(dA, dB, dC)
}

state <- c(
  A = 1,
  B = 0,
  C = 0
)

parameters <- c()

times <- seq(0, 1, by = 1e-2)

# solve
out <- r2cvodes(
  state,
  times,
  rob_model,
  param = parameters,
  integrator = CV_BDF,
  reltol = 1e-8,
  abstol = 1e-10,
  hin = 1e-8
)

out <- data.frame(
  time = times,
  A = out[1, ],
  B = out[2, ],
  C = out[3, ]
)

matplot(
  out$time,
  out[, c("A", "B", "C")],
  type = "l",
  lty = 1,
  xlab = "time",
  ylab = "state"
)

legend(
  "right",
  legend = c("A", "B", "C"),
  lty = 1
)
