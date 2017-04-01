library(png)

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

n=4473
df.distr<-
data.frame(col1=rep(0,n),
           col2=rep(0,n),
           col3=rep(0,n),
           col4=rep(0,n),
           col5=rep(0,n),
           col6=rep(0,n),
           col7=rep(0,n),
           col8=rep(0,n),
           col9=rep(0,n),
           col10=rep(0,n),
           col11=rep(0,n),
           col12=rep(0,n),
           col13=rep(0,n),
           col14=rep(0,n),
           col15=rep(0,n),
           col16=rep(0,n))

for(i in 1:n){
  img <- readPNG(paste0("board-bitmap.",i,".png")) 
  img <- img*255
  flat.img <- img[,,1]+img[,,2]+img[,,3]
  distr <- table(c(flat.img))%>% as.vector()
  if(length(distr)==16){
    df.distr[i,]=distr
  }
  if(i%%100==0){
    print(i)
  }
}

color.matrix=color.matrix[order(rowSums(color.matrix)),]

df.distr %>% 
  gather(key="variable",value="value",col1:col16) %>% 
  mutate(variable=factor(variable,levels=paste0("col",1:16))) %>% 
  mutate(idx=rep(1:n,16)) %>% 
  mutate(value=value/1000^2) %>% 
  ggplot(aes(x=idx,y=value,group=variable))+geom_area(aes(fill=variable))+
  scale_fill_manual(values=apply(color.matrix,1,function(x) rgb(x[1],x[2],x[3],255,maxColorValue = 255)),name="")+
  theme_tufte()+
  theme(legend.position="bottom")+
  guides(fill = guide_legend(nrow = 2))+
  labs(x="Time",y="Frequencies",title="Color Distribution of r/place",subtitle="from March 31 10:41pm to April 1 12:36am CEST")
ggsave("colordistr.png")
