rotMtx <- function(th) {
  s <- sin(th)
  c <- cos(th)
  matrix(c(c,s,-s,c),ncol=2)
}

rotVec <- function(v,m) (m %*% v)[,1]

getVtx <- function(n) {
  m <- rotMtx(2*pi/n)
  # aplica rotacao repetidamente, usando ultimo valor.
  accumulate(1:(n-1),
             ~rotVec(.x,m),
             .init=c(0,1))
}

# gera lista com m vertices (de 1:n) sem repeticao consecutiva
getRandVtx <- function(m,n) { 
  rs <- sample.int(n-1,size=m,replace=T)
  inds <- 1:n
  # for each iteration:
  # (1) remove previous choice (.x ~ 1:n) from indices (inds)
  # (2) select from remainder a random item (.y ~ 1:n-1)
  #accumulate(rs,~setdiff(range,.x)[.y])
  accumulate(rs,~inds[-.x][.y] #,.init=1
  )
}

midPoint <- function(a,b) .5*(a+b)
list2DFold <- function(l) data.frame(t(matrix(unlist(l),nrow=2)))
list2DF <- function(l) tibble(x=map_dbl(l,nth,1),
                              y=map_dbl(l,nth,2))

getMidPts <- function(m,n) { 
  poly <- getVtx(n) # returns a list
  vtx <- getRandVtx(m,n) # returns an int vector
  theAcc <- accumulate(vtx,
                       ~midPoint(.x,poly[[.y]]),
                       .init=c(0,0))
  # add column w random vtx indices for coloring
  list2DF(theAcc) %>% mutate(vtx=c(NA,vtx))
}