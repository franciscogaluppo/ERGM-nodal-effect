sample_matrix <- function(theta, phi, naux)
{
	n <- length(phi)
	triangles <- 0
	y <- matrix(rbinom(n*n, 1, 0.5), ncol=n, nrow=n)

	for(iter in 1:naux)
		for(i in 1:(n-1))
			for(j in (i+1):n)
			{
				count <- 0
				for(k in 1:n)
				{
					if(k == i || k == j)
						next
					if(y[i,k] && y[j,k])
						count <- count + 1
				}
				prob <- 1/(1 + exp(-(theta*count + phi[i] + phi[j])))
				y[i,j] <- rbinom(1, 1, prob)
				if(y[i,j] != y[j,i])
					triangles <- triangles + (-1)^(y[j,i])*count
				y[j,i] <- y[i,j]
			}

	density <- function(th=theta, tri=triangles, p=phi, a=y, log=FALSE)
	{
		if(log)
			return(th*tri + as.numeric(p %*% apply(a, 1, sum)))
		else
			return(exp(th*tri + as.numeric(p %*% apply(a, 1, sum))))
	}

	return_list <- list("adjacency" = y, "triangles" = triangles, "density" = density)
	return(return_list)
}
