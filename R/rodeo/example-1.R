# https://cran.r-project.org/web/packages/rodeo/index.html
# https://github.com/dkneis/rodeo

library(rodeo)

# declarations of state variables
vars <- data.frame(
  name = c("Alc_g", "Alc_b_amt"),
  unit = c("mg", "mg"),
  description = c(
    "amount of alcohol in gut",
    "amount of alcohol in blood"
  ),
  stringsAsFactors = FALSE
)

# declarations of parameters
pars <- data.frame(
  name = c("kabs_Alc", "Vmax_ADH", "Km_ADH", "V_blood"),
  unit = c("1/hour", "mg/hour", "mg/l", "l"),
  description = c(
    "first-order absorption rate",
    "maximum ADH elimination rate",
    "Michaelis-Menten constant",
    "blood volume"
  ),
  stringsAsFactors = FALSE
)

# no user-defined helper functions are needed
funs <- data.frame(
  name = character(),
  unit = character(),
  description = character(),
  stringsAsFactors = FALSE
)

# process rates
pros <- data.frame(
  name = c("absorption", "elimination"),
  unit = c("mg/hour", "mg/hour"),
  description = c(
    "absorption from gut to blood",
    "ADH-mediated elimination from blood"
  ),
  expression = c(
    "kabs_Alc * Alc_g",
    "Vmax_ADH * (Alc_b_amt / V_blood) / (Km_ADH + (Alc_b_amt / V_blood)) * V_blood"
  ),
  stringsAsFactors = FALSE
)

# stoichiometry:
# dAlc_g      = -absorption
# dAlc_b_amt  =  absorption - elimination
stoi <- data.frame(
  variable = c("Alc_g", "Alc_b_amt", "Alc_b_amt"),
  process = c("absorption", "absorption", "elimination"),
  expression = c("-1", "1", "-1"),
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
  Alc_g = 50,
  Alc_b_amt = 0
))

# parameter values
model$setPars(c(
  kabs_Alc = 10.0,
  Vmax_ADH = 3,
  Km_ADH = 0.1,
  V_blood = 5.5
))

# generate executable R code for deSolve
model$compile(fortran = FALSE)

times <- seq(0, 12, by = 0.001)

# time event: add 50 to Alc_g at time = 2
event_table <- data.frame(
  var = "Alc_g",
  time = 2,
  value = 50,
  method = "add"
)

# solve
out <- model$dynamics(
  times = times,
  fortran = FALSE,
  events = list(data = event_table)
)

out <- as.data.frame(out)

# rule/output variable, calculated after integration
out$Alc_b <- out$Alc_b_amt / 5.5

plot(out$time, out$Alc_b, type = "l")
