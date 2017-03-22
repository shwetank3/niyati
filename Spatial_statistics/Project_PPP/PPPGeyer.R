dataset_process <- dataset_output_total_csv
######## Basic Processing
data<-dataset_process[!is.na(dataset_process$Northing),]   #Remove NA       
View(data)

provider <- data[data$Operator=='Orange',]
filtered.data <- provider[grep("ST",provider$Site.NGR),]
coord.filtered.data <- cbind(filtered.data$Easting,filtered.data$Northing)
plot(coord.filtered.data)
nrow(coord.filtered.data)

###### Create ppp object
coord.df<-as.data.frame(coord.filtered.data)
mod.coord.df<- coord.df
mod.coord.df$V1 <-  (coord.df$V1-min(coord.df$V1))/(max(coord.df$V1)-min(coord.df$V1))
mod.coord.df$V2 <-  (coord.df$V2-min(coord.df$V2))/(max(coord.df$V2)-min(coord.df$V2))
library(spatstat)
Wndw <- owin(c(0,1),c(0,1))
data.ppp <- as.ppp(unique(mod.coord.df),W=Wndw, check = TRUE)
par(mfrow = c(1,2))
# plot geyer model:

par(mfrow = c(1,2))
plot(mod.coord.df,xlim=c(0,1),ylim=c(0,1),asp=1,xlab = "X",ylab = "Y")
fit<-ppm(data.ppp,~1,Geyer(r=0.03,sat=15))
sim.geyer <-simulate(fit,w=Wndw)
simul.geyer.df <- as.data.frame(sim.geyer$`Simulation 1`)
plot(simul.geyer.df,main = "",asp=1,xlab = 'X',ylab = 'Y')
########################
myVoronoidist <- function(X,r,...){
  y <- dirichlet(X)
  fnobject <- Kest(X)
  cdf <- ecdf(tile.areas(y))
  xval <- r#seq(0,0.1,length.out = length(fnobject$r))
  yval <- cdf(xval)
  data <-  cbind(xval,yval)
  data_obj<- as.fv(data)
  return(data_obj)
}

y <- dirichlet(data.ppp) # Dirichlet tesselation
plot(y) # Plot tesselation
plot(X, add = TRUE) # Add points
tile.areas(y) #Areas
cdf <- ecdf(tile.areas(y))

plot(cdf)
a=envelope(fit,fun = myVoronoidist,nsim=100,nrank=1,seq(0,2.5e+08,1e+07))
plot(a,add=TRUE)
plot(cdf,add=TRUE)


fit2<-ppm(data.ppp,~1,Poisson())
b=envelope(fit2,fun = myVoronoidist,nsim=100,nrank=1,seq(0,2.5e+08,1e+07))
plot(b)
plot(cdf,add = TRUE)

##### computing K function of the fit and data ######
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit,fun = Kest,nsim=n,rank=(p * (n + 1)))
plot(c)
plot(Kest(data.ppp),add =TRUE)

##### computing F function of the fit and data ######
plot(Fest(data.ppp))
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit,fun = Fest,nsim=n,rank=(p * (n + 1)))
plot(c)
plot(Fest(data.ppp),add =TRUE)
