library(igraph)
library(invgamma)
source("src/sample_matrix.r")
source("src/plot.r")

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) stop("Missing filename.n", call.=FALSE)
g <- read_graph(args[1], format="edgelist", directed=FALSE)
n <- gorder(g)

rho <- 100
tau <- 100
a <- 0.01
b <- 0.01

y <- as_adjacency_matrix(g, type="both")
tri <- get_triangles(y)
deg <- apply(y, 1, sum)

theta <- 0
mu <- 0
var <- 1
sig <- 1
phi <- rnorm(n, mu, sig)

niter <- 4000
naux <- 400
burnin <- 1000

theta.history <- matrix(nrow=niter, ncol=1)
phi.history <- matrix(nrow=niter, ncol=n)
mu.history <- matrix(nrow=niter, ncol=1)
var.history <- matrix(nrow=niter, ncol=1)

for(i in 1:niter)
{
	print(i)

	# Gibbs: Atualiza theta
	prop <- rnorm(1, theta, 0.1)
	prop.y <- sample_matrix(prop, phi, naux)
	alpha <- min(1, exp(
		(theta-prop)*(prop.y$triangles-tri) +
		dnorm(prop, 0, rho, log=TRUE) - dnorm(theta, 0, rho, log=TRUE) 
		))
	moeda <- rbinom(1, 1, alpha)
	if(moeda) theta <- prop
	print(paste("theta: ", theta))

	# Gibbs: Atualiza phi
	for(j in 1:n)
	{
		prop <- phi
		prop[j] <- rnorm(1, phi[j], 0.1)
		prop.y <- sample_matrix(theta, prop, naux)
		alpha <- min(1, exp(
			(phi-prop) %*% (prop.y$degree-deg) +	
			dnorm(prop[j], mu, sig, log=TRUE) - dnorm(phi[j], mu, sig, log=TRUE)
			))
		
		moeda <- rbinom(1, 1, alpha)
		if(moeda) phi[j] <- prop[j]
	}

	# Metropolis-Hastings: Atualiza mu
	prop <- rnorm(1, mu, 0.1)
	alpha <- min(1, exp(
		-sum(dnorm(phi, mu, sig, log=TRUE)) - dnorm(mu, 0, tau, log=TRUE) +
		sum(dnorm(phi, prop, sig, log=TRUE)) + dnorm(prop, 0, tau, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda) mu <- prop
	print(paste("mu: ", mu))

	# Metropolis-Hastings: Atualiza var
	prop <- runif(1, 0, 2*var)
	prop.sig <- sqrt(prop)
	alpha <- min(1, exp(
		-sum(dnorm(phi, mu, sig, log=TRUE)) - dinvgamma(var, a, b, log=TRUE) +
		sum(dnorm(phi, mu, prop.sig, log=TRUE)) + dinvgamma(prop, a, b, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda)
	{
		var <- prop
		sig <- prop.sig
	}
	print(paste("var: ", var))

	theta.history[i] <- theta
	phi.history[i,] <- phi
	mu.history[i] <- mu
	var.history[i] <- var
}	

pdf("plots/zachary_karate_history.pdf", width=10)
plot_history(theta.history[burnin:niter], mu.history[burnin:niter], var.history[burnin:niter])
dev.off()

pdf("plots/zachary_karate_graph.pdf", width=10)
plot_graph(y, apply(phi.history[burnin:niter,], 2, mean))
dev.off()
