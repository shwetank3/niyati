#############Answer 1 (a)
#Sampling 200 observations using parameter phi1 = 0.5 phi2 = 0.2
#Model 1
n = 200
y1 = rep(NA,n)
phi1 = 0.5
phi2 = 0.2
v = 1

y1[1] = rnorm(1,mean=0,sd=sqrt(v/ (1-(phi1^2+phi2^2)) ))
y1[2] = rnorm(1,mean=0,sd=sqrt(v/ (1-(phi1^2+phi2^2)) ))

for(t in 3:n) y1[t] = phi1*y1[t-1]+ phi2*y1[t-2] + rnorm(1,mean=0,sd=sqrt(v))

plot(y1,type="l",lwd=2)

#Model 2
n = 200
y2 = rep(NA,n)
a = 0.5
b = 0.2
w = 0.3
v = 1

for(t in 1:n) y2[t] = a*cos(2*pi*w*t)+ b*sin(2*pi*w*t) + rnorm(1,mean=0,sd=sqrt(v))

plot(y2,type="l",lwd=2)

#############Answer 1 (b)(i)
library(stats4)
########MLEs
#Model 1 - Using Conditional Likelihood
model1 <- function(phi1,phi2,v)
{
((n-2)*log(v)/2)+sum((y1[3:n] - phi1*y1[2:(n-1)]- phi2*y1[1:(n-2)])^2/(2*v))
}
mle.model1 <- mle(model1,start=list(phi1=0,phi2=0,v=0.5))

#Model 2
t<-(1:200)
model2 <- function(a,b,v)
{
(n*log(v)/2) + sum((y2-a*cos(2*pi*w*t)-b*sin(2*pi*w*t))^2/(2*v))
}
mle.model2 <- mle(model2,start=list(a=0,b=0,v=0.5))

#############Answer 1 (b)(ii)
########MAP - Under Reference Prior - (1/v)
#Model 1 - Using Conditional Likelihood
model1 <- function(phi1,phi2,v)
{
  ((((n-2)/2)+1)*log(v))+sum((y1[3:n] - phi1*y1[2:(n-1)]- phi2*y1[1:(n-2)])^2/(2*v))
}

map.model1 <- mle(model1,start=list(phi1=0,phi2=0,v=0.5))

#Model 2
t<-(1:200)
model2 <- function(a,b,v)
{
  (((n/2)+1)*log(v)) + sum((y2-a*cos(2*pi*w*t)-b*sin(2*pi*w*t))^2/(2*v))
}

map.model2 <- mle(model2,start=list(a=0,b=0,v=0.5))

#############Answer 1 (b)(iii)
########Sketch
#Model 1 - Using Conditional Likelihood
model1.v <- function(v)
{
  -((n-2)*log(v)/2)-sum((y1[3:n] - 0.5*y1[2:(n-1)]- 0.2*y1[1:(n-2)])^2)/(2*v)
}
curve(model1.v,xname=v,xlim = c(0,5))

phi1 <- seq(from=-1,to=1,by=0.05)
model1.phi1 <- seq(from=-1,to=1,by=0.05)
model1.formula.phi1 <- function(phi1)
{
  -((n-2)*log(v)/2)-sum((y1[3:n] - phi1*y1[2:(n-1)]- 0.2*y1[1:(n-2)])^2)/(2*v)
}

for (i in 1:length(phi1)) model1.phi1[i] <- model1.formula.phi1(phi1[i])
plot(phi1,model1.phi1,type="l",lwd=2)
#par(new=TRUE)
phi2 <- seq(from=-1,to=1,by=0.05)
model1.phi2 <- seq(from=-1,to=1,by=0.05)
model1.formula.phi2 <- function(phi2)
{
  -((n-2)*log(v)/2)-sum((y1[3:n] - 0.5*y1[2:(n-1)]- phi2*y1[1:(n-2)])^2)/(2*v)
}

for (i in 1:length(phi2)) model1.phi2[i] <- model1.formula.phi2(phi2[i])
plot(phi2,model1.phi2,type="l",lwd=2)


#Model 2 Answer 1 (b)(iv)
model2.v <- function(v)
{
  -(n*log(v)/2) - sum((y2-0.5*cos(2*pi*w*t)-0.2*sin(2*pi*w*t))^2)/(2*v)
}
curve(model2.v,xname=v,xlim = c(0,5))

a <- seq(from=-1,to=1,by=0.05)
model2.a <- seq(from=-1,to=1,by=0.05)
model2.formula.a <- function(a)
{
  -(n*log(v)/2) - sum((y2-a*cos(2*pi*w*t)-0.2*sin(2*pi*w*t))^2/(2*v))
}

for (i in 1:length(a)) model2.a[i] <- model2.formula.a(a[i])
plot(a,model2.a,type="l",lwd=2)
#par(new=TRUE)
b <- seq(from=-1,to=1,by=0.05)
model2.b <- seq(from=-1,to=1,by=0.05)
model2.formula.b <- function(b)
{
  -(n*log(v)/2) - sum((y2-0.5*cos(2*pi*w*t)-b*sin(2*pi*w*t))^2/(2*v))
}

for (i in 1:length(b)) model2.b[i] <- model2.formula.b(b[i])
plot(b,model2.b,type="l",lwd=2)
