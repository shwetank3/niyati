#############Answer 1 (b)(v)
########MAP - Under Conjugate Prior - Normal Inverse Gamma Distribution
library(stats4)
alpha = 11
beta = 0.7
#Model 1 - Using Conditional Likelihood
model1.conjugate <- function(phi1,phi2,v)
{
  (beta/v)+((alpha+1)*log(v))+((((n-2)/2)+1)*log(v))+sum((y1[3:n] - phi1*y1[2:(n-1)]- phi2*y1[1:(n-2)])^2/(2*v))
}

map.conjugate.model1 <- mle(model1.conjugate,start=list(phi1=0,phi2=0,v=0.5))

#Model 2
t<-(1:200)
model2.conjugate <- function(a,b,v)
{
  (beta/v)+((alpha+1)*log(v))+(((n/2)+1)*log(v)) + sum((y2-a*cos(2*pi*w*t)-b*sin(2*pi*w*t))^2/(2*v))
}

map.conjugate.model2 <- mle(model2.conjugate,start=list(a=0,b=0,v=0.5))

#############Answer 1 (b)(iii)
########Sketch
#Model 1 - Using Conditional Likelihood
model1.conjugate.v <- function(v)
{
  -(beta/v)-((alpha+1)*log(v))-((n-2)*log(v)/2)-sum((y1[3:n] - 0.5*y1[2:(n-1)]- 0.2*y1[1:(n-2)])^2)/(2*v)
}
curve(model1.conjugate.v,xname=v,xlim = c(0,5))

phi1 <- seq(from=-1,to=1,by=0.05)
model1.conjugate.phi1 <- seq(from=-1,to=1,by=0.05)
model1.conjugate.formula.phi1 <- function(phi1)
{
  -(beta/v)-((alpha+1)*log(v))-((n-2)*log(v)/2)-sum((y1[3:n] - phi1*y1[2:(n-1)]- 0.2*y1[1:(n-2)])^2)/(2*v)
}

for (i in 1:length(phi1)) model1.conjugate.phi1[i] <- model1.conjugate.formula.phi1(phi1[i])
plot(phi1,model1.conjugate.phi1,type="l",lwd=2)
#par(new=TRUE)
phi2 <- seq(from=-1,to=1,by=0.05)
model1.conjugate.phi2 <- seq(from=-1,to=1,by=0.05)
model1.conjugate.formula.phi2 <- function(phi2)
{
  -(beta/v)-((alpha+1)*log(v))-((n-2)*log(v)/2)-sum((y1[3:n] - 0.5*y1[2:(n-1)]- phi2*y1[1:(n-2)])^2)/(2*v)
}

for (i in 1:length(phi2)) model1.conjugate.phi2[i] <- model1.conjugate.formula.phi2(phi2[i])
plot(phi2,model1.conjugate.phi2,type="l",lwd=2)


#Model 2
model2.conjugate.v <- function(v)
{
  -(beta/v)-((alpha+1)*log(v))-(n*log(v)/2) - sum((y2-0.5*cos(2*pi*w*t)-0.2*sin(2*pi*w*t))^2)/(2*v)
}
curve(model2.conjugate.v,xname=v,xlim = c(0,5))

a <- seq(from=-1,to=1,by=0.05)
model2.conjugate.a <- seq(from=-1,to=1,by=0.05)
model2.conjugate.formula.a <- function(a)
{
  -(beta/v)-((alpha+1)*log(v))-(n*log(v)/2) - sum((y2-a*cos(2*pi*w*t)-0.2*sin(2*pi*w*t))^2/(2*v))
}

for (i in 1:length(a)) model2.conjugate.a[i] <- model2.conjugate.formula.a(a[i])
plot(a,model2.conjugate.a,type="l",lwd=2)
#par(new=TRUE)
b <- seq(from=-1,to=1,by=0.05)
model2.conjugate.b <- seq(from=-1,to=1,by=0.05)
model2.conjugate.formula.b <- function(b)
{
  -(beta/v)-((alpha+1)*log(v))-(n*log(v)/2) - sum((y2-0.5*cos(2*pi*w*t)-b*sin(2*pi*w*t))^2/(2*v))
}

for (i in 1:length(b)) model2.conjugate.b[i] <- model2.conjugate.formula.b(b[i])
plot(b,model2.conjugate.b,type="l",lwd=2)

#############Answer 1 (b)(iii)
########Sketch






