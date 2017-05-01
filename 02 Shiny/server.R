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

barchartdf3 <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-final-project", type="sql",
  query="SELECT Adult_Adolescent_Obesity.Location as Location, avg(Adult_Adolescent_Obesity.Value) as Avg_Obesity, avg(RiskFactors.Diabetes) as Avg_Diabetes, avg(RiskFactors.Few_Fruit_Veg) as Avg_FewFruitVeg, avg(RiskFactors.High_Blood_Pres) as Avg_HighBloodPres, avg(RiskFactors.No_Exercise) as Avg_NoExercise, avg(RiskFactors.Smoker) as Avg_Smoker
from RiskFactors left join Adult_Adolescent_Obesity on RiskFactors.CHSI_State_Name=Adult_Adolescent_Obesity.Location
  where Location!='District of Columbia'
  group by Location
  having avg(Adult_Adolescent_Obesity.Value)>25.0
  order by Location"
) 


shinyServer(function(input, output) {
  
  output$barchartData1 <- renderDataTable({DT::datatable(barchartdf1,rownames = FALSE,extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })

  output$barchartplot1 <- renderPlot({ggplot(barchartdf2, aes(type,value)) + geom_bar(aes(fill=type),stat="identity",position="dodge") + facet_wrap(~Location,ncol=5) + theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  })
  
  output$barchartplot2 <- renderPlotly({
    p1 <-ggplot(barchartdf3, aes(x=Location,y = Avg_Diabetes)) +geom_bar(stat = "identity") +geom_line(aes(x,y,linetype=avgdiabetes),avgdiabetes)
    ggplotly(p1)
  })
 
})
