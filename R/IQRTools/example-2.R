library(IQRtools)

model_txt <- "
********** MODEL NAME
Robertson problem

********** MODEL NOTES
Classic stiff ODE system.

********** MODEL STATES
d/dt(state_A) = -k1 * state_A + k2 * state_B * state_C
d/dt(state_B) =  k1 * state_A - k2 * state_B * state_C - k3 * state_B^2
d/dt(state_C) =  k3 * state_B^2

state_A(0) = 1
state_B(0) = 0
state_C(0) = 0

********** MODEL PARAMETERS
k1 = 0.04
k2 = 10000
k3 = 30000000

********** MODEL VARIABLES

********** MODEL REACTIONS

********** MODEL FUNCTIONS

********** MODEL EVENTS
"

model_file <- tempfile(fileext = ".txt")
writeLines(model_txt, model_file)

model <- IQRmodel(model_file)

times <- seq(0, 1, by = 1e-2)

sim_results <- sim_IQRmodel(
  model,
  times
)

out <- as.data.frame(sim_results)

matplot(
  out$TIME,
  out[, c("state_A", "state_B", "state_C")],
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
