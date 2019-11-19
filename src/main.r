library(igraph)
library(invgamma)

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) stop("Missing filename.n", call.=FALSE)
g <- read_graph(args[1], format="edgelist", directed=FALSE)
n <- gorder(g)

rho <-
tau <-
a <-
b <-

theta <- c(0, 0) 
y <- as.adj(g, type="both")
phi <- rep(0, n)
mu <- 0
var <- 1
sig <- 1

niter <- 1000

###############################
### CADA PARTE TEM ITERAÇÃO ###
###############################

for(i in 1:niter)
{
	# Gibbs: Atualiza theta e y

	# Gibbs: Atualiza phi e y
	prop <- rnorm(n, phi, 1)

	# Metropolis-Hastings: Atualiza mu
	prop <- rnorm(1, mu, 1)
	alpha <- min(1, exp(
		sum(dnorm(phi, mu, sig, log=TRUE)) + dnorm(mu, 0, tau, log=TRUE) -
		sum(dnorm(phi, prop, sig, log=TRUE)) - dnorm(prop, 0, tau, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda == 1) mu <- prop

	# Metropolis-Hastings: Atualiza var
	prop <- runif(1, 0, 2*var)
	prop.sig <- sqrt(prop)
	alpha <- min(1, exp(
		sum(dnorm(phi, mu, sig, log=TRUE)) + dinvgamma(var, a, b, log=TRUE) -
		sum(dnorm(phi, mu, prop.sig, log=TRUE)) - dinvgamma(prop, a, b, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda == 1)
	{
		var <- prop
		sig <- prop.sig
	}
}	
