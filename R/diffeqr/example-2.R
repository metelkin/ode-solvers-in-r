library(diffeqr)
JuliaCall::julia_library("DifferentialEquations")
JuliaCall::julia_library("DiffEqBase")

de <- diffeqr::diffeq_setup()

f <- function(u, p, t) {
  c(
    -0.04 * u[1] + 1e4 * u[2] * u[3],
     0.04 * u[1] - 1e4 * u[2] * u[3] - 3e7 * u[2]^2,
     3e7 * u[2]^2
  )
}

u0 <- c(1, 0, 0)
tspan <- c(0, 1)
saveat <- seq(0, 1, by = 1e-2)

prob <- de$ODEProblem(f, u0, tspan)
sol <- de$solve(prob, de$Rodas5(), saveat = saveat, abstol = 1e-8, reltol = 1e-8)

out <- data.frame(
  time = sol$t,
  t(sapply(sol$u, identity))
)
names(out) <- c("time", "A", "B", "C")

matplot(out$time, out[, c("A", "B", "C")], type = "l", lty = 1,
        xlab = "time", ylab = "state")
legend("right", legend = c("A", "B", "C"), lty = 1, col = 1:3)
