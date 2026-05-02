# https://cran.r-project.org/web/packages/rstan/index.html
# https://github.com/stan-dev/rstan

library(rstan)

stan_code <- '
functions {
  vector alc_model(real t, vector y,
                   real kabs_Alc,
                   real Vmax_ADH,
                   real Km_ADH,
                   real V_blood) {
    vector[2] dydt;

    real Alc_g = y[1];
    real Alc_b_amt = y[2];

    real Alc_b = Alc_b_amt / V_blood;
    real vabs_Alc = kabs_Alc * Alc_g;
    real v_ADH = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood;

    dydt[1] = -vabs_Alc;
    dydt[2] =  vabs_Alc - v_ADH;

    return dydt;
  }
}

data {
  int<lower=1> nt;
  vector[2] y0;
  real t0;
  array[nt] real times;

  real kabs_Alc;
  real Vmax_ADH;
  real Km_ADH;
  real V_blood;
}

model {
  // no statistical model; simulation only
}

generated quantities {
  array[nt] vector[2] y_hat;
  vector[nt] Alc_b;

  y_hat = ode_rk45(
    alc_model,
    y0,
    t0,
    times,
    kabs_Alc,
    Vmax_ADH,
    Km_ADH,
    V_blood
  );

  for (i in 1:nt) {
    Alc_b[i] = y_hat[i, 2] / V_blood;
  }
}
'

times_all <- seq(0, 12, by = 0.001)
times <- times_all[times_all > 0]

y0 <- c(50, 0)

data <- list(
  nt = length(times),
  y0 = y0,
  t0 = 0,
  times = times,
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
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
  Alc_g = c(y0[1], as.vector(sim$y_hat[1, , 1])),
  Alc_b_amt = c(y0[2], as.vector(sim$y_hat[1, , 2]))
)

out$Alc_b <- out$Alc_b_amt / data$V_blood

plot(out$time, out$Alc_b, type = "l")
