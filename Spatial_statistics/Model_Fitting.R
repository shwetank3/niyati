
setwd("C:/Users/shwetank/Desktop/SEM2/Spatial Statistics/HW3")
library(spBayes)
library(MBA)
library(geoR)
library(fields)
library(sp)
library(maptools)
library(rgdal)
library(classInt)
library(lattice)
Lithology <- read.csv("C:/Users/shwetank/Desktop/SEM2/Spatial Statistics/HW3/Lithology.csv")
head(lithography)
######## Data Visualization###################################
col.br <- colorRampPalette(c("blue", "cyan", "yellow", "red"))
col.pal <- col.br(5)
x.res <- 1000
y.res <- 1000
coords <- as.matrix(Lithology[,c("Easting","Northing")])

surf_elevation    <- as.matrix(Lithology[,c("Surf.Elevation")])
surf <- mba.surf(cbind(coords, surf_elevation), no.X = x.res, no.Y = y.res)$xyz.est
image.plot(surf, xaxs = "r", yaxs = "r",  xlab = "Easting", ylab = "Northing",
           col = col.br(25))
contour(surf, add=T) ## (Optional) Adds contour lines to the plot

thickness    <- as.matrix(Lithology[,c("Thickness")])
surf <- mba.surf(cbind(coords, thickness), no.X = x.res, no.Y = y.res)$xyz.est
image.plot(surf, xaxs = "r", yaxs = "r",  xlab = "Easting", ylab = "Northing",
           col = col.br(25))
contour(surf, add=T) ## (Optional) Adds contour lines to the plot

a_b_elevation    <- as.matrix(Lithology[,c("A.B.Elevation")])
surf <- mba.surf(cbind(coords, a_b_elevation), no.X = x.res, no.Y = y.res)$xyz.est
image.plot(surf, xaxs = "r", yaxs = "r",  xlab = "Easting", ylab = "Northing",
           col = col.br(25))
contour(surf, add=T) ## (Optional) Adds contour lines to the plot

###########################Model Fitting################################################

lith.sort <- Lithology[order(Lithology$Northing,Lithology$Easting),]
lith.sort <- Lithology
lith.train<-lith.sort[1:100,]
lith.test<-lith.sort[101:113,]
thickness.train <- log(lith.train$Thickness);
lith.train.coords <- as.matrix(lith.train[,c("Easting","Northing")])




### Estimate Phi sigma.sq and tau.sq from covariogram fitting ###
max.dist <- max(dist(lith.train.coords))
bins <- 50
thickness.var <- variog(coords = lith.train.coords, data = thickness.train,uvec = (seq(0,max.dist/5,length = bins)))
fit.thickness <- variofit(thickness.var,ini.cov.pars =  c(1,1),fix.nugget = TRUE,cov.model = "exponential")
plot(thickness.var)
lines(fit.thickness)

n.samples <- 10000

#linear fit
lm_thick <- lm(thickness.train~lith.train$A.B.Elevation+lith.train$Surf.Elevation, data=lith.train)
model_lm <- bayesLMRef(lm_thick, n.samples)

beta.ini<-as.numeric(lm_thick$coeff)
phi.ini<-0.0005
sigma.ini<-1/rgamma(1,2,0.4)
tau.ini<-1/rgamma(1,2,0.1)

#exponential
sp.thick.exp<- spLM(thickness.train~lith.train$A.B.Elevation+lith.train$Surf.Elevation,
                     data=lith.train, coords=lith.train.coords,
                     starting=list("phi"=phi.ini,"sigma.sq"=sigma.ini,
                                   "tau.sq"=tau.ini,"beta"=beta.ini),
                     tuning=list("phi"=0.1, "sigma.sq"=0.05,
                                 "tau.sq"=0.05),
                     priors=list("phi.Unif"=c(3/15000, 3/5000),
                                 "sigma.sq.IG"=c(0.1, 0.1),
                                 "tau.sq.IG"=c(0.1, 0.1),"beta.Flat"),
                     cov.model="exponential",n.samples=n.samples
)

#exponential no nugget
sp.thick.exp.no.nug <- spLM(thickness.train~lith.train$A.B.Elevation+lith.train$Surf.Elevation,
                  data=lith.train, coords=lith.train.coords,
                  starting=list("phi"=phi.ini,"sigma.sq"=sigma.ini,
                                "tau.sq"=tau.ini,"beta"=beta.ini),
                  tuning=list("phi"=0.1, "sigma.sq"=0.05,
                                "tau.sq"=0.05),
                  priors=list("phi.Unif"=c(3/15000, 3/5000),
                                "sigma.sq.IG"=c(0.1, 0.1),
                                nugget=FALSE),
                  cov.model="exponential",n.samples=n.samples
                 )


#matern
sp.thick.mat <- spLM(thickness.train~lith.train$A.B.Elevation+lith.train$Surf.Elevation,
                 data=lith.train, coords=lith.train.coords,
                 starting=list("phi"=phi.ini,"sigma.sq"=sigma.ini,
                               "tau.sq"=tau.ini,"beta"=beta.ini,"nu"=1),
                 tuning=list("phi"=0.1, "sigma.sq"=0.05,
                             "tau.sq"=0.05,"nu"=0),
                 priors=list("phi.Unif"=c(3/15000, 3/5000),
                             "sigma.sq.IG"=c(0.1, 0.1),
                             "tau.sq.IG"=c(0.1, 0.1),
                             "nu.Unif"=c(0.8,1.2)),
                 cov.model="matern",n.samples=n.samples
)

