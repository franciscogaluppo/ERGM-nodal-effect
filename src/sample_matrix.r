sample_matrix <- function(theta, phi)
{
	n <- length(phi)

	y <- matrix(0L, ncol=n, nrow=n)

	triangles <- function(i,j,val)
	{
		A <- y
		A[i,j] <- val
		A[j,i] <- val

		tri <- 0

		for(i in 1:(n-2))
			for(j in (i+1):(n-1))
				for(k in (j+1):n)
					if(A[i,j] && A[i,k] && A[j,k])
						tri <- tri+1

		return(tri)
	}

	sij <- function(i,j) return(triangles(i,j,1) - triangles(i,j,0))
	prob <- function(i,j) return(1/(1 + exp(-(theta*sij(i,j) + phi[i] + phi[j]))))

	for(i in 1:(n-1))
		for(j in (i+1):n)
		{
			y[i,j] <- rbinom(1, 1, prob(i,j))
			y[j,i] <- y[i,j]
		}

	return(y)
}
