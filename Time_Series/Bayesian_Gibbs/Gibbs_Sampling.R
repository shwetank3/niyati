##########Gibbs Sampling

Qstar <- function(phi,y)
{
  n = length(y)
  y[1]^2 * (1-phi^2) + sum((y[2:n] - phi*y[1:(n-1)])^2)
}

#######################
# Simulating the data #
#######################

n = 500
y1 = rep(NA,n)
x = rep(NA,n)
phi = 0.9
v = 1
theta0 = 0.6
theta1 = 2.5

y1[1] = rnorm(1,mean=0,sd=sqrt(v/(1-phi^2)))

for(t in 2:n) y1[t] = phi*y1[t-1] + rnorm(1,mean=0,sd=sqrt(v))
for(t in 1:n) x[t] = theta0 + theta1*t + y1[t]

plot(x,type="l",lwd=2)

acf(y1)
pacf(y1)

######################################
# Posterior exploration through MCMC #
######################################

Gbig      = 5000
c         = 0.04
t         = (1:500)
phi.gibbs = rep(NA,Gbig)
v.gibbs   = rep(NA,Gbig)
theta0.gibbs = rep(NA,Gbig)
theta1.gibbs = rep(NA,Gbig)
phi.gibbs[1] = 0.1
v.gibbs[1] = 0.1
xt.lm = lm(x ~ t)
theta0.gibbs[1]<-xt.lm$coefficients[1]
theta1.gibbs[1]<-xt.lm$coefficients[2]

for(g in 2:Gbig)
{
  y.new = (x-v.gibbs[g-1]-(theta0.gibbs[g-1] + theta1.gibbs[g-1]*t))/phi.gibbs[g-1]
  y = y.new
 
  # Simulate v using Gibbs step #
  v.gibbs[g] = 1 / rgamma(1,shape=(0.5*n),rate=(0.5*Qstar(phi.gibbs[g-1],y1)))
  
  # Simulate phi using Metropolis-Hastings step #
  xi.current = log((1+phi.gibbs[g-1]) / (1-phi.gibbs[g-1]))
  xi.prop = rnorm(1,mean=xi.current,sd=sqrt(c))
  phi.prop = (exp(xi.prop)-1) / (1+exp(xi.prop))
  
  log.r = 1.5* (log(1-phi.prop^2) - log(1-phi.gibbs[g-1]^2))
  log.r = log.r - (Qstar(phi.prop,y) - Qstar(phi.gibbs[g-1],y)) / (2*v.gibbs[g])
  if(log.r > log(runif(1))) {phi.gibbs[g] = phi.prop} else {phi.gibbs[g] = phi.gibbs[g-1]}

  x.reg = x - (phi.gibbs[g]*y + v.gibbs[g])
  xt.lm = lm(x.reg ~ t)
  theta0.gibbs[g]<-xt.lm$coefficients[1]
  theta1.gibbs[g]<-xt.lm$coefficients[2]
  }
