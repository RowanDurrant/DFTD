# Libraries & WD---------------------------------------------------------------

#setwd("C:/Users/User/Desktop/MRes/Tasmanian Devils")
library(igraph)

argv = commandArgs(trailingOnly = T);
argc = length(argv);

if (argc < 2) {
  stop("Please specify R, Z");
} else {
  R = as.numeric(argv[1]);
  Z = as.numeric(argv[2]);
}
# Parameters --------------------------------------------------------------
patchData = read.csv(file = "dry wet patch areas.csv")
patchAreas = patchData$area / 1000000
patchDims = sqrt(patchAreas)


ExDens = patchData$density1996
meanExDens = mean(ExDens)
relDens = ExDens/meanExDens
baseDens  = 53000/sum(relDens*patchAreas)
K = round(relDens * baseDens * patchAreas)

relDens86 = patchData$density1986 / meanExDens
startpop = round(patchAreas * relDens86 * baseDens)


Sex = c("Female", "Male")
MaxAge = 7*52
TumGrRate = 0.064
DispDist = 5



# import network topology ------------------------------------------------------

relations = read.csv("dry wet networktopology.csv")
g = graph.data.frame(relations, directed=F)
g$AdjList = get.adjlist(g, mode="out")

# Tumour growth function-----------------------------------------------------


TumGrowth = function(inds, TumGrRate){
  for(j in 1:nrow(inds)){
    V = inds$Tum.Vol[j]
    newV = 202/(1+(202/V - 1)*exp(-TumGrRate*7))
    inds$Tum.Vol[j] = newV
  }
  return(inds)
}

#Movement of individuals ------------------------------------------------------

Move.inds = function(inds, dispersal.dist, Boundary_X, Boundary_Y){
  for(j in 1:nrow(inds)){
    dist <- rnorm(1, dispersal.dist, dispersal.dist/10)
    direct <- runif(1, 0, pi*2)
    x.prev <- inds$XLoc[j]
    y.prev <- inds$YLoc[j]
    dx <- sin(direct) * dist
    dy <- cos(direct) * dist
    inds$XLoc[j] <- min(max((x.prev + dx), Boundary_X[1]), Boundary_X[2])
    inds$YLoc[j] <- min(max((y.prev + dy), Boundary_Y[1]), Boundary_Y[2])
  }
  return(inds)
}

# Kill at max age --------------------------------------------------------------

mort.Max <- 0.012

OldAge = function(inds, MaxAge, K){
  mort = c(0.011, 0.004, 0.006, 0.005, 0.012)
  mortD = c()
  if(nrow(inds) < K){mortD <- mort}
  else{ 
    for(i in 1:5){
      mortD[i] <- min(mort[i] + 0.005*(nrow(inds)-K), mort.Max)
    }
  }
  
  for(j in 1:nrow(inds)){
    if(inds$Age[j] == MaxAge){inds$Death[j] = 1}
    if(inds$Age[j] < 52){inds$Death[j] = sample(c(1,0), 1, prob = c(mortD[1], 1-mortD[1]))}
    if(inds$Age[j] >= 52 & inds$Age[j] < 104){inds$Death[j] = sample(c(1,0), 1, prob = c(mortD[2], 1-mortD[2]))}
    if(inds$Age[j] >= 104 & inds$Age[j] < 156){inds$Death[j] = sample(c(1,0), 1, prob = c(mortD[3], 1-mortD[3]))}
    if(inds$Age[j] >= 156 & inds$Age[j] < 260){inds$Death[j] = sample(c(1,0), 1, prob = c(mortD[4], 1-mortD[4]))}
    if(inds$Age[j] >= 260 & inds$Age[j] < MaxAge){inds$Death[j] = sample(c(1,0), 1, prob = c(mortD[5], 1-mortD[5]))}
  }
  inds = inds[inds$Death == 0,]
  return(inds)
}

# Infections -------------------------------------------------------------------


