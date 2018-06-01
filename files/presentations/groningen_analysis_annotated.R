##################### Data Preperation ##################################

library(ctsem)

# Data is available from https://osf.io/c6xt4/download #
# Folder is ESMdata.zip
setwd("./ESMdata")

#Load Data#
rawdata<-read.csv("ESMdata.csv",header=TRUE, stringsAsFactors = FALSE)

#Select only measruements which take place in the control and initial (no medication reduciton) phase
rawdata<-subset(rawdata,rawdata$phase==1|rawdata$phase==2)

#Select only the variables of interest
sel<-c("mood_down","phy_tired")
data<-rawdata[,(names(rawdata) %in% sel)]

# Standardise the selected variables
for(j in 1:dim(data)[2]){
  data[,j]<-(data[,j]-mean(data[,j]))/sd(data[,j])
}

# Create a time vector which represents hours since first measurement
# This is the 'absolute time measurements' required by ctsem function ctIntervalise
t1<-as.POSIXct(paste(rawdata$date,rawdata$resptime_s),format="%d/%m/%y %H:%M:%S")
time<-as.numeric(difftime(t1,t1[1], units="hours"))

# Attach this time variable to the selected items
data$time=time

# Create an ID variable
data$id=rep(1,dim(data)[1])

# Rename mood_down = Y1, and phy_tired= Y2 for use with ctsem
colnames(data)=c("Y1","Y2","time","id")
# Get data in wide format for ctsem
datawide<-ctLongToWide(datalong=data,id="id",time="time",manifestNames=c("Y1","Y2"))

# Create time-interval variable
datawide<-ctIntervalise(datawide=datawide,Tpoints=dim(data)[1],
                        n.manifest=2,manifestNames=c("Y1","Y2"))

##################### Data analysis #####################################

# First specify the bivariate model, with 2 observed variables 

# Note - as in many SEM software packages, I must load all observed variables onto latent variables
model <- ctModel(n.manifest = 2, #Two observed variables
                 n.latent= 2, # Two Latent variables
                 LAMBDA = diag(nrow=2), # Obs. variables have loadings=1 onto latent variables
                 Tpoints = 286, 
                 MANIFESTMEANS = matrix(data=0, nrow=2, ncol=1), # Means of the observed variables are 0s 
                 MANIFESTVAR = matrix(data=0, nrow=2, ncol=2), # Obs. variables have no measurement error
                 DRIFT = "auto", # Freely estimate all parameters in the drift  (regression coefficients in diff equation )
                 CINT = matrix(data=0, nrow=2, ncol=1), # Latent intercepts also 0s - I pre-standardised
                 DIFFUSION = "auto", # Freely estimate all dynamic error variances and covariances
                 TRAITVAR = NULL, # Random intercept of the latent variable - Multilevel option
                 MANIFESTTRAITVAR = NULL, # Random intercept of the observed variable - Multilevel option
                 startValues = NULL)  #Starting values in estimation - can improve model fit, but will automatically generate

# if we wish to estimate, for example, only the autoregressive effects in the drift matrix, we can specify this as 
# ctModel(..., DRIFT=matrix(c("drift11",0,0,"drift22"),2,2,byrow=TRUE))

# Fit the model to the data using carefulFit to get initial values
fit <- ctFit(dat=datawide, 
             ctmodelobj = model,
              objective = "Kalman", # The automatic option for single-subject data
              stationary = c("T0VAR", "T0MEANS"), # Assume a stationary process and random first measurement (not predetermined)
             carefulFit = T, # Helps convergence - first fits a simplified model to obtain good starting values 
             iterationSummary = T, # Gives details after every fit attempt
             showInits = F,# Don't show me initial values for the parameters
             asymptotes = F, # If TRUE, model simplification that helpls with fit
             meanIntervals = F, # Option for if you have multiple subjects and their intervals differ
             plotOptimization = F, # Plot iteration history for each parameter
             discreteTime = F, #If TRUE, estimate a discrete time model ONLY
             verbose = 0) # To do with optimization details which are printed

results<-summary(fit)

setwd("C:/Users/F111848/Dropbox/CT Book chapter/Empirical Example/Analysis")
save(results,file="results.RData")


## Extra analysis
ctCI(fit, confidenceintervals = 'DRIFT') # May only work with objective = mxRAM in the ctFit() function

