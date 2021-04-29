library(ggplot2)
library(viridis)
library(extrafont)
library(patchwork)


Z = c(10,20,30,40,50,60,70,80,90,100)
R = 1:60
Method = c("Betweenness", "Degree", "Random")

Time = 1:1820

diversetotal = c()
altdivers = c()
NData = setNames(data.frame(matrix(ncol = 5, nrow = 0)), c("Method","Z","PopMedian",  "InfMedian",  "GenDiversity"))
MData = setNames(data.frame(matrix(ncol = 8, nrow = 0)), c("Method","Z","MeanPop", "PopSE", "MeanInf", "InfSE", "MeanDivers", "DiversSE"))

for(M in Method){
  for(C in Z){
      for(D in R){
        
        if(file.exists(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/",M,"_rep_",D,"_step_",C,".rda")) == T){
          load(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/",M,"_rep_",D,"_step_",C,".rda"))
          
          totinf = rep(0,1820)
          for(r in 1:477){
            totinf = totinf + inflist[[r]]
          }
          if(totinf[1040] > 0){
            
            
          for(t in Time){
            diversetotal[t] = 0
            for(v in 1:477){
              if(diverselist[[v]][t] == 1){altdivers[t] = 0}
              else{altdivers[t] = diverselist[[v]][t]}
              diversetotal[t] = diversetotal[t] + altdivers[t]
            }
          }
          islanddiversity = diversetotal / 477
          
          
          infpops = 0
          for(i in 1:477){
            
            if(sum(inflist[[i]]) > 0){
              infpops = infpops + 1
            }
            
          }
          infpops2 = infpops / 477
            
          
          
          NData3 = setNames(data.frame(matrix(ncol = 5, nrow = 1)), c("Method","Z","PopMedian",  "InfMedian",  "GenDiversity"))
          NData3$Method[1]  = M
          NData3$Z[1] = C
          NData3$PopMedian[1] = NData2$MedianPop
          NData3$InfMedian[1] = infpops2
          NData3$GenDiversity[1] = median(tail(islanddiversity, 520))
          NData = rbind(NData, NData3)
            
          } else{}
          
        }
        else{}
        
      }
  }
  }
    
    
for(M in Method){
  for(C in Z){
      MData2 = setNames(data.frame(matrix(ncol = 8, nrow = 1)), c("Method","Z","MeanPop", "PopSD", "MeanInf", "InfSD", "MeanDivers", "DiversSD"))

      MData2$Z[1] = C
      MData2$Method[1] = M
      MData2$MeanPop[1] = mean(NData[NData$Z== C & NData$Method == M,]$PopMedian, rm.na = T)
      MData2$PopSE[1] = sd(NData[NData$Z== C & NData$Method == M,]$PopMedian)/sqrt(nrow(NData[NData$Z== C & NData$Method == M,]))
      MData2$MeanInf[1] = mean(NData[NData$Z== C & NData$Method == M,]$InfMedian, rm.na = T)
      MData2$InfSE[1] = sd(NData[NData$Z== C & NData$Method == M,]$InfMedian)/sqrt(nrow(NData[NData$Z== C & NData$Method == M,]))
      MData2$MeanDivers[1] = mean(NData[NData$Z== C & NData$Method == M,]$GenDiversity, rm.na = T)
      MData2$DiversSE[1] = sd(NData[NData$Z== C & NData$Method == M,]$GenDiversity)/sqrt(nrow(NData[NData$Z== C & NData$Method == M,]))
      
      MData = rbind(MData, MData2)

}}


NDataNonIsolated = setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("PopMedian",  "InfMedian"))
MDataNonIsolated = setNames(data.frame(matrix(ncol = 4, nrow = 1)), c("MeanPop", "PopSE", "MeanInf", "InfSE"))


for(q in 1:10){
  
  if(file.exists(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/100_Year_Density_Disp_0.007_Contact_0.3_BP_0.4_rep_",q,".rda"))){
  load(paste0("C:/Users/User/Desktop/MRes/Tasmanian Devils/hoo boi big files/2403 files/100_Year_Density_Disp_0.007_Contact_0.3_BP_0.4_rep_",q,".rda"))
    
    totinf = rep(0,1820)
    for(r in 1:477){
      totinf = totinf + inflist[[r]]
    }
    if(totinf[1040] == 0){break()}
    
    
    infpops = 0
    for(i in 1:477){
      
      if(sum(inflist[[i]]) > 0){
        infpops = infpops + 1
      }
      
    }
    infpops2 = infpops / 477
    
    NData3 = setNames(data.frame(matrix(ncol = 2, nrow = 1)), c("PopMedian",  "InfMedian"))
    NData3$PopMedian[1] = NData2$MedianPop
    NData3$InfMedian[1] = infpops2
    NDataNonIsolated = rbind(NDataNonIsolated, NData3) 
    
}
  
}

MDataNonIsolated$MeanPop = mean(NDataNonIsolated$PopMedian)
MDataNonIsolated$PopSE = sd(NDataNonIsolated$PopMedian)/sqrt(nrow(NDataNonIsolated))
MDataNonIsolated$MeanInf = mean(NDataNonIsolated$InfMedian)
MDataNonIsolated$InfSE = sd(NDataNonIsolated$InfMedian)/sqrt(nrow(NDataNonIsolated))



g1 = ggplot(data = MData, aes(x = Z, y = MeanPop, colour = Method, group = Method)) +
  geom_point() + geom_line(size = 1)+ xlim(0,100) +
  geom_errorbar(aes(ymin=MeanPop-PopSE, ymax=MeanPop+PopSE), width=2) +
  theme_bw() + scale_color_viridis_d() +
  ylab("Metapopulation size")  +
  geom_hline(yintercept = MDataNonIsolated$MeanPop, linetype = "dashed", colour= "grey") +
  geom_text(aes(70, MDataNonIsolated$MeanPop, label = "Non-isolated mean"), colour = "grey", vjust = -0.5) +
   theme(text=element_text(size=12,  family="Calibri"), legend.position="none", axis.title.x = element_blank())


g2 = ggplot(data = MData, aes(x = Z, y = MeanInf, colour = Method, group = Method)) +
  geom_point() + geom_line(size = 1)   + 
  geom_errorbar(aes(ymin=MeanInf-InfSE, ymax=MeanInf+InfSE), width=2) +
  theme_bw() + scale_color_viridis_d() + xlim(0,100) +
  ylab("Proportion of Patches Infected") + xlab("No. patches isolated") +
  geom_hline(yintercept = MDataNonIsolated$MeanInf, linetype = "dashed", colour= "grey") +
  geom_text(aes(70, MDataNonIsolated$MeanInf, label = "Non-isolated mean"), colour = "grey", vjust = -0.5) +
 theme(text=element_text(size=12,  family="Calibri"), legend.position="none") 

g3 = ggplot(data = MData, aes(x = Z, y = MeanDivers, colour = Method, group = Method)) +
  geom_point() + geom_line(size = 1) + xlim(0,100) +
  geom_errorbar(aes(ymin=MeanDivers-DiversSE, ymax=MeanDivers+DiversSE), width=2) +
  theme_bw() + scale_color_viridis_d(name = "Method") +
  ylab("Mean Within-Population Genetic Variation") +
  theme(text=element_text(size=12,  family="Calibri"), legend.position = c(0.68,0.85), axis.title.x = element_blank())

g1 + g2 + g3

