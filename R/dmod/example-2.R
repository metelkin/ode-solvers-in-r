library(dMod)

ode <- odemodel(
  equations = c(
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

out <- x(times, pars)

out_df <- as.data.frame(out[[1]])

plot(out_df$time, out_df$Alc_b_amt, type="line")

