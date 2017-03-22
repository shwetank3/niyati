library(geoR)
data("gambia")

plot(gambia.borders, type="l", asp=1)
points(gambia[,1:2], pch=19)
# a built-in function for a zoomed map
gambia.map()
# Building a "village-level" data frame
ind <- paste("x",gambia[,1], "y", gambia[,2], sep="")
village <- gambia[!duplicated(ind),c(1:2,7:8)]
village$prev <- as.vector(tapply(gambia$pos, ind, mean))
plot(village$NDVI, village$prev)

kmcluster <- kmeans(cbind(gambia$x,gambia$y),centers = 4, iter.max = 100)
plot(gambia.borders,type="l",asp=1)
points(gambia$x,gambia$y,col=kmcluster$cluster,pch=20)
#points(kmcluster$centers[,1:2],col = "red", cex = .6)
plot(gambia[,1:2],col=kmcluster$cluster,pch=19)
#Area<-as.data.frame(kmcluster$size[kmcluster$cluster])
#names(Area)<-"Area"
D1<-as.data.frame(as.integer(as.matrix(kmcluster$cluster==1)))
names(D1)<-"D1"
D2<-as.data.frame(as.integer(as.matrix(kmcluster$cluster==2)))
names(D2)<-"D2"
D3<-as.data.frame(as.integer(as.matrix(kmcluster$cluster==3)))
names(D3)<-"D3"
D4<-as.data.frame(as.integer(as.matrix(kmcluster$cluster==4)))
names(D4)<-"D4"

#### NDVI
gambia$green <- gambia$green/(max(gambia$green))
names(gambia)[7]<-'NDVI'
gambia$NDVI2 <- (gambia$NDVI)^2
head(gambia)

coord<- cbind(gambia$x,gambia$y)/(1000)
max.dist<-max(dist(coord))
bins<-20

##########Regressor with NDVI
gambia.logit <- glm(gambia$pos ~ gambia$age + gambia$netuse + gambia$treated + gambia$NDVI + gambia$phc, family = binomial(link = "logit"), na.action = na.pass)
summary(gambia.logit)

residuals.gambia <-cbind.data.frame(gambia$x,gambia$y,residuals(gambia.logit))
residuals.gambia.variogram <- variog(coords = coord,data = residuals.gambia$`residuals(gambia.logit)`,uvec = (seq(0,max.dist,length=bins)))
par(mfrow = c(1,1))
plot(residuals.gambia.variogram)

##########Regressor with NDVI2
gambia.logit2 <- glm(gambia$pos ~ gambia$age + gambia$netuse + gambia$treated + gambia$NDVI2 + gambia$phc, family = binomial(link = "logit"), na.action = na.pass)
summary(gambia.logit2)

residuals2.gambia <-cbind.data.frame(gambia$x,gambia$y,residuals(gambia.logit2))
residuals2.gambia.variogram <- variog(coords = coord,data = residuals2.gambia$`residuals(gambia.logit2)`,uvec = (seq(0,max.dist,length=bins)))
par(mfrow = c(1,1))
plot(residuals2.gambia.variogram)

###Regressor with NDVI2 and area
gambia.logit.area <- glm(gambia$pos ~ gambia$age + gambia$netuse + gambia$treated + gambia$NDVI2 + gambia$phc + unlist(D1)+unlist(D2)+unlist(D3)+unlist(D4), family = binomial(link = "logit"), na.action = na.pass)
summary(gambia.logit.area)

residuals.gambia.area <-cbind.data.frame(gambia$x,gambia$y,residuals(gambia.logit.area))
residuals.gambia.variogram.area <- variog(coords = coord,data = residuals.gambia.area$`residuals(gambia.logit.area)` ,uvec = (seq(0,max.dist,length=bins)))
par(mfrow = c(1,1))
plot(residuals.gambia.variogram.area)

###########Fitting Variogram
variogram.fitted <- variofit(residuals.gambia.variogram.area,ini.cov.pars=c(2,0.01),cov.model="exponential",fix.nugget=TRUE)
plot(residuals.gambia.variogram)
lines(variogram.fitted)

variogram.fitted <- variofit(residuals.gambia.variogram.area,ini.cov.pars=c(2,0.01),cov.model="matern",fix.nugget=TRUE)
plot(residuals.gambia.variogram)
lines(variogram.fitted)


plot(gambia.borders,type="l",asp=1)
points(gambia$x,gambia$y,col=(gambia$NDVI*5),pch=20)


