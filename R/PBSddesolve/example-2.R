# https://cran.r-project.org/web/packages/PBSddesolve/index.html
# https://github.com/pbs-software/pbs-ddesolve

require(PBSddesolve)

# load model as R function
rob_model <- function(t, y, parms) {
  with(as.list(y), {
    
    # ODEs
    dA <- -0.04 * A + 1e4 * B * C
    dB <- 0.04 * A - 1e4 * B * C - 3e7 * B^2
    dC <- 3e7 * B^2
    
    c(dA, dB, dC)
  })
}

state <- c(
  A = 1,
  B = 0,
  C = 0
)

# stiff problem , low quality with tol = 1e-3

# solve
out <- dde(
  y = state,
  times = seq(0, 1, by = 1e-2),
  func = rob_model,
  parms = NULL,
  tol = 1e-5,
  dt = 0.001
)

plot(out$time, out$B, type = "l", xlab = "time", ylab = "state")
