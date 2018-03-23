# An automatic DAG finding algorithm, based on Theorem 3.4, p.47, Causaiton Predication and Search (2nd edition)

# Load required packages ----
# require(BiocGenerics) #Required for installing igraph
 require(igraph)
 require(ppcor)
 require(Hmisc)

# Set Parameters for simulating DAGs and data
# DAG parameters
n.node=10#Number of nodes
e.prob=.35 #Edge probability - connectedness of graph
wlb<--1 # lower bound of edge weights
wub<-1 # upper bound of edge weights

# Dataset parameters
n.par<-1000 #number of "participants"
er_var<-1 # error variance

# Algorithm parameters
p_thresh<-.05 #alpha level for dependency (partial correlation) tests


  ################## Generate a DAG ####################

random_graph<-function(n.node,e.prob,wlb,wub){
  res<-list()

  vec<-vector(mode="numeric",length=((n.node*(n.node+1)/2)-n.node))
  adjvec<-rbinom(n=((n.node*(n.node+1)/2)-n.node),1,e.prob)
  for(i in 1:length(adjvec)){
    if(adjvec[i]==0) next
    else adjvec[i]<-runif(1,min=wlb,max=wub)
  }
  weightmat<-matrix(0,n.node,n.node)
  weightmat[upper.tri(weightmat,diag=FALSE)]=adjvec
  # make this an upper triangular matrix
  res$weightmat<-weightmat
  
  res$graph<-graph_from_adjacency_matrix(weightmat,weighted=TRUE,mode="directed")
  res
}

rg<-random_graph(n.node,e.prob,wlb,wub)

l<-layout.auto(rg$graph)
plot(rg$graph, main="True graph",layout=l)
 #to keep the layout consistent later

# Nice example -----
# weightmat<-matrix(
# c(0, 0.21, 0, 0.945, 0.85,
#   0, 0,    0, 0,     0,
#   0, 0,    0, 0,    -0.587
#   0, 0,    0, 0,     0.184,
#   0, 0,    0, 0,     0),5,5,byrow=TRUE)
# rg$graph<-graph_from_adjacency_matrix(weightmat,weighted=TRUE,mode="directed")
# rg$weightmat<-weightmat

################## Generate Data from the DAG ##########


random_graph_data<-function(n.par,er_var,weightmat=rg$weightmat,n.node=n.node){
  rgdata<-matrix(0,n.par,n.node)

  #for graphs we use from row, to column, ie 1->5 means [1,5]=1
  # Start at the first (exogenous) variable, generate variable value
  # now go to the next downstream variable and generate data (based on value*weight of upstream variable)
  # add random noise
  # repeat for all variables, and then for all participants
  
  for(k in 1:n.par){
    for(j in 1:n.node){
      rgdata[k,j]<-rgdata[k,]%*%weightmat[,j] +rnorm(1,0,er_var) #standard but re-arragned so cols=variables, rows=people
    }}
  rgdata
}
rgdata<-random_graph_data(n.par,er_var,weightmat=rg$weightmat,n.node=n.node)


################## Estimate the DAG ##########

# Step 1 Theorem 3.4
# Find adjacencies (skeleton) of the DAG

skel_find<-function(rgdata,layout=l){
  res<-list()
  n.node<-dim(rgdata)[2]
  nvec<-seq(1:n.node)

#Start with full adjacency matrix - everything connected
adj_mat<-matrix(1,n.node,n.node)
diag(adj_mat)<-0 #Diagonal is meaningless

#Loop through the adjacencies (matrix)
for(i in 2:n.node){ #Skip position 1 - effect of 1 on 1
  for(j in 1:(i-1)){ #only need to loop through each adjacency once (lower triang of adj mat)
      if(rcorr(rgdata)$P[i,j]>p_thresh){  #zero-order correlations
        adj_mat[i,j]=adj_mat[j,i]=0 #if the are not marginally dependent, they are not adjacent
      }else{
    for(co in 1:(n.node-2)){ #If marginally dependent, loop through all other conditioning sets
      condvec<-combn(nvec[c(-i,-j)],co)
      for(k in 1:dim(condvec)[2]){
        condtest<-pcor.test(rgdata[,i],rgdata[,j],rgdata[,condvec[,k]])$p.value #test relevant partial correlation
        if(condtest>p_thresh){
          adj_mat[i,j]=adj_mat[j,i]=0 #if not dependent conditional on some set, set adjacency to zero
          break #stop testing!
        } else next
      }
       if(adj_mat[i,j]==0){
          break #if we have already found them to be unadjacent, stop running tests
        }else next }
        }}}
res$adj_mat<-adj_mat
res$graph<-graph_from_adjacency_matrix(adj_mat,mode="undirected",weighted=NULL)
plot(res$graph,main="Estimated Skeleton (Algorithm Step 1)",layout=l)
res}

