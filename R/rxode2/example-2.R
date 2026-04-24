library(rxode2)

rob_model <- rxode2({
  d/dt(A) <- -0.04 * A + 1e4 * B * C
  d/dt(B) <-  0.04 * A - 1e4 * B * C - 3e7 * B^2
  d/dt(C) <-  3e7 * B^2
})

state <- c(
  A = 1,
  B = 0,
  C = 0
)

parameters <- c()

times <- et(seq(0, 1, by = 1e-2))

out <- rxSolve(
  rob_model,
  params = parameters,
  inits = state,
  events = times
)

plot(out)
