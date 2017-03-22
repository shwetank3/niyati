dataset_process <- dataset_output_total_csv
######## Basic Processing
data<-dataset_process[!is.na(dataset_process$Northing),]   #Remove NA       data[-1,-2]
View(data)

provider <- data[data$Operator=='Airwave',]
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
########################
# fitting a strauss model
fit.strauss<-ppm(data.ppp,~1,Strauss(r=0.2))
# plot original data in modified coordinate
par(fig=c(0,1,0,1))
plot(mod.coord.df,xlim=c(0,1),ylim=c(0,1),asp=1,xlab = "X",ylab = "Y")
# simulation of model
sim.strauss <-simulate(fit.strauss,w=Wndw)
# plot fitted pattern
simul.strauss.df <- as.data.frame(sim.strauss$`Simulation 1`)
plot(simul.strauss.df,main = "",asp=1,xlab = 'X',ylab = 'Y')
########################
# fitting a PPP 
fit.ppp<-ppm(data.ppp,~1,Poisson())
sim.ppp <-simulate(fit.ppp,w=Wndw)
# plot fitted pattern
simul.ppp.df <- as.data.frame(sim.ppp$`Simulation 1`)
plot(simul.ppp.df,main = "",asp=1,xlab = 'X',ylab = 'Y')
#######################################################
## comparison of summary statistics ##
## Kest ###
K <- Kest(data.ppp,correction = c("Ripley"))
plot(K, main="",legend = FALSE)
v <- plot(K, . ~ r, ylab="K(r)",legend = FALSE,main="")
legend(0,0.2,c(K$iso,K$theo),lty = c(2,1),legend=row.names(v), col=v$col)
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit.strauss,fun = Kest,nsim=n,rank=(p * (n + 1)))
plot(c,add=TRUE)
######################################################
## Gest ###
plot(Gest(data.ppp)) 
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit.strauss,fun = Gest,nsim=n,rank=(p * (n + 1)))
plot(c,add=TRUE)
#########################
## Fest ###
plot(Fest(data.ppp)) 
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit.strauss,fun = Fest,nsim=n,rank=(p * (n + 1)))
plot(c,add=TRUE)
############################
## Lest ###
plot(Lest(data.ppp))  
p  <- 0.05 # Desired p significance level to display
n<-99
c=envelope(fit.strauss,fun = Lest,nsim=n,rank=(p * (n + 1)))
plot(c,add=TRUE)
########################################################################################
