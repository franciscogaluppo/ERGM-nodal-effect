library(igraph)

sample_matrix <- function(theta, phi, y)
{
	n <- length(phi)
	triangles <- 0

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

	return(y)
}

plot_graph <- function(y, phi)
{
	resolution <- 100
	colors <- palette(resolution)[as.numeric(cut(phi, breaks=resolution))]
	g <- graph_from_adjacency_matrix(y, mode="undirected")
	plot(g, vertex.color=colors)
}
