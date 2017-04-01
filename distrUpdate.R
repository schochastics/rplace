#update the color distribution
distr.update=function(nold,n){
  nold=nold+1
  load("col.distr.RData")
  for(i in nold:n){
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
    labs(x="Time",y="Frequencies",title="Color Distribution of r/place")
  ggsave("colordistribution.png")
  save(list=c("df.distr"),file = "col.distr.RData")
}
