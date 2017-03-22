coords<-as.matrix(coal.ash[,c("x","y")])
plot(coords,pch=1, col="darkgreen",xlab="xx", ylab="yy")
z<-matrix(,nrow=16,ncol=25)
for (i in 1:length(coal.ash$x)) z[coal.ash$x[i],coal.ash$y[i]] <- coal.ash$coal[i]
contour(coal.ash$x,coal.ash$y,coal.ash$coal,nlevels = 10)
hist(coal.ash$coal)
stem(coal.ash$coal)

library(MBA)
library(fields)
x.res<-100
y.res<-100
coal<-coal.ash$coal
surf<-mba.surf(cbind(coords,coal),no.X = x.res,no.Y = y.res,h = 5, m = 2, extend = FALSE)$xyz.est
col.br <- colorRampPalette(c("blue", "cyan", "yellow", "red"))
image.plot(surf,xaxs = "r", yaxs = "r", xlab = "xx", ylab = "yy", col = col.br(25))
contour(surf, add=T)

library(geoR)
max.dist<-max(dist(coords))
bins<-50
vario.coal<-variog(coords = coords,data = coal.ash$coal,uvec = (seq(0,max.dist,length=bins)))
fit.coal<-variofit(vario.coal,ini.cov.pars = c(1,1),cov.model = "linear",minimisation.function = "optim",weights = "equal")
plot(vario.coal)
lines(fit.coal)