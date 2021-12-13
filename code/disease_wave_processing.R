library(viridis)
library(ggplot2)
library(raster)
library(beepr)

ContactDistances = c(0.1, 0.2, 0.3, 0.4, 0.5)
DispersalProbabilities = c(0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.01)
BP = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8)
R = 1:20

PData = setNames(data.frame(matrix(ncol = 6, nrow = 0)), c("Pop", "Infect.Dist","DispProb", "BiteProb","week", "year"))
for(A in ContactDistances){
  for(B in DispersalProbabilities){
  
    for(C in BP){
      for(D in R){
        if(file.exists(paste0("100_Year_Density_Disp_",B,"_Contact_",A,"_BP_",C,"_rep_",D,".rda")) == T){
          load(paste0("100_Year_Density_Disp_",B,"_Contact_",A,"_BP_",C,"_rep_",D,".rda"))
          totinf = rep(0, 1820)
          totpop = rep(0, 1820)
          for(j in 1:477){
            totinf = totinf + inflist[[j]]
            totpop = totpop + poplist[[j]]
          }
          
          if(totpop[1820] > 12500 & 
             totpop[1820] < 23100 & totinf[1820]/totpop[1820] > 0.05){    
            print(paste(A,B,C,D,totinf[1820]))
            PData2 = setNames(data.frame(matrix(ncol = 6, nrow = 477)), c("Pop", "Infect.Dist","DispProb", "BiteProb", "week", "year"))

          for(i in 1:477){
            PData2$Pop[i] = i
            PData2$Infect.Dist[i] = A
            PData2$DispProb[i] = B
            PData2$BiteProb[i] = C
            PData2$week[i] = NA
            PData2$year[i] = NA  
            for(t in 520:1820){
              if(inflist[[i]][t] > 0){
                PData2$week[i] = t - 520
                PData2$year[i] = (t %/% 52) - 9          
                break()
                }
              else{}
            }
            }
          PData = rbind(PData, PData2)}
          else{}

          }
        }
      }
    }
  }

QData = setNames(data.frame(matrix(ncol = 5, nrow = 0)), c("Pop", "Infect.Dist","DispProb", "BiteProb","Wave"))
for(A in ContactDistances){
  for(B in DispersalProbabilities){
    
    for(C in BP){
      if(nrow(PData[PData$Pop == i & PData$Infect.Dist == A & PData$DispProb == B & PData$BiteProb == C,]) > 0){
      QData2 = setNames(data.frame(matrix(ncol = 5, nrow = 477)), c("Pop", "Infect.Dist","DispProb", "BiteProb","Wave"))
        
      for(i in 1:477){
        QData2$Pop[i] = i
        QData2$Infect.Dist[i] = A
        QData2$DispProb[i] = B
        QData2$BiteProb[i] = C
        
        MeanYear = mean(PData[PData$Pop == i & PData$Infect.Dist == A & PData$DispProb == B & PData$BiteProb == C,]$year, na.rm = T)
        if(is.na(MeanYear == T)){Wave = "Wave7"}
        else if(MeanYear < 6){Wave = "Wave1"}
        else if(MeanYear >= 6 & MeanYear < 11){Wave = "Wave2"}
        else if(MeanYear >= 11 & MeanYear < 16){Wave = "Wave3"}
        else if(MeanYear >= 16 & MeanYear < 21){Wave = "Wave4"}
        else if(MeanYear >= 21 & MeanYear < 25){Wave = "Wave5"}
        else if(MeanYear >= 25 & MeanYear < 27){Wave = "Wave6"}
        else{Wave = "Wave7"}
        QData2$Wave[i] = Wave
      }
      QData = rbind(QData, QData2)
      } else{}
    }
  }
}

data <- read.csv(file = "data/dry_wet_locations_5.csv", header = T)


diseasefront = read.csv(file = "disease_front.csv", header = T)
names(diseasefront) = c("Pop", "Wave")

percentageMatches = setNames(data.frame(matrix(ncol = 4, nrow = 0)), c("Infect.Dist","DispProb", "BiteProb","Matches"))


for(A in ContactDistances){
  for(B in DispersalProbabilities){
    
    for(C in BP){
    
      RData = QData[QData$Infect.Dist == A & QData$DispProb == B & QData$BiteProb == C,]
      if(is.na(RData$Pop[1]) == F){
      Matched = 0
      for( i in 1:477){
        if(RData[RData$Pop == i,]$Wave == diseasefront[diseasefront$Pop ==i,]$Wave){Matched = Matched + 1}
        else{}
      }
      if(Matched > 320){print(paste(A, B, C, Matched))}
      percentageMatches2 = setNames(data.frame(matrix(ncol = 4, nrow = 1)), c("Infect.Dist","DispProb", "BiteProb","Matches"))
      percentageMatches2$Infect.Dist = A
      percentageMatches2$DispProb = B
      percentageMatches2$BiteProb = C
      percentageMatches2$Matches = Matched
      
      percentageMatches = rbind(percentageMatches, percentageMatches2)
      }
    }
  }
}
beep()

### [1] "0.1 0.009 0.4 322"

y <- raster("raster_Tasmania_res500m.grd")
y2 = clump(y)
world2 = rasterToPolygons(y2, dissolve = T)
world3 = world2[4,]


SData = setNames(data.frame(matrix(ncol = 2, nrow = 477)), c("Pop", "MeanYear"))

for(i in 1:477){
  SData$Pop[i] = i
  SData$MeanYear[i] = mean(PData[PData$Pop == i & PData$Infect.Dist == 0.1 & PData$DispProb == 0.009 & PData$BiteProb == 0.4,]$year, na.rm = T)
}

NDataA = cbind(SData, data[,2:3], diseasefront[,2])
NDataB = NDataA[NDataA$Pop != 84,]
NDataC = NDataA[NDataA$Pop == 84,]

ggplot() +
  geom_polygon(data = world3, aes(x=long, y = lat, group = group), fill="lightgrey") +
  theme_void() + 
  geom_point(data=NDataB,size = 3, shape = 16, aes(x=x, y=y, color=(MeanYear + 1996))) +
  geom_point(data=NDataC, size = 3, shape = 15, aes(x=x, y=y), colour = "red") +
  scale_colour_viridis_c() + 
  labs(colour = "Mean year\nDFTD reaches\npopulation", breaks = c(1996, 2000, 2005, 2010, 2015, 2020))+
  scale_shape_identity() + theme(text=element_text(size=12,  family="Calibri"))

ggsave("figure_4.tiff", dpi = 300)
