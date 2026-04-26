library(PKPDsim)

rob_model <- new_ode_model(
  code = "
    dAdt[1] = -0.04 * A[1] + 10000 * A[2] * A[3];
    dAdt[2] =  0.04 * A[1] - 10000 * A[2] * A[3] - 30000000 * A[2] * A[2];
    dAdt[3] =  30000000 * A[2] * A[2];
  ",
  dose = list(cmt = 1),
  obs = list(cmt = 1:3)
)

regimen <- new_regimen(
  amt = 1,
  times = 0,
  type = "bolus",
  cmt = 1
)

# solve, not possible because stiff problem
out <- sim(
  ode = rob_model,
  parameters = list(),
  regimen = regimen,
  t_obs = seq(0, 1, by = 1e-6),
  only_obs = TRUE
)

matplot(out$t, out$y, type = "l", lty = 1,
        xlab = "Time", ylab = "Values")
legend("right", legend = c("A", "B", "C"), col = 1:3, lty = 1)
