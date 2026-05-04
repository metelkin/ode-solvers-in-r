# https://iqrtools.intiquan.com/

library(IQRtools)

# define model in IQRTools text format
model_txt <- "
********** MODEL NAME
Alcohol PK model

********** MODEL NOTES
PK model with nonlinear Michaelis-Menten elimination.

********** MODEL STATES
d/dt(Alc_g)     = -vabs_Alc + INPUT1
d/dt(Alc_b_amt) =  vabs_Alc - v_ADH

Alc_g(0)     = 50
Alc_b_amt(0) = 0

********** MODEL PARAMETERS
kabs_Alc = 10.0
Vmax_ADH = 3
Km_ADH   = 0.1
V_blood  = 5.5

********** MODEL VARIABLES
Alc_b    = Alc_b_amt / V_blood
vabs_Alc = kabs_Alc * Alc_g
v_ADH    = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * V_blood

********** MODEL REACTIONS

********** MODEL FUNCTIONS

********** MODEL EVENTS
"

# write model to a temporary text file
model_file <- tempfile(fileext = ".txt")
writeLines(model_txt, model_file)

# load model
model <- IQRmodel(model_file)

# time event: add 50 to Alc_g at time = 2
dosing <- IQRdosing(
  TIME = 2,
  ADM  = 1,
  AMT  = 50
)

# solve
sim_results <- sim_IQRmodel(
  model,
  12,
  dosingTable = dosing
)

# inspect names if needed
# names(sim_results)
# head(sim_results)

plot(sim_results)
