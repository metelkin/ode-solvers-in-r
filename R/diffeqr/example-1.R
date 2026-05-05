# https://cran.r-project.org/web/packages/diffeqr/index.html
# https://github.com/SciML/diffeqr

# Julia must be installed: https://julialang.org/downloads/

require(diffeqr)

JuliaCall::julia_install_package_if_needed("DifferentialEquations")
JuliaCall::julia_install_package_if_needed("DiffEqBase")
JuliaCall::julia_install_package_if_needed("DiffEqCallbacks")

JuliaCall::julia_library("DifferentialEquations")
JuliaCall::julia_library("DiffEqBase")
JuliaCall::julia_library("DiffEqCallbacks")

de <- diffeqr::diffeq_setup()

# define model as R function
alc_model <- function(u, p, t) {
  Alc_g <- u[1]
  Alc_b_amt <- u[2]
  
  kabs_Alc <- p[1]
  Vmax_ADH <- p[2]
  Km_ADH <- p[3]
  V_blood <- p[4]
  
  # rules
  Alc_b <- Alc_b_amt / V_blood
  vabs_Alc <- kabs_Alc * Alc_g
  v_ADH <- Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood
  
  # ODEs
  dAlc_g <- -vabs_Alc
  dAlc_b_amt <- vabs_Alc - v_ADH
  
  c(dAlc_g, dAlc_b_amt)
}

# initial state
u0 <- c(50, 0)

# parameters
p <- c(10.0, 3, 0.1, 5.5)

# time span
tspan <- c(0, 12)

# define problem
prob <- de$ODEProblem(alc_model, u0, tspan, p)

# define time event on Julia side
JuliaCall::julia_command("
begin
    import DiffEqCallbacks as DEC

    function dose_affect!(integrator)
        integrator.u[1] += 50.0
    end

    global dose_cb = DEC.PresetTimeCallback([2.0], dose_affect!)
end
")

cb <- JuliaCall::julia_eval("dose_cb")

# solve
sol <- de$solve(
  prob,
  de$Tsit5(),
  saveat = seq(0, 12, by = 0.001),
  callback = cb
)

# convert to data.frame
out <- data.frame(
  time = sol$t,
  t(sapply(sol$u, identity))
)

names(out) <- c("time", "Alc_g", "Alc_b_amt")

# compute derived variable
out$Alc_b <- out$Alc_b_amt / p[4]

# plot
matplot(out$time, out[, c("Alc_g", "Alc_b")], type = "l", lty = 1,
        xlab = "time", ylab = "value")
legend("topright", legend = c("Alc_g", "Alc_b"), lty = 1, col = 1:2)