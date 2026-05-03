library(deSolve)
library(rodeo)

# declarations of state variables
vars <- data.frame(
  name = c("A", "B", "C"),
  unit = c("-", "-", "-"),
  description = c("state A", "state B", "state C"),
  stringsAsFactors = FALSE
)

# parameters
pars <- data.frame(
  name = c("k1", "k2", "k3"),
  unit = c("-", "-", "-"),
  description = c(
    "rate constant 1",
    "rate constant 2",
    "rate constant 3"
  ),
  stringsAsFactors = FALSE
)

# no user-defined helper functions
funs <- data.frame(
  name = character(),
  unit = character(),
  description = character(),
  stringsAsFactors = FALSE
)

# process rates
pros <- data.frame(
  name = c("r1", "r2", "r3"),
  unit = c("-", "-", "-"),
  description = c(
    "A to B",
    "B and C to A",
    "B to C"
  ),
  expression = c(
    "k1 * A",
    "k2 * B * C",
    "k3 * B * B"
  ),
  stringsAsFactors = FALSE
)

# stoichiometry:
# dA = -r1 + r2
# dB =  r1 - r2 - r3
# dC =  r3
stoi <- data.frame(
  variable = c("A", "B", "A", "B", "B", "C"),
  process = c("r1", "r1", "r2", "r2", "r3", "r3"),
  expression = c("-1", "1", "1", "-1", "-1", "1"),
  stringsAsFactors = FALSE
)

# create rodeo model object
model <- rodeo$new(
  vars = vars,
  pars = pars,
  funs = funs,
  pros = pros,
  stoi = stoi,
  dim = c(1)
)

# initial values
model$setVars(c(
  A = 1,
  B = 0,
  C = 0
))

# parameter values
model$setPars(c(
  k1 = 0.04,
  k2 = 10000,
  k3 = 30000000
))

# generate executable R code for deSolve
model$compile(fortran = FALSE)

times <- seq(0, 1, by = 1e-2)

# solve
out <- model$dynamics(
  times = times,
  fortran = FALSE,
  method = "lsoda"
)

out <- as.data.frame(out)

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
