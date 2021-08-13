#libraries
library(raster)
library(rgdal)
library(rgeos)
library(sp)
library(igraph)


#Load in TASVEG files
circularHead<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_circular_head")
waratahWynyard<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_waratah_wynyard")
westCoast<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_west_coast")
centralCoast<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_central_coast")
burnie<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_burnie")
devonport<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_devonport")
kentish<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_kentish")
latrobe<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_latrobe")
georgeTown<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_george_town")
westTamar<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_west_tamar")
dorset<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_dorset")
launceston<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_launceston")
northernMidlands<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_northern_midlands")
meanderValley<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_meander_valley")
breakODay<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_break_o_day")
huonValley<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_huon_valley")
derwentValley<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_derwent_valley")
centralHighlands<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_central_highlands")
glamorganSpringBay<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_glamorgan_spring_bay")
southernMidlands<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_southern_midlands")
clarence<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_clarence")
brighton<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_brighton")
glenorchy<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_glenorchy")
kingborough<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_kingborough")
sorell<-readOGR(dsn=path.expand("C:/Users/User/Desktop/MRes/Tasmanian Devils/SDM Stuff/New SDM stuff/Land use data"),layer="list_tasveg_20_sorell")

#These are all the vegcodes for dry sclerophyll, wet sclerophyll,
# and coastal heath
vegcode = c("DAC","DAD","DAS","DAM","DAZ","DSC","DBA","DCO","DCR","DDP","DDE","DGL",
            "DGW","DMO","DNI","DNF","DOB","DOV","DOW","DPO","DPD","DPE","DPU","DRI",
            "DRO","DSO","DSG","DTD","DTG","DTO","DVF","DVG","DVC","DKW","DMW","SCH",
            "WBR","WDA","WDL","WDR","WDB","WDU","WGK","WGL","WNL","WNR","WNU","WOL",
               "WOR","WOB","WOU","WRE","WSU","WVI"
            )

#Remove anything that isn't the veg we want
circularHead2 = circularHead[circularHead$VEGCODE %in% vegcode,]
waratahWynyard2 = waratahWynyard[waratahWynyard$VEGCODE %in% vegcode,]
westCoast2 = westCoast[westCoast$VEGCODE %in% vegcode,]
centralCoast2 = centralCoast[centralCoast$VEGCODE %in% vegcode,]
burnie2 = burnie[burnie$VEGCODE %in% vegcode,]
devonport2 = devonport[devonport$VEGCODE %in% vegcode,]
kentish2 = kentish[kentish$VEGCODE %in% vegcode,]
latrobe2 = latrobe[latrobe$VEGCODE %in% vegcode,]
georgeTown2 = georgeTown[georgeTown$VEGCODE %in% vegcode,]
westTamar2 = westTamar[westTamar$VEGCODE %in% vegcode,]
dorset2 = dorset[dorset$VEGCODE %in% vegcode,]
launceston2 = launceston[launceston$VEGCODE %in% vegcode,]
breakODay2 = breakODay[breakODay$VEGCODE %in% vegcode,]
meanderValley2 = meanderValley[meanderValley$VEGCODE %in% vegcode,]
northernMidlands2 = northernMidlands[northernMidlands$VEGCODE %in% vegcode,]
derwentValley2 = derwentValley[derwentValley$VEGCODE %in% vegcode,]
huonValley2 = huonValley[huonValley$VEGCODE %in% vegcode,]
centralHighlands2 = centralHighlands[centralHighlands$VEGCODE %in% vegcode,]
glamorganSpringBay2 = glamorganSpringBay[glamorganSpringBay$VEGCODE %in% vegcode,]
southernMidlands2 = southernMidlands[southernMidlands$VEGCODE %in% vegcode,]
brighton2 = brighton[brighton$VEGCODE %in% vegcode,]
clarence2 = clarence[clarence$VEGCODE %in% vegcode,]
glenorchy2 = glenorchy[glenorchy$VEGCODE %in% vegcode,]
kingborough2 = kingborough[kingborough$VEGCODE %in% vegcode,]
sorell2 = sorell[sorell$VEGCODE %in% vegcode,]

#One big spatial polygon
plantspdf = rbind(circularHead2, waratahWynyard2, westCoast2, centralCoast2, burnie2,
                  devonport2, kentish2, latrobe2, georgeTown2, westTamar2, dorset2, launceston2,
                  breakODay2, meanderValley2, northernMidlands2, derwentValley2, huonValley2,
                  centralHighlands2, glamorganSpringBay2, southernMidlands2, brighton2,
                  clarence2, glenorchy2, kingborough2, sorell2)

