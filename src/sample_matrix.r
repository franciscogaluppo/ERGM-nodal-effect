get_triangles <- function(y)
{
	n <- dim(y)[1]
	trian <- 0
	for(i in 1:(n-2))
		for(j in (i+1):(n-1))
			for(k in (j+1):n)
				if(y[i,k] && y[i,j] && y[j,k])
					trian <- trian + 1

	return(trian)
}

sample_matrix <- function(theta, phi, naux)
{
	n <- length(phi)
	y <- matrix(0L, ncol=n, nrow=n)
	entries <- rbinom(n*(n-1)/2, 1, 0.5)
	y[lower.tri(y)] <- entries
	y <- t(y)
	y[lower.tri(y)] <- entries
	triangles <- get_triangles(y)

	for(iter in 1:naux)
		for(i in 1:(n-1))
			for(j in (i+1):n)
			{
				count <- 0
				for(k in 1:n)
					if(y[i,k] && y[j,k])
						count <- count + 1

				prob <- 1/(1 + exp(-(theta*count + phi[i] + phi[j])))
				y[i,j] <- rbinom(1, 1, prob)
				if(y[i,j] != y[j,i])
					triangles <- triangles + (-1)^(y[j,i])*count
				y[j,i] <- y[i,j]
			}

	deg <- apply(y, 1, sum)

	return_list <- list("adjacency" = y, "triangles" = triangles, "degree" = deg)
	return(return_list)
}
