# server.R
require(ggplot2)
require(dplyr)
require(tidyr)
require(shiny)
require(shinydashboard)
require(data.world)
require(readr)
require(DT)
require(leaflet)
require(plotly)
require(lubridate)

#begin map query

map1 <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT a.Age, a.Value, a.Location, b.State, b.Latitude, b.Longitude,
  case when a.Age = 'Adult' then (a.Value - 28.9)
  else (Value - 13.7)
  end as Adjusted
  from Adult_Adolescent_Obesity a join state_coordinates b on (a.Location = b.State)
  where a.Age = 'Adult'
  group by a.Location"
)
  
mdf <- map1

#end map query
#begin boxplot query
boxplot1 <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Age as Age, Sum(Adult_Adolescent_Obesity.Value) as Value, Adult_Adolescent_Obesity.Location as Location
  from Adult_Adolescent_Obesity
  group by Location, Age
"
)

#end boxplot query

#begin histogram query

histogram1 <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT CI_Max_Fruit_Veg as FruitsVegs FROM RiskFactors
  "
)

#end histogram query

#begin scatterplot query

scatterplot1 <-query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT avg(a.D_Wh_HeartDis), a.CHSI_State_Name, b.Age,avg(b.Value) as Value,b.Location
  FROM leadingCOD a join Adult_Adolescent_Obesity b
  ON (a.CHSI_State_Name = b.Location)
  group by b.Location
  "
) 

#end scatterplot query

#begin barchart data
barchartdf1 <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.Diabetes) as Avg_Diabetes, avg(RiskFactors.Few_Fruit_Veg) as Avg_FewFruitVeg, avg(RiskFactors.High_Blood_Pres) as Avg_HighBloodPres, avg(RiskFactors.No_Exercise) as Avg_NoExercise, avg(RiskFactors.Smoker) as Avg_Smoker
from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location
  where Location != 'District of Columbia'
  group by Location
  order by Location"
)




barchartdf2<-gather(barchartdf1,type,value,-Location)

barchartdf4 = barchartdf2 %>% dplyr::group_by(type)%>%dplyr::filter(Location!='Alaska') %>% dplyr::summarise(KPI_barchart=mean(value))



KPI_Diabetes=dplyr::filter(barchartdf4,type=='Avg_Diabetes')%>%dplyr::select(KPI_barchart)
KPI_FewFruitVeg=dplyr::filter(barchartdf4,type=='Avg_FewFruitVeg')%>%dplyr::select(KPI_barchart)
KPI_HighBloodPres=dplyr::filter(barchartdf4,type=='Avg_HighBloodPres')%>%dplyr::select(KPI_barchart)
KPI_NoExercise=dplyr::filter(barchartdf4,type=='Avg_NoExercise')%>%dplyr::select(KPI_barchart)
KPI_Smoker=dplyr::filter(barchartdf4,type=='Avg_Smoker')%>%dplyr::select(KPI_barchart)

barchartdiabetes<- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.Diabetes) as Avg_Diabetes, 
case 
when avg(RiskFactors.Diabetes) < ? then '02 Low' 
else '01 High' 
end As kpi
from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location 
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location",
  queryParameters = KPI_Diabetes
) 

barchartfewfruitveg<- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.Few_Fruit_Veg) as Avg_FewFruitVeg, 
  case 
  when avg(RiskFactors.Few_Fruit_Veg) < ? then '02 Low' 
  else '01 High' 
  end As kpi
  from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location 
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location",
  queryParameters = KPI_FewFruitVeg
) 

barcharthighbloodpres<- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.High_Blood_Pres) as Avg_HighBloodPres, 
  case 
  when avg(RiskFactors.High_Blood_Pres) < ? then '02 Low' 
  else '01 High' 
  end As kpi
  from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location 
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location",
  queryParameters = KPI_HighBloodPres
) 

barchartnoexercise<- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.No_Exercise) as Avg_NoExercise, 
  case 
  when avg(RiskFactors.No_Exercise) < ? then '02 Low' 
  else '01 High' 
  end As kpi
  from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location 
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location",
  queryParameters = KPI_NoExercise
) 

barchartsmoker<- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.Smoker) as Avg_Smoker, 
  case 
  when avg(RiskFactors.Smoker) < ? then '02 Low' 
  else '01 High' 
  end As kpi
  from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location 
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location",
  queryParameters = KPI_Smoker
) 


#end barchart query

