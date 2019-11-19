niter <- 1000

# Valores do grafo
n <- 10


# Constantes
rho <-
tau <-
a <-
b <-

# Valores iniciais
theta
y
phi <- rep(0, n)
mu <- 0
var <- 1
sig <- 1

for(i in 1:niter)
{
	# Gibbs: Atualiza theta e y

	# Gibbs: Atualiza phi e y

	# Metropolis-Hastings: Atualiza mu
	prop <- rnorm(1, mu, 1)
	alpha <- min(1, exp(
		sum(dnorm(phi, mu, sig, log=TRUE)) + dnorm(mu, 0, tau, log=TRUE) -
		sum(dnorm(phi, prop, sig, log=TRUE)) - dnorm(prop, 0, tau, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda == 1) mu <- prop

	# Metropolis-Hastings: Atualiza var
	prop <- rnorm(1, var, 1)
	prop.sig <- sqrt(prop)
	alpha <- min(1, exp(
		sum(dnorm(phi, mu, sig, log=TRUE)) + (var, a, b, log=TRUE) -
		sum(dnorm(phi, mu, prop.sig, log=TRUE)) - (prop, a, b, log=TRUE)))
	moeda <- rbinom(1, 1, alpha)
	if(moeda == 1)
	{
		var <- prop
		sig <- prop.sig
	}
}	
