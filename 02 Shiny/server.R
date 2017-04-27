# server.R
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(data.world)
require(readr)
require(DT)

region <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-project-6", type="sql",
  query="select AVG(Adult_Adolescent_Obesity.Value) as avg_obesity, Adult_Adolescent_Obesity.Age as Age, statetable.census_region_name as Region
from Adult_Adolescent_Obesity left join statetable on (Adult_Adolescent_Obesity.Location=statetable.name)
group by statetable.census_region_name, Age
  "
)  
#Visualization 2 Query
population <- query(
  data.world(propsfile = "www/.data.world"),
  dataset = "christinalien/s-17-dv-project-6",type="sql",
  query="select a.AreaName,b.Age,b.Value,a.adolescentpop,a.adultpop,b.Location,
  case
  when b.Age ='Adult' Then ((b.Value/100)*a.adultpop)
  else ((b.Value/100)*a.adolescentpop)
  end as obesepop
  from population_byage a join Adult_Adolescent_Obesity b
  ON (a.AreaName = b.Location)
  where case when b.Age = 'Adult' then ((b.Value/100)*a.adultpop) >= 3963019
  else ((b.Value/100)*a.adolescentpop) >= 102422
  end
  group by a.AreaName,b.Age"
                
  ) # %>% View()

bottom <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="christinalien/s-17-dv-project-6", type="sql",
  query="select AVG(Adult_Adolescent_Obesity.Value) as avg_obesity, statetable.abbreviation as State, statetable.census_region_name as Region
  from Adult_Adolescent_Obesity left join statetable on (Adult_Adolescent_Obesity.Location=statetable.name)
  group by statetable.census_region_name, Age
  "
)

#create window average data
region2 = region %>% group_by(Region) %>% summarize(window_avg_rate = mean(avg_obesity))
region3 = dplyr::inner_join(region,region2, by="Region")

#create window average data
bottom2 = bottom %>% group_by(Region) %>% summarize(window_avg_rate = mean(avg_obesity))
bottom3 = dplyr::left_join(bottom,bottom2, by="Region")

#View(region3)

scaleFUN <- function(x) sprintf("%.2f", x)


shinyServer(function(input, output) {
  
  output$plot1 <- renderPlot({ggplot(region3, aes(x=Age, y=avg_obesity)) +
      theme(axis.text.x=element_text(angle=0, size=12, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=12, hjust=0.5)) +
      geom_bar(stat = "identity") + 
      facet_wrap(~Region, ncol=1) + 
      coord_flip() + 
     
      geom_text(mapping=aes(x=Age, y=avg_obesity, label=round(avg_obesity,digits=2)),colour="black", hjust=-.5) +
      # Add reference line with a label.
      geom_hline(aes(yintercept = (window_avg_rate)), color="red") +
      geom_text(aes( -1, window_avg_rate, label = round(window_avg_rate,digits=2), vjust = -.5, hjust = -.25), color="red")
  })

  #visualization 2 plot code  
  output$plot2 <- renderPlot({ggplot(population, aes(x=AreaName, y=obesepop)) +
      theme(axis.text.x=element_text(angle=0, size=12, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=12, hjust=0.5)) +
      geom_bar(stat = "identity") + 
      facet_wrap(~Age, ncol=1) + 
      
      geom_text(mapping=aes(x=AreaName, y=obesepop, label=round(obesepop,digits=0)),colour="red", vjust=0)

  })
  output$plot3 <- renderPlot({ggplot(bottom3, aes(x=State, y=avg_obesity)) +
      theme(axis.text.x=element_text(angle=0, size=12, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=12, hjust=0.5)) +
      geom_bar(stat = "identity") + 
      facet_wrap(~Region, ncol=1) + 
      coord_flip() + 
      
      geom_text(mapping=aes(x=State, y=avg_obesity, label=round(avg_obesity,digits=2)),colour="black", hjust=-.5) +
      # Add reference line with a label.
      geom_hline(aes(yintercept = (window_avg_rate)), color="red") +
      geom_text(aes( -1, window_avg_rate, label = round(window_avg_rate,digits=2), vjust = -.5, hjust = -.25), color="red")
  })
  
})
