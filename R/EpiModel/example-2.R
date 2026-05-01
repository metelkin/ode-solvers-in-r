library(EpiModel)

# model as R function
rob_model <- function(t, state, parms) {
  with(as.list(c(state, parms)), {
    
    # ODEs
    dA <- -0.04 * A + 1e4 * B * C
    dB <- 0.04 * A - 1e4 * B * C - 3e7 * B^2
    dC <- 3e7 * B^2
    
    list(c(dA, dB, dC))
  })
}

# parameters (fake)
param <- param.dcm(k1=0.1)

# initial state
init <- init.dcm(
  A = 1,
  B = 0,
  C = 0
)

# control settings
control <- control.dcm(
  type = NULL,
  nsteps = seq(0, 1, by = 1e-2),
  odemethod = "lsoda",   # important for stiff system
  new.mod = rob_model
)

# solve
mod <- dcm(param, init, control)

out <- as.data.frame(mod)

# plot
matplot(out$time, out[, c("A", "B", "C")], type = "l", lty = 1)
legend("right", legend = c("A", "B", "C"), col = 1:3, lty = 1)