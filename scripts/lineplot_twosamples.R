#We just need to ignore the 15mer sequence information because it is shifted 2 nucleotides
#Its because Nanopolish event means are based on 5 mers (base in the middle) but the position is reported for the starting base (position1)
library(stringr)
library(ggplot2)
library(reshape2)
library(data.table)

####USAGE
#R lineplot_twosamples.R ko_perpos_window.csv wt_perpos_window.csv

#Inputs
args <- commandArgs(trailingOnly = TRUE)
input1 <- args[1] #1st variable
input2 <- args[2] #1st variable



ko<- read.delim(input1)
ko_2<- ko[!duplicated(ko[,1:2]),]
ref <- str_split_fixed(ko_2$windown, ":" , 15)
ref_2<- as.numeric(ref[,11])
ko_2$windown<- paste(ref_2)
ko_2$base<- substring(ko_2$kmer, 10,10)
event_level_mean<- str_split_fixed(ko_2$mean_current, ":" ,15)
ko_3<- cbind(ko_2, event_level_mean)
ko_3$mean_current<-NULL
ko_3$read<- NULL
ko_3[,-c(1,2,3,4)] <- data.frame(sapply(ko_3[,-c(1,2,3,4)], function(x) as.numeric(as.character(x)))) #MAKE NUMERIC
colnames(ko_3)<- c("ref", "windown", "kmer", "base", "-7", "-6", "-5", "-4", "-3", "-2", "-1", "0", "1","2","3","4","5","6" , "7" )

ko_final<- melt(ko_3)
ko_final$reference<-paste(ko_final$ref, ko_final$windown)
ko_final$Strain<- rep("snR3-KO", nrow(ko_final))



wt<- read.delim(input2)
wt_2<- wt[!duplicated(wt[,1:2]),]
ref <- str_split_fixed(wt_2$windown, ":" , 15)
ref_2<- as.numeric(ref[,11])
wt_2$windown<- paste(ref_2)
wt_2$base<- substring(wt_2$kmer, 10,10)
event_level_mean<- str_split_fixed(wt_2$mean_current, ":" ,15)
wt_3<- cbind(wt_2, event_level_mean)
wt_3$mean_current<-NULL
wt_3$read<- NULL
wt_3[,-c(1,2,3,4)] <- data.frame(sapply(wt_3[,-c(1,2,3,4)], function(x) as.numeric(as.character(x)))) #MAKE NUMERIC
colnames(wt_3)<- c("ref", "windown", "kmer", "base", "-7", "-6", "-5", "-4", "-3", "-2", "-1", "0", "1","2","3","4","5","6" , "7" )
wt_final<- melt(wt_3)
wt_final$reference<-paste(wt_final$ref, wt_final$windown)
wt_final$Strain<- rep("WT", nrow(wt_final))


all_final<- rbind(wt_final, ko_final)


for (i in seq_along(unique(all_final$reference))) { 
  subs<- subset(all_final, all_final$reference == unique(all_final$reference)[i])
  pdf(file=paste(unique(all_final$reference)[i],"15nt_window.pdf",sep="."),height=10,width=25,onefile=FALSE)
  print(ggplot(subs, aes(x=variable, y=value, group=Strain)) +
    geom_line(aes(color=Strain), size=2)+
    geom_point(aes(color=Strain))+
    ggtitle(paste(unique(all_final$reference)[i]))+
    xlab("Relative position") +
    ylab("Mean Event Level")+
    theme(axis.text.x = element_text(face="bold", color="black",size=40),
      axis.text.y = element_text(face="bold", color="black", size=40),
      plot.title = element_text(color="black", size=40, face="bold.italic",hjust = 0.5),
      axis.title.x = element_text(color="black", size=40, face="bold"),
      axis.title.y = element_text(color="black", size=40, face="bold"),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black", size=1),
      panel.grid.major = element_line(colour = "black", size=0.01, linetype="dashed"),
      legend.key.size = unit(1.5, "cm"),
      legend.title = element_text(color = "black", size = 30,face="bold"),
      legend.text = element_text(color = "black", size=25)))
    dev.off()
}



for (i in seq_along(unique(all_final$reference))) { 
  subs<- subset(all_final, all_final$reference == unique(all_final$reference)[i])
  png(file=paste(unique(all_final$reference)[i],"15nt_window.png",sep="."),height=800,width=2400)
  print(ggplot(subs, aes(x=variable, y=value, group=Strain)) +
    geom_line(aes(color=Strain), size=2)+
    geom_point(aes(color=Strain))+
    ggtitle(paste(unique(all_final$reference)[i]))+
    xlab("Relative position") +
    ylab("Mean Event Level")+
    theme(axis.text.x = element_text(face="bold", color="black",size=40),
          axis.text.y = element_text(face="bold", color="black", size=40),
      plot.title = element_text(color="black", size=40, face="bold.italic",hjust = 0.5),
      axis.title.x = element_text(color="black", size=40, face="bold"),
      axis.title.y = element_text(color="black", size=40, face="bold"),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black", size=1),
      panel.grid.major = element_line(colour = "black", size=0.1),
      legend.key.size = unit(1.5, "cm"),
      legend.title = element_text(color = "black", size = 30,face="bold"),
            legend.text = element_text(color = "black", size=25)))
    dev.off()
}