library(raster)

##plantspdf1 comes from previous script "forest script.R"

densities = list()
  map = brick("predictionStack_devils_1985to2035.tif")

for(i in 1:11){

newmap = map[[i]]


densities[[i]] <- raster::extract(newmap,    
                            plantspdf1, 
                            fun=mean,      
                            df=TRUE)
}


  maxDensities = c()
for(j in 1:477){
  patchDens = c()
  for(k in 1:11){
    patchDens[k] = densities[[k]][j,2]
  }
  maxDensities[j] = max(patchDens)
  
}
  
  write.csv(maxDensities, file = "max_densities.csv")
  write.csv(densities[[11]], file = "1996_densities.csv")
  
