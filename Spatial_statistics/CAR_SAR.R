library(maps)
library(maptools)
library(spdep)
library(classInt) ## Will be used for plotting maps later
library(RColorBrewer) ## Will be used for colored maps

l=list(regions=87, 
     O =c(19,151,24,41,29,15,57,35,36,43,38,26,32,55,14,7,22,50,209,16, 
          42, 36,27,37,45,13,902,17,17,18,51,11,12,44,12,20,13,12,9,23,17, 28,36,10,23,43,28,23,40,71,14,19,24,13,106,83,17,25,9,49,21, 428,6,39,28,47,13,18,240,43,50,19,89,30,16,25,22,6,26,28,16, 
          87,28,14, 59,63,19),
     
     E = c(24.02630, 163.03558, 41.18794, 32.60712, 29.17479, 14.87342, 54.91725, 34.89533, 
           40.04383, 41.75999, 38.89972, 18.87780, 34.89533, 66.93039, 12.58520, 5.72055, 24.02630, 49.19670, 211.08817, 13.72931, 38.89972, 26.31451, 26.88657, 37.18355, 39.47177, 12.58520, 851.21732, 24.02630, 24.59835, 19.44986, 61.20985, 12.58520, 11.44109, 41.18794, 9.15287, 17.73369, 10.86904, 14.87342, 6.29260, 26.31451, 16.58958, 25.17040, 32.60712, 10.29698, 20.02191, 37.18355, 28.60273, 26.31451, 41.75999, 85.23614, 10.86904, 18.87780, 26.31451, 12.01315, 93.81696, 92.67285, 21.73808, 28.03068, 8.58082, 42.33204, 23.45424, 428.46894, 6.86466, 29.74684, 21.73808, 44.62026, 10.29698, 18.87780, 263.71720, 44.04821, 40.61588, 21.73808, 96.10518, 33.75122, 15.44548, 22.31013, 24.59835, 8.58082, 20.59397, 25.74246, 18.30575, 96.10518, 23.45424, 13.72931, 53.77314, 61.78190, 25.74246),
     
     screen=c(43.24,	53.62,	50.47,	44.44,	57.29,	44.12,	45.61,	46.84,	45.71,	55.32,	49.38,	59.65,	50,	60.69,	53.85,	81.25,	54.55,	50.23,	61.01,	56.1,	50.43,	61.29,	52.63,	43.75,	56.3,	44.44,	59.5,	48.61,	40.68,	44.29,	52.1,	39.29,	33.93,	54.62,	28.57,	33.33,	42.86,	59.52,	10,	50,	36.11,	50.72,	59.77,	46.15,	53.85,	51.11,	56.32,	44.93,	53.15,	62.5,	64.29,	64,	50.6,	66.67,	57.53,	49.08,	58.7,	55.07,	54.55,	44.26,	25,	56.22,	40,	43.75,	60,	50.88,	60.42,	45.16,	46.89,	60.83,	57.14,	51.11,	54.02,	54.35,	52.78,	62.5,	41.67,	30,	50,	44.44,	62.5,	55.9,	46.43,	33.33,	49.68,	45.03,	25.00))


mn.county = map("county", "minnesota", fill=TRUE, plot=FALSE)
county.ID <- sapply(strsplit(mn.county$names, ","), function(x) x[2])
mn.poly = map2SpatialPolygons(mn.county, IDs=county.ID)
mn.nb = poly2nb(mn.poly)
mn.adj.mat = nb2mat(mn.nb, style="B")
mn.listw = nb2listw(mn.nb, style="B", zero.policy=TRUE)

rates.raw = probmap(l$O,l$E)$raw
plot(rates.raw)
plot(l$E,rates.raw)

##Performing Freeman-Turkey Transformation
rates.FT = sqrt(1000) * (sqrt(l$O/l$E) + sqrt((l$O + 1)/l$E))
l$risk.FT = rates.FT
plot(l$E,l$risk.FT)

#Geary 
geary.out = geary.test(l$risk.FT, listw=mn.listw, randomisation=TRUE)
geary.out
geary.out2 = geary.test(sar.out.const$fit$residuals, listw=mn.listw, randomisation=TRUE)
geary.out2
#Moran 
moran.out = moran.test(l$risk.FT, listw=mn.listw, randomisation=TRUE)
print(moran.out)
moran.out2 = moran.test(sar.out.const$fit$residuals, listw=mn.listw, randomisation=TRUE)
moran.out2
names(moran.out)
names(moran.out$estimate)
moran.I = moran.out$estimate[1]
moran.I.se = sqrt(moran.out$estimate[3])
moran.I
moran.I.se