#begin crosstab query
crosstab1 <-query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT a.census_region_name, a.fips_state, b.Age,b.Value,b.Location,
      case 
  when (b.Age='Adolescent' AND b.Value<=13.7) or (b.Age='Adult' AND b.Value<=28.9) THEN '02 Low'
  ELSE '01 High'
  end as kpi
  FROM statetable a join Adult_Adolescent_Obesity b
  ON (a.name = b.Location)
  order by a.census_region_name"
 ) 

#end crosstab query

#############shinyserver function begin##############



shinyServer(function(input, output) {

#begin map tab
  output$mapData1 <- renderDataTable({DT::datatable(map1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE))
  })
  
  output$mapPlot2 <- renderLeaflet({
    leaflet(width = 400, height = 800) %>%
      addTiles() %>%
      setView(lng=-98.35,lat=39.5,zoom=4) %>%
      addMarkers(lng = map1$Longitude,lat = map1$Latitude,
                 options = markerOptions(riseOnHover=TRUE),
                 popup = as.character(paste(map1$Location,", ","State Obesity Rate - National Average: ",map1$Adjusted)))
    })
  

#end map tab
  
#begin boxplot tab
  output$boxplotData <- renderDataTable({DT::datatable(boxplot1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE))
  })
  
  output$boxplot <-renderPlotly({p <- ggplot(boxplot1) + 
    theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
    theme(axis.text.y=element_text(size=16, hjust=0.5)) +
    geom_boxplot(aes(x=Age, y=Value, group=Age, colour=Location), size=2)+
    geom_point(aes(x=Age, y=Value, colour=Location), size=2)
    ggplotly(p)
  })
  
#end boxplot tab
  
#begin histogram tab
  output$histogramData <- renderDataTable({DT::datatable(histogram1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE))
  })
  
  output$histogram <- renderPlotly({p <- ggplot(histogram1) +
    geom_histogram(aes(x=FruitsVegs)) +
    theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))
    ggplotly(p)

  })
#end histogram tab
  
#begin scatterplot tab
  output$scatterplotData <- renderDataTable({DT::datatable(scatterplot1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  output$scatterplot <-renderPlotly({p <- ggplot(scatterplot1) + 
    theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
    theme(axis.text.y=element_text(size=16, hjust=0.5)) +
    geom_point(aes(x=Value, y=D_Wh_HeartDis, colour=Location), size=2)
    ggplotly(p)
  })
  
#end scatterplot tab
  
  
#begin crosstab tab
  output$crosstabData <- renderDataTable({DT::datatable(crosstab1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  
  output$crosstabplot<-renderPlot({ggplot(crosstab1) + 
  theme(axis.text.y=element_text(size=10, hjust=0.5))+
  geom_text(aes(x=Age,y=census_region_name,label=Value))+
  geom_tile(aes(x=Age, y=census_region_name, fill=kpi), alpha=0.50)
  })
  
#end crosstab tab
  
  
#begin barchart tab
  output$barchartData1 <- renderDataTable({DT::datatable(barchartdf1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })

  output$barchartplot1 <- renderPlot({ggplot(barchartdf2, aes(type,value)) + geom_bar(aes(fill=type),stat="identity",position="dodge") + facet_wrap(~Location,ncol=5) + theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  })
  
  output$barchartplot2 <- renderPlotly({
    p2 <-ggplot(barchartdiabetes) + geom_col(aes(x = Location, y=Avg_Diabetes,fill=kpi))+geom_point(aes(x=Location,y=Avg_Obesity))
    ggplotly(p2)
  })
 
  output$barchartplot3 <- renderPlotly({
    p3 <-ggplot(barchartfewfruitveg) + geom_col(aes(x = Location, y=Avg_FewFruitVeg,fill=kpi))+geom_point(aes(x=Location,y=Avg_Obesity))
    ggplotly(p3)
  })
  
  output$barchartplot4 <- renderPlotly({
    p4 <-ggplot(barcharthighbloodpres) + geom_col(aes(x = Location, y=Avg_HighBloodPres,fill=kpi))+geom_point(aes(x=Location,y=Avg_Obesity))
    ggplotly(p4)
  })
  
  output$barchartplot5 <- renderPlotly({
    p5 <-ggplot(barchartnoexercise) + geom_col(aes(x = Location, y=Avg_NoExercise,fill=kpi))+geom_point(aes(x=Location,y=Avg_Obesity))
    ggplotly(p5)
  })
  
  output$barchartplot6 <- renderPlotly({
    p6 <-ggplot(barchartsmoker) + geom_col(aes(x = Location, y=Avg_Smoker,fill=kpi))+geom_point(aes(x=Location,y=Avg_Obesity))
    ggplotly(p6)
  })
})

#end barchart tab 
#end
