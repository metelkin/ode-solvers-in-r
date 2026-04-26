library(dMod)

# load model with DSL (cOde)
ode <- odemodel(
  f = c(
    A = "-0.04 * A + 1e4 * B * C",
    B = "0.04 * A - 1e4 * B * C - 3e7 * B^2",
    C = "3e7 * B^2"
  )
)

x <- Xs(ode)

pars <- c(
  A = 1,
  B = 0,
  C = 0
)

times <- seq(0, 1, by = 1e-2)

# solve
out <- x(times, pars)
out_df <- as.data.frame(out[[1]])

par(mfrow = c(1, 3))

plot(out_df$time, out_df$A, type = "l", main = "A")
plot(out_df$time, out_df$B, type = "l", main = "B")
plot(out_df$time, out_df$C, type = "l", main = "C")

