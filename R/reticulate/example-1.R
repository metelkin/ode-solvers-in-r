# https://cran.r-project.org/web/packages/reticulate/index.html
# https://github.com/rstudio/reticulate

# Python >= 2.7 must be installed

library(reticulate)
#py_path <- normalizePath(Sys.which("python"))
#use_python(py_path, required = TRUE)
py_config()

# use python scipy
#reticulate::py_install(c("numpy", "scipy"), pip = TRUE)
scipy <- reticulate::import("scipy.integrate")

# define model
alc_model <- function(t, y) {
  Alc_g <- y[1]
  Alc_b_amt <- y[2]
  
  kabs_Alc <- 10.0
  Vmax_ADH <- 3
  Km_ADH <- 0.1
  V_blood <- 5.5
  
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  # ODEs
  dAlc_g <- -vabs_Alc
  dAlc_b_amt <- vabs_Alc - v_ADH
  
  list(c(dAlc_g, dAlc_b_amt))
}

# initial state
y0 <- c(50, 0)

# solve
sol <- scipy$solve_ivp(
  alc_model,
  c(0, 12),
  y0,
  t_eval = seq(0, 12, by = 0.001)
)

# extract
time <- sol$t
Alc_g <- sol$y[1, ]
Alc_b_amt <- sol$y[2, ]
Alc_b <- Alc_b_amt / 5.5

# plot
matplot(time, cbind(Alc_g, Alc_b), type = "l", lty = 1,
        xlab = "time", ylab = "value")
legend("topright", legend = c("Alc_g", "Alc_b"), lty = 1, col = 1:2)