#########LM#########
lm.out = lm(risk.FT~ screen, data=l)
summary(lm.out)
AIC(lm.out)

lm.weighted.out = lm(risk.FT~ screen, data=l,weights=E)
summary(lm.weighted.out)
AIC(lm.weighted.out)

lm.const.weighted.out = lm(risk.FT~ 1, data=l,weights=E)
summary(lm.const.weighted.out)
AIC(lm.const.weighted.out)


####SAR#####
#usig lagsar
lagsar.out = lagsarlm(risk.FT~ screen, data=l, listw=mn.listw, zero.policy=TRUE)
summary(lagsar.out)
#constant
sar.out.const = spautolm(risk.FT~1, data=l, family="SAR",listw=mn.listw, zero.policy=TRUE)
summary(sar.out.const)
#with regressor
sar.out = spautolm(risk.FT~screen, data=l, family="SAR",listw=mn.listw, zero.policy=TRUE)
summary(sar.out)
#weights
sar.out.weight = spautolm(risk.FT~screen, data=l, family="SAR",listw=mn.listw, zero.policy=TRUE,weights=E)
summary(sar.out.weight)
#weights and without regressor
sar.out.weight.const = spautolm(risk.FT~1, data=l, family="SAR",listw=mn.listw, zero.policy=TRUE,weights=E)
summary(sar.out.weight.const)


####CAR#####
#constant
car.out.const = spautolm(risk.FT~1, data=l, family="CAR",listw=mn.listw, zero.policy=TRUE)
summary(car.out.const)
#with regressor
car.out = spautolm(risk.FT~screen, data=l, family="CAR",listw=mn.listw, zero.policy=TRUE)
summary(car.out)
#weights
car.out.weight = spautolm(risk.FT~screen, data=l, family="CAR",listw=mn.listw, zero.policy=TRUE,weights=E)
summary(car.out.weight)
#weights and without regressor
car.out.weight.const = spautolm(risk.FT~1, data=l, family="CAR",listw=mn.listw, zero.policy=TRUE,weights=E)
summary(car.out.weight.const)



######### Model Fitting & Visualization ##############
par(mfrow=c(1,2))

l$fitted.sar = fitted(sar.out.weight)
l$fitted.car = fitted(car.out.weight.const)

brks = c(48, 62.5, 63.5, 64.5, 78)
color.pallete = rev(brewer.pal(4,"RdBu"))

class.fitted = classIntervals(var=l$risk.FT, n=4, style="fixed", fixedBreaks=brks, dataPrecision=4)
color.code = findColours(class.fitted, color.pallete)

class.fitted = classIntervals(var=l$fitted.sar, n=4, style="fixed", fixedBreaks=brks, dataPrecision=4)
color.code.fitted = findColours(class.fitted, color.pallete)

class.fitted = classIntervals(var=l$fitted.car, n=4, style="fixed", fixedBreaks=brks, dataPrecision=4)
color.code.fitted.car = findColours(class.fitted, color.pallete)

leg.txt = c("<61", "62.5-63.5", "63.5-64.5",">64.5")

par(mfrow=c(2,1), oma = c(0,0,4,0) + 0.1, mar = c(0,0,1,0) + 0.1)
plot(mn.poly, col=color.code)
title("a) Raw Freeman-Tukey transformed SIDS rates" )
legend("bottomleft", legend=leg.txt, cex=1.25, bty="n", horiz = FALSE, fill = color.pallete)
plot(mn.poly, col=color.code.fitted)
title("b) Fitted SIDS rates from SAR model")

par(mfrow=c(2,1), oma = c(0,0,4,0) + 0.1, mar = c(0,0,1,0) + 0.1)
plot(mn.poly, col=color.code.fitted)
title("a) Fitted SIDS rates from SAR model")
plot(mn.poly, col=color.code.fitted.car)
title("b) Fitted SIDS rates from CAR model" )
legend("bottomleft", legend=leg.txt, cex=1.25, bty="n", horiz = FALSE, fill = color.pallete)


