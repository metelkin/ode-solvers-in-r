library(rstan)

stan_code <- '
functions {
  vector rob_model(real t, vector y) {
    vector[3] dydt;

    real A = y[1];
    real B = y[2];
    real C = y[3];

    dydt[1] = -0.04 * A + 1e4 * B * C;
    dydt[2] =  0.04 * A - 1e4 * B * C - 3e7 * square(B);
    dydt[3] =  3e7 * square(B);

    return dydt;
  }
}

data {
  int<lower=1> nt;
  vector[3] y0;
  real t0;
  array[nt] real times;
}

model {
  // no statistical model; simulation only
}

generated quantities {
  array[nt] vector[3] y_hat;

  y_hat = ode_bdf(
    rob_model,
    y0,
    t0,
    times
  );
}
'

times_all <- seq(0, 1, by = 1e-2)
times <- times_all[times_all > 0]

y0 <- c(1, 0, 0)

data <- list(
  nt = length(times),
  y0 = y0,
  t0 = 0,
  times = times
)

fit <- stan(
  model_code = stan_code,
  data = data,
  chains = 1,
  iter = 1,
  warmup = 0,
  algorithm = "Fixed_param",
  seed = 1
)

sim <- rstan::extract(fit)

out <- data.frame(
  time = c(0, times),
  A = c(y0[1], as.vector(sim$y_hat[1, , 1])),
  B = c(y0[2], as.vector(sim$y_hat[1, , 2])),
  C = c(y0[3], as.vector(sim$y_hat[1, , 3]))
)

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