skel_G<-skel_find(rgdata,layout=l)
uG<-skel_G$graph
plot(uG,main="Estimated Skeleton (Algorithm Step 1)",layout=l)

# Step 2: Orient arrows by finding collidera

openTri<-function(uG){
openTriList <- unique(do.call(c, lapply(as_ids(V(uG)), function(v) { #loop through all the vertices
  do.call(c, lapply(as_ids(neighbors(uG, v)), function(v1) { #find out all the neighbours and loop through again
    v2 <- as_ids(neighbors(uG, v1))
    v2 <- v2[shortest.paths(uG, v, v2) == 2] #check that we have an open triangle (X and Z not also connected)
    
    if(length(v2) != 0) {
      lapply(v2, function(vv2) c(v, v1, vv2))
    } else { list() }
  }))
})))
openTrimat<-do.call(rbind,openTriList)
remrow<-numeric(0)
for(i in 1:dim(openTrimat)[1]){
  center<-openTrimat[i,2]
  for(j in 1:dim(openTrimat)[1]){
    if(i==j){next} else{
  if(openTrimat[j,1]==openTrimat[i,3] && openTrimat[j,3]==openTrimat[i,1] && openTrimat[j,2]==center){
    openTrimat[j,]<-c(0,0,0)
  }else next}
  
  }}
openTrimat<-subset(openTrimat,openTrimat[,2]!=0)
openTrimat} 
#Returns a px3 matrix of "open triangle" adjacencies - middle column is potential collider
openTrimat<-openTri(uG)

pd_find<-function(skel_G,layout=l){
  res<-list()
  
  uG<-skel_G$graph
  adj_mat<-skel_G$adj_mat
  
  openTrimat<-openTri(uG)
  adj_mat_pd<-adj_mat
  
  nvec<-1:dim(skel_G$adj_mat)[1]
  # Loop through open triangles
for(i in 1:dim(openTrimat)[1]){
  #Notation as in the Spirtes & Glymour
  #X->Y<-Z
  X<-openTrimat[i,1]
  Z<-openTrimat[i,3]
  Y<-openTrimat[i,2]
  
  # Start with assuming that Y is always collider
  # from row to column, i.e. X1->X5 is given by [1,5] and X5->X1 is given by [5,1]
  # So i delete from Y to Z and from Y to X
  adj_mat_pd[Y,Z]=adj_mat_pd[Y,X]=0
  
  # Only a collider if X and Z are dependent conditional on every set with Y (and not X or Z)
  # If we find independence for any such conditioning set, I return the one headed arrow to be an undirected arrow
  # Test first if  X and YZ are dependent conditional on Y
  if(pcor.test(rgdata[,X],rgdata[,Z],rgdata[,Y])$p.value>p_thresh){
    adj_mat_pd[Y,Z]=adj_mat_pd[Y,X]=1}else{ #if this is not the case, test all conditioning sets with Y
  for(co in 1:(n.node-3)){
    condvec<-combn(nvec[c(-X,-Y,-Z)],co)
    for(k in 1:dim(condvec)[2]){
      condtest<-pcor.test(rgdata[,X],rgdata[,Z],rgdata[,c(Y,condvec[,k])])$p.value
      if(condtest>p_thresh){
        adj_mat_pd[Y,Z]=adj_mat_pd[Y,X]=1
        break
      } else next
    }
    if(adj_mat_pd[Y,X]==1){
      break
    } else next
    }}}
res$graph<-graph_from_adjacency_matrix(adj_mat_pd)
res$adj_mat_pd<-adj_mat_pd
plot(res$graph,main="Estimated Faithful PDAG",layout=l)
res
}

dag_est<-pd_find(skel_G,layout=l)

dag_est$graph

par(mfrow=c(1,2))
plot(rg$graph, main="True graph",layout=l)
plot(dag_est$graph, main="Estimated Faithful PDAG",layout=l)
rg$weightmat

# plot(dag_est$graph,layout=layout.grid(dag_est$graph))
# plot(rg$graph, main="True graph",layout=layout.grid(dag_est$graph))