Infection <- function(inds, infect.dist, BP){ 
  TumVol.0 <- 0.0001
  TumVol.max = 202
  ind.S <- which(inds$Infected == 0)
  nS <- length(ind.S)
  ind.I <- which(inds$Infected > 0 & inds$Tum.Vol > TumVol.0 * 10)
  nI <- length(ind.I)
  N <- nrow(inds)
  beta.ij = c()
  if(nS > 0 & nI > 0){
    for(i in 1:nS){
      X.i <- inds$XLoc[ind.S[i]]
      Y.i <- inds$YLoc[ind.S[i]]
      if(inds$Age[ind.S[i]] < 52){ageinfi = 0}
      else{ageinfi = BP}
      
      for(j in 1:nI){
        if(inds$Age[ind.I[j]] < 52){ageinfj = 0}
        else{ageinfj = BP}
        
        V.j <- inds$Tum.Vol[ind.I[j]]
        X.j <- inds$XLoc[ind.I[j]]
        Y.j <- inds$YLoc[ind.I[j]]
        
        meet.ij <- as.numeric(sqrt((X.i - X.j)^2 + (Y.i - Y.j)^2) < infect.dist )
        beta.ij[j] <- meet.ij * (V.j/TumVol.max) * ageinfi * ageinfj 
      }	
      # Force of infection 
      lambda.ind <- max(min(sum(beta.ij[], na.rm=T), 1), 0)	
      # Draw new infections status for individual i
      infect.ind <- sample(c(1,0), 1, prob = c(lambda.ind, 1 - lambda.ind))
      inds$Infected[ind.S[i]] <- infect.ind
      inds$Tum.Vol[ind.S[i]] <- infect.ind * TumVol.0
    }	
  }
  return(inds)
}
# Kill as tumour load increases --------------------------------------------------

TumDeath = function(inds){
  for(j in 1:nrow(inds)){
    TumProp = (inds$Tum.Vol[j] / 202)^4
    inds$Death[j] = sample(c(1,0), 1, prob = c(TumProp, 1-TumProp))
  }
  inds = inds[inds$Death == 0,]
  return(inds)
}

#New Tasmanian Devil Births ----------------------------------------------------


Births = function(inds, Sex){
  ind.mother_release <- inds[which(inds$Sex == "Female" & inds$Age > 52 & inds$Age < 52*5),]
  n.mother.release <- nrow(ind.mother_release)
  ind.father_release <- inds[which(inds$Sex == "Male" & inds$Age > 52 & inds$Age < 52*5),]
  n.father.release <- nrow(ind.father_release)
  if(n.mother.release > 0 & n.father.release > 0){
    for(m in 1:n.mother.release){
      fgenotype = sample(ind.father_release$Genotype, 1)
      mgenotype = ind.mother_release$Genotype[m]
      if(ind.mother_release$Age[m]  >= 52 & ind.mother_release$Age[m] < 104){breedSuccess = 0.21}
      if(ind.mother_release$Age[m]  >= 104 & ind.mother_release$Age[m] < 156){breedSuccess = 0.71}
      if(ind.mother_release$Age[m]  >= 156){breedSuccess = 0.56}
      breeder = sample(c(1,0), 1, prob = c(breedSuccess, 1 - breedSuccess))
      if(breeder==1){
        nyoung <- rbinom(1, 4, 0.64)
        if(nyoung > 0){
          offspring = setNames(data.frame(matrix(ncol = 9, nrow = nyoung)), c("Sex", "XLoc", "YLoc", "Tum.Vol", "Age", "Infected", "Death", "Dispersed", "Genotype"))
          for(n in 1:nyoung){
            offspring$Sex[n] = sample(Sex, 1)
            offspring$XLoc[n] = ind.mother_release$XLoc[m]
            offspring$YLoc[n] = ind.mother_release$YLoc[m]
            offspring$Tum.Vol[n] = 0
            offspring$Infected[n] = 0
            offspring$Age[n] = sample(32:36, 1)
            offspring$Death[n] = 0
            offspring$Dispersed[n] = 0
            offspring$Genotype[n] = sample(c(fgenotype, mgenotype), 1)
          }
          inds <- rbind(inds, offspring) # add new offspring to population
        }
      }
    }
  }
  return(inds)
}

# Generate populations ---------------------------------------------------------


NewPop = function(startpop, poslocs, population){
  inds = setNames(data.frame(matrix(ncol = 9, nrow = 0)), c("Sex", "XLoc", "YLoc", "Tum.Vol", "Age", "Infected", "Death", "Dispersed", "Genotype"))
  
  while(nrow(inds) < startpop){
    inds[nrow(inds)+1,] <- NA
  }
  
  for(i in 1:startpop){
    inds$Sex[i] = sample(Sex, 1)
    inds$XLoc[i] = sample(poslocs, 1)
    inds$YLoc[i] = sample(poslocs, 1)
    inds$Tum.Vol[i] = 0
    inds$Infected[i] = 0
    inds$Age[i] = as.numeric(sample(32:364, 1))
    inds$Death[i] = 0
    inds$Dispersed[i] = 0
    inds$Genotype = population
  }
  return(inds)
}

