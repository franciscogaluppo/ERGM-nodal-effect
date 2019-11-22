library(igraph)

plot_graph <- function(y, phi)
{
	resolution <- 100
	palette <- colorRampPalette(c('#fff700','#f81b1b'))
	normalized <- phi / max(phi, na.rm=TRUE)
	colors <- palette(resolution)[as.numeric(cut(normalized, breaks=resolution))]
	g <- graph_from_adjacency_matrix(y, mode="undirected")

	layout(matrix(1:2,nrow=1),widths=c(0.9,0.1))
	plot(g, vertex.color=colors, vertex.size=15, vertex.label.color="black",
		 vertex.label.family="Helvetica", edge.width=2)
	
	xl <- 1.1
	yb <- 1.15
	xr <- 1.6
	yt <- 1.85

	par(mar=c(5.1,0.5,4.1,0.5))

	plot(NA,type="n",ann=FALSE,xlim=c(1,2),ylim=c(1,2),xaxt="n",yaxt="n",bty="n")
	rect(xl, head(seq(yb,yt,(yt-yb)/10),-1), xr, tail(seq(yb,yt,(yt-yb)/10),-1),
    	col=palette(10))

	mtext(round(seq(min(phi),max(phi), length.out=10), 2),side=2,at=tail(seq(yb,yt,(yt-yb)/10),-1)-0.03,las=2,cex=0.7)
	text(1.35, 1.87, expression(phi), cex=1.2)
}

plot_history <- function(theta, mu, var)
{
	par(mfrow=c(3,3))
	
	hist(mu)
	plot(mu, type="l")
	acf(mu, 500)
	
	hist(var)
	plot(var, type="l")
	acf(var, 500)
	
	hist(theta)
	plot(theta, type="l")
	acf(theta, 500)
}
