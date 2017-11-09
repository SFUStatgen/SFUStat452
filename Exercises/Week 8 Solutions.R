#Import Data
Diab <- read.csv("Data/pima-diabetes.csv")
head(Diab,n=3)
summary(Diab)

#Remove "missing" values
Diab$Glucose[Diab$Glucose==0] = NA
Diab$BloodPressure[Diab$BloodPressure==0] = NA
Diab$BMI[Diab$BMI==0] = NA
Diab$SkinThickness[Diab$SkinThickness==0] = NA
Diab = na.omit(Diab)

#Remove Outcome
Diab$Outcome = NULL

#Extract predictors and response
X = Diab[,-2]
Y = Diab[,2]

#Compute the mean and variance of each predictor
means = lapply(X, mean)
sds = lapply(X, sd)

#Compute principal components of the predictors
PCA = prcomp(X)

#Compute principal components of the standardized predictors
PCA.stand = prcomp(X, center=TRUE, scale=TRUE)

#Plot both PCAs
plot(PCA)
plot(PCA.stand)

#Center and scale the predictors
X.stand = (X - means)/sds
data = cbind(Y, X.stand)
colnames(data)[1] = "Glucose"

#Comfirm that we standardized correctly
lapply(X.stand, mean)
lapply(X.stand, sd)

##########################################
### Fit a PCR model to predict Glucose ###
##########################################
library(pls)
set.seed(1122)

fit = pcr(Glucose ~ . , data=data, validation="CV")
summary(fit)
plot(fit)