#Get rid of anything too small
#You can leave this til later if you want but I can't guarantee
#that you'll ever be able to use your laptop again
plantspdf = plantspdf[plantspdf$SHAPE_AREA > (5*1000*1000),]

#load in the 1986 density predictions
#you can get this stuff from Cunningham et al. 2021's SI
map = brick("predictionStack_devils_1985to2035.tif")
newmap = map[[2]]

#Extract the densities for each patch of stuff
densities = raster::extract(newmap,           # raster with the data
                            plantspdf,        # your polygons
                            fun=mean,         # get the mean of each area
                            df=TRUE)

#Remove the low density areas
dens = densities$predictionStack_devils_1985to2035.2
plantspdf$density = dens
plantspdf$density[is.na(plantspdf$density)] <- 0
plantspdf1 = plantspdf[plantspdf$density > 0.5,]

y = raster("raster_Tasmania_res500m.grd")

dpi=600    #pixels per square inch
tiff("figure 1a.tif", width=6*dpi, height=5*dpi, res=dpi)

plot(y, col = "lightgrey", xaxt = "n", btn = "n",yaxt = "n", 
     xlim = c(290000, 630000), ylim = c(5150000, 5510000), 
     axes=FALSE)
plot(plantspdf1, col = "black", add = T)

dev.off()

#get the central points of each patch
trueCentroids = gCentroid(plantspdf1,byid=TRUE)
points(trueCentroids,pch=16, col = "blue")

#gotta convert to matrix to get distances
#but data frames are so dang convenient
z = data.frame(trueCentroids)
rownames(z) = 1:nrow(z)
zx = as.vector(z$x)
zy = as.vector(z$y)
y = cbind(zx,zy)

#need this later for plots
#write.csv(z, file = "dry wet locations 5.csv")

#get the inter-patch distances
euclidDist <- sp::spDists(y)

#need this for later
#write.csv(plantspdf1$SHAPE_AREA, file = "dry wet patch areas.csv")


#loop that limits how far the devils can travel and also builds
#the metapop structure
networkDF = setNames(data.frame(matrix(ncol = 3, nrow = 0)), c("from", "to", "distance"))
networkDF2 = setNames(data.frame(matrix(ncol = 3, nrow = 1)), c("from", "to", "distance"))

for(i in 1:nrow(euclidDist)){
  for(j in 1:nrow(euclidDist)){
    if(euclidDist[i,j] < 50000 & i <  j){
  
        networkDF2$from = i
        networkDF2$to = j
        networkDF2$distance = euclidDist[i,j]
        networkDF = rbind(networkDF, networkDF2)
      
    } else{}
  }
}

#write.csv(networkDF, file = "dry wet networktopology.csv")

## OKAY THIS IS VERY IMPORTANT
## YOU HAVE TO OPEN THE CSV IN EXCEL AND DELETE THE FIRST COLUMN WHICH IS JUST ROWNAMES
## AND THEN FIND WHICH PATCH IDS ARE MISSING FROM THE "FROM" COLUMN
## You can use the unique() function on this column to see what's missing
## AND SWITCH STUFF AROUND UNTIL IT GOES FROM 1 -> WHATEVER WITH NO GAPS
## If you don't the network won't be right, it's because it confuses the rownames
## with the patch IDs or something idk
## I know this is effort but I can't figure out how to do it in R automatically
## Just trust me it'll save you hours of pain later on

#make network
relations = read.csv("C:/Users/User/Desktop/MRes/Tasmanian Devils/dry wet networktopology.csv")
g = graph.data.frame(relations, directed=F)



#do some cool igraph layouts
meta <- data.frame("name"=1:nrow(z), 
                   "lon"=z$x,  
                   "lat"=z$y)

lo <- as.matrix(meta[,2:3])

dpi=300    #pixels per square inch
tiff("figure 1b.tiff", width=6*dpi, height=5*dpi, res=dpi)

plot(map[[2]], col = "white",  xlim = c(290000, 630000))

plot.igraph(g, 
     vertex.label = NA,
     edge.color = "lightgrey", 
     vertex.color = "grey",
     vertex.size = 5, 
     layout=lo,
    

  )

dev.off()
