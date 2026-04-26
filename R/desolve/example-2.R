
require(deSolve)

# load model as R function
rob_model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    # ODEs
    dA <- -0.04 * A + 1e4 * B * C
    dB <- 0.04 * A - 1e4 * B * C - 3e7 * B^2
    dC <- 3e7 * B^2

    list(c(dA, dB, dC))
  })
}

state <- c(
  A = 1,
  B = 0,
  C = 0
)

parameters <- c()

# solve
out <- ode(
  times = seq(0, 1, by = 1e-2), 
  func = rob_model,
  y = state, 
  parms = parameters,
  #method = "rk4" # can select method
  )

plot(out)

