library(odin)

# load model as DSL (R-like, compiled to C)
rob_generator <- odin::odin({
  # ODEs
  deriv(A) <- -0.04 * A + 1e4 * B * C
  deriv(B) <-  0.04 * A - 1e4 * B * C - 3e7 * B^2
  deriv(C) <-  3e7 * B^2
  
  # initial conditions
  initial(A) <- 1
  initial(B) <- 0
  initial(C) <- 0
})

# create model instance
rob_model <- rob_generator$new()

# solve
times <- seq(0, 1, by = 1e-2)
out <- rob_model$run(times)

# convert to data.frame
out_df <- as.data.frame(out)

# plot
matplot(out_df$t, out_df[, c("A", "B", "C")],
        type = "l", lty = 1,
        xlab = "Time", ylab = "Values")

legend("right", legend = c("A", "B", "C"), col = 1:3, lty = 1)
