library(ggplot2)
library(viridis)
library(extrafont)
library(patchwork)
library(ggnewscale)


Z = c(10,20,30,40,50,60,70,80,90,100)
R = 1:30
Method = c("Betweenness", "Degree", "Random")

Time = 1:1820

# WITH DFTD ---------------------------------------------------

NData = setNames(data.frame(matrix(ncol = 5, nrow = 0)), c("Method","Z","PopMedian",  "InfMedian",  "GenDiversity"))
MData = setNames(data.frame(matrix(ncol = 8, nrow = 0)), c("Method","Z","MeanPop", "PopSE", "MeanInf", "InfSE", "MeanDivers", "DiversSE"))

for(M in Method){
  for(C in Z){
    for(D in R){
      
      if(file.exists(paste0(M,"_rep_",D,"_step_",C,".rda")) == T){
        load(paste0(M,"_rep_",D,"_step_",C,".rda"))
        
        totinf = rep(0,1820)
        for(r in 1:477){
          totinf = totinf + inflist[[r]]
        }
        if(totinf[1040] > 0){
          
          diversetotal = c()
          altdivers = c()
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
  }
}

#NO DFTD ---------------------------------------------------------------


NDataNoDFTD = setNames(data.frame(matrix(ncol = 5, nrow = 0)), c("Method","Z","PopMedian",  "InfMedian",  "GenDiversity"))
MDataNoDFTD = setNames(data.frame(matrix(ncol = 8, nrow = 0)), c("Method","Z","MeanPop", "PopSE", "MeanInf", "InfSE", "MeanDivers", "DiversSE"))

for(M in Method){
  for(C in Z){
    for(D in R){
      
      if(file.exists(paste0(M,"_noDFTD_rep_",D,"_step_",C,".rda")) == T){
        load(paste0(M,"_noDFTD_rep_",D,"_step_",C,".rda"))
        totinf = rep(0,1820)
        for(r in 1:477){
          totinf = totinf + inflist[[r]]
        }
        
        
        diversetotal = c()
        altdivers = c()
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
        
        
        
        NData4 = setNames(data.frame(matrix(ncol = 5, nrow = 1)), c("Method","Z","PopMedian",  "InfMedian",  "GenDiversity"))
        NData4$Method[1]  = M
        NData4$Z[1] = C
        NData4$PopMedian[1] = NData2$MedianPop
        NData4$InfMedian[1] = infpops2
        NData4$GenDiversity[1] = median(tail(islanddiversity, 520))
        NDataNoDFTD = rbind(NDataNoDFTD, NData4)
        
        
        
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
    MData2$MeanPop[1] = mean(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$PopMedian, rm.na = T)
    MData2$PopSE[1] = sd(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$PopMedian)/sqrt(nrow(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]))
    MData2$MeanInf[1] = mean(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$InfMedian, rm.na = T)
    MData2$InfSE[1] = sd(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$InfMedian)/sqrt(nrow(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]))
    MData2$MeanDivers[1] = mean(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$GenDiversity, rm.na = T)
    MData2$DiversSE[1] = sd(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]$GenDiversity)/sqrt(nrow(NDataNoDFTD[NDataNoDFTD$Z== C & NDataNoDFTD$Method == M,]))
    
    MDataNoDFTD = rbind(MDataNoDFTD, MData2)
    
  }
}

#NON ISOLATED ----------------------------------------------------------

NDataNonIsolated = setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("PopMedian",  "InfMedian"))
MDataNonIsolated = setNames(data.frame(matrix(ncol = 4, nrow = 1)), c("MeanPop", "PopSE", "MeanInf", "InfSE"))


for(q in 1:30){
  
  if(file.exists(paste0("100_Year_Density_Disp_0.009_Contact_0.1_BP_0.4_rep_",q,".rda"))){
    print(q)
    load(paste0("100_Year_Density_Disp_0.009_Contact_0.1_BP_0.4_rep_",q,".rda"))
    
    totinf = rep(0,1820)
    for(r in 1:477){
      totinf = totinf + inflist[[r]]
    }
  
    
    
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

MDataNonIsolated$MeanPop = mean(NDataNonIsolated$PopMedian[NDataNonIsolated$InfMedian>0.1])
MDataNonIsolated$PopSE = sd(NDataNonIsolated$PopMedian[NDataNonIsolated$InfMedian>0.1])/sqrt(nrow(NDataNonIsolated[NDataNonIsolated$InfMedian>0.1,]))
MDataNonIsolated$MeanInf = mean(NDataNonIsolated$InfMedian[NDataNonIsolated$InfMedian>0.1])
MDataNonIsolated$InfSE = sd(NDataNonIsolated$InfMedian[NDataNonIsolated$InfMedian>0.1])/sqrt(nrow(NDataNonIsolated[NDataNonIsolated$InfMedian>0.1,]))


#GRAPHS --------------------------------------------------------------------

g1 = ggplot(data = MData, aes(Z,MeanPop)) +
  geom_point(data = MData, aes(x = Z, y = MeanPop, colour = Method, group = Method)) + 
  geom_line(data = MData,aes(x = Z, y = MeanPop, colour = Method, group = Method),size = 1)+ xlim(0,100) +
  geom_errorbar(data = MData,aes(ymin=MeanPop-PopSE, ymax=MeanPop+PopSE, colour = Method), width=2) +
  scale_color_viridis_d() + scale_y_continuous(label=comma) +
  ggtitle("A") +
  new_scale_color() +
  geom_point(data = MDataNoDFTD, aes(x = Z, y = MeanPop, colour = Method, group = Method)) + 
  geom_line(data = MDataNoDFTD, aes(x = Z, y = MeanPop, colour = Method, group = Method),size = 1)+ 
  geom_errorbar(data = MDataNoDFTD, aes(ymin=MeanPop-PopSE, ymax=MeanPop+PopSE, colour = Method), width=2) +
  scale_color_grey() +
  theme_bw() + 
  ylab("Metapopulation size")  +
  geom_hline(yintercept = MDataNonIsolated$MeanPop, linetype = "dashed", colour= "grey") +
  theme(text=element_text(family="Calibri"), legend.position="none", axis.title.x = element_blank())
  #geom_text(aes(70, MDataNonIsolated$MeanPop, label = "Non-isolated mean"), colour = "grey", vjust = -0.5) +
  
g2 = ggplot(data = MData, aes(x = Z, y = MeanInf, colour = Method, group = Method)) +
  #geom_text(aes(70, MDataNonIsolated$MeanInf, label = "Non-isolated mean"), colour = "grey", vjust = -0.5) +
  geom_point() + geom_line(size = 1)   + 
  geom_errorbar(aes(ymin=MeanInf-InfSE, ymax=MeanInf+InfSE, colour = Method), width=2) +
  theme_bw() + scale_color_viridis_d() + xlim(0,100) +
  ylab("Proportion of Patches Infected") + xlab("No. patches isolated") +
  geom_hline(yintercept = MDataNonIsolated$MeanInf, linetype = "dashed", colour= "grey") +
  
  ggtitle("B") +
  theme(text=element_text(family="Calibri"), legend.position="none") 


g3 = ggplot(data = MData, aes(Z,MeanDivers)) +
  geom_point(data = MData, aes(x = Z, y = MeanDivers, colour = Method, group = Method)) + 
  geom_line(data = MData,aes(x = Z, y = MeanDivers, colour = Method, group = Method),size = 1)+ xlim(0,100) +
  geom_errorbar(data = MData,aes(ymin=MeanDivers-DiversSE, ymax=MeanDivers+DiversSE, colour = Method), width=2) +
  scale_color_viridis_d("With DFTD") +
  
  new_scale_color() +
  geom_point(data = MDataNoDFTD, aes(x = Z, y = MeanDivers, colour = Method, group = Method)) + 
  geom_line(data = MDataNoDFTD, aes(x = Z, y = MeanDivers, colour = Method, group = Method),size = 1)+ 
  geom_errorbar(data = MDataNoDFTD, aes(ymin=MeanDivers-DiversSE, ymax=MeanDivers+DiversSE, colour = Method), width=2) +
  scale_color_grey("Without DFTD") +
  theme_bw() + 
  ylab("Mean Within-Population Genetic Variation")  +
  ggtitle("C") +
  #geom_hline(yintercept = MDataNonIsolated$MeanDivers, linetype = "dashed", colour= "grey") +
  #geom_text(aes(70, MDataNonIsolated$MeanDivers, label = "Non-isolated mean"), colour = "grey", vjust = -0.5) +
  theme(text=element_text(family="Calibri"),  axis.title.x = element_blank()) 


p = g1 + g2 + g3
ggsave("figure_6_square.tiff", p, dpi = 300)
