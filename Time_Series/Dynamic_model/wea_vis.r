setwd("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66")
library(readxl)
Speed <- read_excel("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66/Speed.xlsx", 
                    col_names = FALSE)
Speed_29 <- read_csv("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66/Speed_29.csv", 
                     col_names = FALSE)
Speed_31 <- read_csv("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66/Speed_31.csv", 
                     col_names = FALSE)
Visibility <- read_excel("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66/Visibility.xlsx", 
                         col_names = FALSE)
Weather <- read_excel("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/I66/Weather.xlsx", 
                      col_names = FALSE)

#############################
#Taking Month 9 - September
# For Segment 30
#############################
require(dlm)
library(dlm)

################################################################
########## weather AND visibility AS REGRESSOR #################
################################################################
# Forecast for one day i.e 28th day using 27th day = 27*96 = 2592
Forecast = {}
Speed.actual = t(Speed)
speed.ts = ts(Speed.actual)
### Regressors
visibility <- t(Visibility)
weather <- t(Weather)
weather[1:3]<- 1
wea = vector()
for (i in 1:length(weather)){
  if (weather[i]==1) {wea = rbind(wea,cbind(0,0,0))}
  if (weather[i]==2) {wea = rbind(wea,cbind(1,0,0))}
  if (weather[i]==3) {wea = rbind(wea,cbind(0,1,0))}
  if (weather[i]==4) {wea = rbind(wea,cbind(0,0,1))}
}
### Initial Estimation
X = ts(cbind(wea,visibility))

build.reg <- function(parm) {
  dlmModReg(X)
}

speed.reg.mle.fit <- dlmMLE(speed.ts,rep(0,3),build.reg)
speed.reg.mle.fit$convergence

#### Iteration Starts
for(i in 1:96){
  # Chosing initial values
  wea.it = wea[-((2592+i):2688),]
  vis.it = visibility[-((2592+i):2688)]
  speed = t(Speed[-((2592+i):2688)])
  
  #Converting it into Time-Series
  speed.ts = ts(speed)
  X = ts(cbind(wea.it,vis.it))
  
  speed.reg.mod <- build.reg(speed.reg.mle.fit$par)
  speed.reg.ts.filt <- dlmFilter(speed.ts, speed.reg.mod)
  #speed.reg.ts.smooth <- dlmSmooth(speed.reg.ts.filt)
  
  coeff.speed<- cbind(speed.reg.ts.filt$a[,1],speed.reg.ts.filt$a[,2],speed.reg.ts.filt$a[,3],speed.reg.ts.filt$a[,4],speed.reg.ts.filt$a[,5])
  pred.coeff <- coeff.speed[2591+i,]
  pred.reg.vec <- cbind(1,wea[2592+i,1],wea[2592+i,2],wea[2592+i,3],visibility[2592+i])
  pred.speed <- rowSums(pred.coeff*pred.reg.vec)
  Forecast = rbind(Forecast,c(pred.speed,Speed.actual[2592+i]))
}
f = ts(Forecast)
plot(f[,2], xlab = "Time/(15 min)", ylab = "Speed Comparison", col = "darkgrey",ylim = range(10:70))
lines(f[,1], col="red", lty = "longdash")
legend(0,30,c('Actual','Predicted'),lty=c(1,1),lwd=c(2.5,2.5),col=c('darkgrey','red'))

####################################################
# One-step ahead forecast error for the last 1 day #
####################################################

# Mean absolute forecast error (MAE)
mean(abs(Forecast[,1] - Forecast[,2]))
# Mean squared forecast error (MSE)
mean((Forecast[,1] - Forecast[,2])^2)
# Mean absolute percentage forecast error (MAPE)
mean(abs(Forecast[,1] - Forecast[,2]) / Forecast[,2])
