###################################################################
## pU STOICHIOMETRY USING CURRENT INTENSITY 15-mers VERSION 2
## April 2020, Eva M. Novoa modified from Oguzhan's 
###################################################################

# 1. Read data and clean up (WT and KO)
########################################

library(stringr)
library(ggplot2)
library(reshape2)
library(grid)
library(gridExtra)
library(ggExtra)

args <- commandArgs(trailingOnly = TRUE)
input1 <- args[1] #1st variable
input2 <- args[2] #1st variable

# Input files
wt_input<- read.delim(input2)
ko_input<- read.delim(input1)


# Clean files
clean_input<-function(wt,label) {
	event_level_mean<- str_split_fixed(wt$mean_current, ":" ,15)
	wt_2<- cbind(wt, event_level_mean)
	wt_2$mean_current<-NULL
	wt_2$windown <- NULL
	wt_2$kmer <- NULL
	wt_2$ref<- NULL
	wt_2$sample<- rep(label, nrow(wt_2))
	wt_2[,-c(1,17)] <- data.frame(sapply(wt_2[,-c(1, 17)], function(x) as.numeric(as.character(x)))) #MAKE NUMERIC
	wt_2$read<- as.character(wt_2$read)
	wt_2<- wt_2[!duplicated(wt_2$read),]
	wt_2_omit<- na.omit(wt_2)
	#wt_3_omit<- melt(wt_2_omit)
	return(wt_2_omit)
}

wt<-clean_input(wt_input,"WT")
ko<-clean_input(ko_input,"KO")


# Merge each with WT

merge_with_wt<-function(wt_3_omit,sn34_3_omit) {
	wt_sn34_2880_omit<- rbind(wt_3_omit, sn34_3_omit)
	return(wt_sn34_2880_omit)
}

dat<-merge_with_wt(wt,ko)

#save(dat,file="dat.Rdata")


load("dat.Rdata")



# 2. PLOT 
########################################

plot_perRead_intensities<- function(wt_sn34, name) {
	wt_sn34_melt<- melt(wt_sn34)
	wt_sn34_melt$unique<- paste(wt_sn34_melt$read, wt_sn34_melt$sample)
	pdf(file= paste(name,".pdf",sep=""),height=5,width=15,onefile=FALSE)
	print(ggplot(wt_sn34_melt, aes(x=variable, y=value, group=unique)) +
	geom_line(aes(color=as.factor(sample)),alpha=0.025)
	#+ stat_summary(aes(y = value,group=sample, color=sample), fun.y=mean,geom="line",size=2)
	+theme_bw())
	dev.off()
}	

plot_perRead_intensities(dat,"position.per_read")

plot_Mean_intensities<- function(wt_sn34, name) {
	wt_sn34_melt<- melt(wt_sn34)
	wt_sn34_melt$unique<- paste(wt_sn34_melt$read, wt_sn34_melt$sample)
	#pdf(file= paste(name,".pdf",sep=""),height=5,width=15,onefile=FALSE)
	print(ggplot(wt_sn34_melt, aes(x=variable, y=value, group=unique)) +
	geom_line(aes(color=as.factor(sample)),alpha=0.00)
	+ stat_summary(aes(y = value,group=sample, color=sample,alpha=0.5), fun.y=mean,geom="line",size=2)
	+theme_bw())
	#dev.off()
}	

plot_Mean_intensities(dat,"MEAN.position")


