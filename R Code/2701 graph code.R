library(ggplot2)
library(viridis)
library(extrafont)
library(patchwork)
library(beepr)


ContactDistances = c(0.1,0.2,0.3,0.4,0.5)
DispersalProbabilities = c(0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.01)
BP = c(0.2,0.3,0.4,0.5,0.6,0.7)
R = 1:20

Time = 1:1820


NData = setNames(data.frame(matrix(ncol = 6, nrow = 0)), c("Infect.Dist", "DispProb", "BiteProb","PopMedian", "InfMedian", "InfPops"))

for(A in ContactDistances){
  for(B in DispersalProbabilities){
    for(C in BP){
      for(D in R){
        
        if(file.exists(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/100_Year_Density_Disp_",B,"_Contact_",A,"_BP_",C,"_rep_",D,".rda")) == T){
          load(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/100_Year_Density_Disp_",B,"_Contact_",A,"_BP_",C,"_rep_",D,".rda"))
          
          popultotal = rep(0,1820)
          infectedstotal = rep(0,1820)
          infpops = 0
          for(w in 1:477){
            popultotal = popultotal + poplist[[w]]
            infectedstotal = infectedstotal + inflist[[w]]
            if(sum(inflist[[w]]) > 0){infpops = infpops + 1}
          }
          
          NData3 = setNames(data.frame(matrix(ncol = 6, nrow = 1)), c("Infect.Dist", "DispProb", "BiteProb","PopMedian",  "InfMedian", "InfPops"))
          NData3$Infect.Dist = A
          NData3$DispProb = B
          NData3$BiteProb = C
          NData3$PopMedian = median(popultotal[1300:1820])
          NData3$InfMedian = median(infectedstotal[1300:1820]/popultotal[1300:1820])
          NData3$InfPops = infpops/477
          NData = rbind(NData, NData3)
        }
        else{}
        
      }
    }
  }
}


MData = setNames(data.frame(matrix(ncol = 9, nrow = 0)), c("Infect.Dist", "DispProb", "BiteProb","MeanPop", "PopSE", "MeanInf", "InfSE", "MeanInfPops", "InfPopSE"))


for(A in ContactDistances){
  for(B in DispersalProbabilities){
    for(C in BP){
      MData2 = setNames(data.frame(matrix(ncol = 9, nrow = 1)), c("Infect.Dist", "DispProb", "BiteProb","MeanPop", "PopSE", "MeanInf", "InfSE", "MeanInfPops", "InfPopSE"))
      samplesize = nrow(NData[NData$Infect.Dist == A & NData$DispProb == B & NData$BiteProb == C,])
      
      MData2$Infect.Dist = A
      MData2$DispProb = B
      MData2$BiteProb = C
      
      MData2$MeanPop = mean(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$PopMedian)
      MData2$PopSE = sd(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$PopMedian)/sqrt(samplesize)
      MData2$MeanInf = mean(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$InfMedian)
      MData2$InfSE = sd(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$InfMedian)/sqrt(samplesize)
      MData2$MeanInfPops = mean(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$InfPops)
      MData2$InfPopSE = sd(NData[NData$BiteProb== C & NData$Infect.Dist == A & NData$DispProb == B,]$InfPops)/sqrt(samplesize)
      MData = rbind(MData, MData2)
    }
  }
}

g1 = ggplot(data = MData, aes(x = DispProb, y = MeanPop, group = as.factor(Infect.Dist), 
                              color = as.factor(Infect.Dist))) 
g1 = g1 + geom_line(size = 1) + scale_color_viridis_d(name = "Contact Distance", direction = -1) +
  geom_errorbar(aes(ymin=MeanPop-PopSE, ymax=MeanPop+PopSE), width=0.0001) +
  geom_point() + ylab("Metapopulation Size") + xlab("Dispersal Probability") +
  facet_wrap(~ BiteProb) + theme_bw()

g2 = ggplot(data = MData, aes(x = DispProb, y = MeanInf, group = as.factor(Infect.Dist), 
                              color = as.factor(Infect.Dist))) 
g2 = g2 + geom_line(size = 1) + scale_color_viridis_d(name = "Contact Distance", direction = -1) +
  geom_errorbar(aes(ymin=MeanInf-InfSE, ymax=MeanInf+InfSE), width=0.0001) +
  geom_point() + ylab("Disease Prevalence") + xlab("Dispersal Probability") +
  facet_wrap(~ BiteProb) + theme_bw()

g3 = ggplot(data = MData, aes(x = DispProb, y = MeanInfPops, group = as.factor(Infect.Dist), 
                              color = as.factor(Infect.Dist))) 
g3 = g3 + geom_line(size = 1) + scale_color_viridis_d(name = "Contact Distance", direction = -1) +
  geom_errorbar(aes(ymin=MeanInfPops-InfPopSE, ymax=MeanInfPops+InfPopSE), width=0.0001) +
  geom_point() + ylab("Proportion of populations DFTD reaches") + xlab("Dispersal Probability") +
  facet_wrap(~ BiteProb) + theme_bw()

g1
ggsave("figure 2.tiff", dpi = 300)

g3
ggsave("figure 3.tiff", dpi = 300)

beep()