#matern no nugget
sp.thick.mat.no.nug <- spLM(thickness.train~lith.train$A.B.Elevation+lith.train$Surf.Elevation,
                     data=lith.train, coords=lith.train.coords,
                     starting=list("phi"=phi.ini,"sigma.sq"=sigma.ini,
                                   "tau.sq"=tau.ini,"beta"=beta.ini,"nu"=1),
                     tuning=list("phi"=0.1, "sigma.sq"=0.05,
                                 "tau.sq"=0.05,"nu"=0),
                     priors=list("phi.Unif"=c(3/15000, 3/5000),
                                 "sigma.sq.IG"=c(0.1, 0.1),
                                 "nu.Unif"=c(0.8,1.2),
                                 nugget=FALSE),
                     cov.model="matern",n.samples=n.samples
)

#comparison
set.seed(1)
burn.in <- floor(0.75*n.samples)

w.samples = bef.sp$p.w.recover.samples

sp.thick.exp <- spRecover(sp.thick.exp, start=burn.in, verbose=FALSE)
exp.DIC <- spDiag(sp.thick.exp, verbose=FALSE)
beta.samples.exp = sp.thick.exp$p.beta.recover.samples
par(mfrow=c(3,2))
plot(beta.samples.exp, auto.layout=TRUE, density=TRUE)

sp.thick.mat <- spRecover(sp.thick.mat, start=burn.in, verbose=FALSE)
mat.DIC <- spDiag(sp.thick.mat, verbose=FALSE)
beta.samples.mat = sp.thick.mat$p.beta.recover.samples
par(mfrow=c(3,2))
plot(beta.samples.mat, auto.layout=TRUE, density=TRUE)

sp.thick.exp.no.nug <- spRecover(sp.thick.exp.no.nug, start=burn.in, verbose=FALSE)
exp.no.nug.DIC <- spDiag(sp.thick.exp.no.nug, verbose=FALSE)
beta.samples.exp.no.nug = sp.thick.exp.no.nug$p.beta.recover.samples
par(mfrow=c(3,2))
plot(beta.samples.exp.no.nug, auto.layout=TRUE, density=TRUE)

sp.thick.mat.no.nug <- spRecover(sp.thick.mat.no.nug, start=burn.in, verbose=FALSE)
mat.no.nug.DIC <- spDiag(sp.thick.mat.no.nug, verbose=FALSE)
beta.samples.mat.no.nug = sp.thick.mat.no.nug$p.beta.recover.samples
par(mfrow=c(3,2))
plot(beta.samples.mat.no.nug, auto.layout=TRUE, density=TRUE)

round(summary(mcmc(sp_thick$p.theta.samples))$quantiles,3)

###########################################
##       Prediction for spLM
###########################################


n.pred <- 13

# In this matrix, we place the covariates for the sites where we want to make predictions
test.cov <- matrix(cbind(rep(1, n.pred), lith.test$Surf.Elevation,lith.test$A.B.Elevation),nrow=n.pred,ncol=3)



# These are the coordinates of the sites where we want to make prediction
test.coords <- cbind(lith.test$Northing,lith.test$Easting)

# This command generates predictions at the 237 selected sites for prediction, by using composition
# sampling and the MCMC samples generated earlier (here we are prediciting from the posterior predictive distribution). 
# Since we use 1000 as burnin, we are starting to make predictions from the 2500-th iterations
# and we make predictions every 2 iterations (this is the thinning parameter)
pred <- spPredict(sp.thick.exp, pred.coords=test.coords, pred.covars=test.cov)

names(pred)


par(mfrow=c(1,2))
### plot raw data
coords <- as.matrix(lith.test[,c("Easting","Northing")])
surf <- mba.surf(cbind(coords, log(lith.test$Thickness)), no.X = x.res, no.Y = y.res)$xyz.est
image.plot(surf, xaxs = "r", yaxs = "r",  xlab = "Easting", ylab = "Northing",
           col = col.br(25))
contour(surf, add=T) ## (Optional) Adds contour lines to the plot

post.pred.mean <- rowMeans(pred$p.y.predictive.samples)

### plot predition data
coords <- as.matrix(lith.test[,c("Easting","Northing")])
surf <- mba.surf(cbind(coords, post.pred.mean), no.X = x.res, no.Y = y.res)$xyz.est
image.plot(surf, xaxs = "r", yaxs = "r",  xlab = "Easting", ylab = "Northing",
           col = col.br(25))
contour(surf, add=T) ## (Optional) Adds contour lines to the plot

mean(abs((post.pred.mean-log(lith.test$Thickness)))[log(lith.test$Thickness)!=-Inf])
sqrt(mean(((post.pred.mean-log(lith.test$Thickness))^2)[log(lith.test$Thickness)!=-Inf]))