# Measure genetic diversity --------------------------------------------------------------
genedivers = function(inds){
  JScore = 0
  for(y in unique(inds$Genotype)){
    PiScore = nrow(inds[inds$Genotype == y,]) / nrow(inds)
    JScore = JScore + PiScore^2
  }
  GenDiversity = 1 - JScore
  return(GenDiversity)
}

# Run Simulation ---------------------------------------------------------------

RunModel = function(TumGrRate, DispDist, A, B, BP, K, MaxAge, patchDims, Sex, startpop, Time, g, R, Z){
  print(paste("Contact Distance:", A, "Dispersal Probability:", B, "Bite Probability:", BP))
  NData2 = setNames(data.frame(matrix(ncol = 9, nrow = 1)), c("TumGrowthRate", "Infect.Dist", "Diff.Dist", "DispProb", "MedianPop", "MedianInf", "Stability","Edges", "GenDiv"))
  
  InfDist = A
  Dispersal = B
  
  # Define boundary of space
  Boundary_X = list()
  Boundary_Y = list()
  poslocs = list()
  
  for(s in 1:vcount(g)){
    Boundary_X[[s]] <- c(0, patchDims[s])
    Boundary_Y[[s]] <- c(0, patchDims[s])
    poslocs[[s]] = 0:patchDims[s]
  }
  
  #lists for later
  indslist = list()
  poplist = list()
  inflist = list()
  agelist = list()
  sexlist = list()
  diverselist = list()
  for(e in 1:vcount(g)){
    poplist[[e]] = c(0,0,0,0)
    inflist[[e]] = c(0,0,0,0)
    agelist[[e]] = c(0,0,0,0)
    sexlist[[e]] = c(0,0,0,0)
    diverselist[[e]] = c(0,0,0,0)
  }
  
  #Set up populations
  for(k in 1:vcount(g)){
    indslist[[k]] = NewPop(startpop[k], poslocs[[k]], k)	
  }
  
  
  
  
  #For each time step...
  start <- Sys.time()
  for(t in Time){
    if(t == DFTDStart){
      if(nrow(indslist[[84]][indslist[[84]]$Age > 52,]) > 3){
        #Decide who's getting infected first
        Popinitial = 84
        Vinitial = sample(1:nrow(indslist[[Popinitial]][indslist[[Popinitial]]$Age > 52,]), 3, replace = FALSE)
        for(e in 1:3){ 
          indslist[[Popinitial]]$Tum.Vol[Vinitial[e]] = 0.0001
          indslist[[Popinitial]]$Infected[Vinitial[e]] = 1
          
        }
        
      } else{ break() }
    }
    if(t == PatchIsolate){
      nodes = V(g)
      betweenness = betweenness(g)
      nodebet = cbind(nodes, betweenness)
      nodebet = data.frame(nodebet)
      nodebet = nodebet[order(nodebet$betweenness), ]
      removenodes = tail(nodebet, Z)$nodes
      
      removeedges = E(g)[ from(removenodes) ] 
      
      g = delete_edges(g, removeedges)
      g$AdjList = get.adjlist(g, mode="out") 
      print("edges removed")
    }
    print(t)
    for(p in 1:vcount(g)){
      #Dispersal between populations
      
      if(nrow(indslist[[p]]) > 0){
        neighbours <- g$AdjList[[p]]
        Ninds = nrow(indslist[[p]])
        DensDisp = Dispersal * min(Ninds/startpop[p], 1)
        for(z in 1:Ninds){
          if(indslist[[p]]$Age[z] < 52){
            DProb = DensDisp*10
          }else{
            DProb = DensDisp
          }
          
          indslist[[p]]$Dispersed[z] = sample(c(1,0), 1, prob = c(DProb, 1 - DProb))
          
          if(indslist[[p]]$Dispersed[z] == 1 & length(neighbours) > 0){
            if(length(neighbours) == 1){disploc = as.numeric(neighbours)}
            else{disploc = as.numeric(sample(neighbours, 1))}
            disperser = data.frame(Sex = as.character(indslist[[p]]$Sex[z]), 
                                   XLoc = as.numeric(sample(poslocs[[disploc]], 1)), 
                                   YLoc = as.numeric(sample(poslocs[[disploc]], 1)), 
                                   Tum.Vol = indslist[[p]]$Tum.Vol[z], 
                                   Age = indslist[[p]]$Age[z], 
                                   Infected = indslist[[p]]$Infected[z], 
                                   Death = 0,
                                   Dispersed = 0,
                                   Genotype = indslist[[p]]$Genotype[z])
            indslist[[disploc]] <- rbind(indslist[[disploc]], disperser)
          }
        }
      }
      indslist[[p]] = indslist[[p]][indslist[[p]]$Dispersed == 0,]
    }
    
    for(s in 1:vcount(g)){
      #Within population stuff
      if(nrow(indslist[[s]]) > 0){indslist[[s]] = Infection(indslist[[s]], InfDist, BP)}
      if(nrow(indslist[[s]]) > 0){indslist[[s]] = Move.inds(indslist[[s]], DispDist, Boundary_X[[s]], Boundary_Y[[s]])}
      if(nrow(indslist[[s]]) > 0){indslist[[s]] = TumDeath(indslist[[s]])} 
      if(nrow(indslist[[s]]) > 0){indslist[[s]] = TumGrowth(indslist[[s]], TumGrRate)}
      if(nrow(indslist[[s]]) > 0){indslist[[s]] = OldAge(indslist[[s]], MaxAge, K[s])}
      if(nrow(indslist[[s]]) > 0){indslist[[s]]$Age = indslist[[s]]$Age + 1}
      if(nrow(indslist[[s]]) > 0){
        if(t == 48){indslist[[s]] = Births(indslist[[s]], Sex)}
        if((t %% 52) == 48){indslist[[s]] = Births(indslist[[s]], Sex)}
      }
      
      poplist[[s]][t] = nrow(indslist[[s]])
      inflist[[s]][t] = sum(indslist[[s]]$Infected)
      sexlist[[s]][t] = sum(as.numeric(factor(indslist[[s]]$Sex, levels=c('Female', 'Male')))-1)/nrow(indslist[[s]])
      agelist[[s]][t] = mean(indslist[[s]]$Age)
      diverselist[[s]][t] = genedivers(indslist[[s]])
      
    }
  }
  print(Sys.time() - start)
  
  #Graphs!
  popultotal = c()
  infectedstotal = c()
  diversetotal = c()
  for(h in Time){
    popultotal[h]=0
    infectedstotal[h] = 0
    diversetotal[h] = 0
    for(w in 1:vcount(g)){
      popultotal[h] = popultotal[h] + poplist[[w]][h]
      infectedstotal[h] = infectedstotal[h] + inflist[[w]][h]
      diversetotal[h] = diversetotal[h] + diverselist[[w]][h]
    }
  }
  
  propinf = infectedstotal / popultotal
  islanddiversity = diversetotal / vcount(g)
  
  NData2$TumGrowthRate[1] = TumGrRate
  NData2$Infect.Dist[1] = InfDist
  NData2$Diff.Dist[1] = DispDist
  NData2$MedianPop[1] = median(tail(popultotal, 520))
  NData2$MedianInf[1] = median(tail(propinf, 520))
  NData2$DispProb[1] = Dispersal
  NData2$Stability[1] = sd(tail(popultotal, 520))/mean(tail(popultotal, 520))
  NData2$Edges[1] = ecount(g)
  NData2$GenDiv[1] =  median(tail(islanddiversity, 520))
  
  save(agelist, sexlist, poplist, inflist, indslist, diverselist, NData2, file=paste0("Betweenness_rep_",R,"_step_",Z,".rda"))
  
}


# Run --------------------------------------------------------------

#A = Contact distance
#B = dispersal probability
#BP = bite probability
#R = reps

Time = 1:(52*35)
DFTDStart = 52*10 #when disease is introduced
PatchIsolate = 52*20 #when patches are isolated

A = 0.3
B = 0.007
BP = 0.4

g = graph.data.frame(relations, directed=F)
g$AdjList = get.adjlist(g, mode="out")


RunModel(TumGrRate, DispDist, A, B, BP, K, MaxAge, patchDims, Sex, startpop, Time, g, R, Z)
