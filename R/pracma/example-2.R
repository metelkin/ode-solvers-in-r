library(pracma)

# model as R function
rob_model <- function(t, y) {
  A <- y[1]
  B <- y[2]
  C <- y[3]
  
  # ODEs
  dA <- -0.04 * A + 1e4 * B * C
  dB <- 0.04 * A - 1e4 * B * C - 3e7 * B^2
  dC <- 3e7 * B^2
  
  c(dA, dB, dC)
}

state <- c(1, 0, 0)

# solve with stiff solver
out <- ode23s(
  f = rob_model,
  t0 = 0,
  tfinal = 1,
  y0 = state
)

# to data.frame
out_df <- data.frame(
  time = out$t,
  A = out$y[,1],
  B = out$y[,2],
  C = out$y[,3]
)

# plot
matplot(out_df$time, out_df[, c("A","B","C")],
        type = "l", lty = 1,
        xlab = "Time", ylab = "Concentration")

legend("right", legend = c("A","B","C"), col = 1:3, lty = 1)
