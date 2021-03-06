load("col.change.RData")
load("col.distr.RData")
library(tidyverse)
library(ggthemes)
library(lubridate)
library(Cairo)
library(scales)

n=nrow(df.distr)

#colors used as rgb code
color.matrix=matrix(
  c(255, 255, 255,
    228, 228, 228,
    136, 136, 136,
    34, 34, 34,
    255, 167, 209,
    229, 0, 0,
    229, 149, 0,
    160, 106, 66,
    229, 217, 0,
    148, 224, 68,
    2, 190, 1,
    0, 211, 221,
    0, 131, 199,
    0, 0, 234,
    207, 110, 228,
    130, 0, 128),16,3,byrow=TRUE)
color.flat=rowSums(color.matrix)
color.matrix=color.matrix[order(rowSums(color.matrix)),]

#time variable: the first 348 entries are 20 sec snapshots. after that every 10
start=ymd_hms("2017-03-31 20:39:00",tz = "CEST")+seconds(21*(1:348))
end=ymd_hms("2017-03-31 22:41:00",tz = "CEST")+seconds(11*(1:(n-348)))
all=c(start-hours(2),end-hours(2)) #using c() somehow adds two hours oO
time.vec<-rep(all,16)

#area chart -----
df.distr %>% 
  gather(key="variable",value="value",col1:col16) %>% 
  mutate(variable=factor(variable,levels=paste0("col",1:16))) %>% 
  mutate(idx=rep(1:n,16)) %>%
  # mutate(time=rep(ymd_hms("2017-03-31 22:41:00",tz = "CEST")+seconds(11*(1:n)),16)) %>% 
  mutate(time=time.vec) %>% 
  mutate(value=value/1000^2) %>% 
  ggplot(aes(x=time,y=value,group=variable))+geom_area(aes(fill=variable))+
  scale_fill_manual(values=apply(color.matrix,1,function(x) rgb(x[1],x[2],x[3],255,maxColorValue = 255)),name="",
                    labels=apply(color.matrix,1,function(x) paste(x[1],x[2],x[3],sep=",")))+
  annotate("rect",xmin=min(time.vec),xmax=max(time.vec),ymin=0,ymax=1,fill=NA,col="black")+
  theme_tufte()+
  theme(legend.position="bottom",
        legend.text = element_text(size=6))+
  guides(fill = guide_legend(nrow = 2))+
  labs(x="Time",y="Fraction of total",title="Color Distribution of r/place",
       subtitle=paste0("from ",min(time.vec)," to ",max(time.vec), " CEST"))
ggsave("colordistribution.png",type = "cairo-png")

#line chart ----
df.distr %>% 
  gather(key="variable",value="value",col1:col16) %>% 
  mutate(variable=factor(variable,levels=paste0("col",1:16))) %>% 
  mutate(idx=rep(1:n,16)) %>% 
  # mutate(time=rep(ymd_hms("2017-03-31 22:41:00",tz = "CEST")+seconds(11*(1:n)),16)) %>% 
  mutate(time=time.vec) %>% 
  mutate(value=value/1000^2) %>% 
  dplyr::filter(variable!="col16") %>% 
  ggplot(aes(x=time,y=value,group=variable))+geom_line(aes(col=variable))+
  scale_color_manual(values=apply(color.matrix,1,function(x) rgb(x[1],x[2],x[3],255,maxColorValue = 255)),name="",
                    labels=apply(color.matrix,1,function(x) paste(x[1],x[2],x[3],sep=",")))+
  theme_tufte()+
  theme(legend.position="bottom",
        legend.text = element_text(size=6))+
  guides(color = guide_legend(nrow = 2))+
  labs(x="Time",y="Fraction of total",title="Color Distribution of r/place",
       subtitle=paste0("from ",min(time.vec)," to ",max(time.vec), " CEST"))
ggsave("colordistribution_line.png",type = "cairo-png")

# changes heatmap ----
data.frame(x=rep(1:1000,1000),y=rep(1:1000,each=1000),z=c(change)) %>% 
  ggplot(aes(y,x))+geom_tile(aes(fill=log(z+1)))+scale_y_reverse()+
  scale_fill_gradient(low="black",high="#FFD700",name="log number \nof changes")+
  theme_tufte()
ggsave("heatmap.png",type = "cairo-png")

data.frame(x=rep(1:1000,1000),y=rep(1:1000,each=1000),z=c(survive)) %>% 
  ggplot(aes(y,x))+
  # geom_tile(aes(fill=log(z+1)))+
  geom_tile(aes(fill=z))+
  scale_y_reverse()+
  scale_fill_gradient(low="black",high="#FFD700",name="frames since \nlast change")+
  theme_tufte()
ggsave("heatmap_survive.png",type = "cairo-png")

#final color distribution-----
