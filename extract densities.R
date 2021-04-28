densities = list()
  map = brick("predictionStack_devils_1985to2035.tif")

for(i in 1:11){

newmap = map[[i]]


densities[[i]] <- raster::extract(newmap,             # raster layer
                            plantspdf1, 
                            fun=mean,         # what to value to extract
                            df=TRUE)
#cent_max_df = as.data.frame(cent_max)
}

#write.csv(cent_max_df, file = "patch densities.csv")

  maxDensities = c()
for(j in 1:477){
  patchDens = c()
  for(k in 1:11){
    patchDens[k] = densities[[k]][j,2]
  }
  maxDensities[j] = max(patchDens)
  
}
  
  write.csv(maxDensities, file = "max densities.csv")
  write.csv(densities[[11]], file = "1996 densities.csv")
  