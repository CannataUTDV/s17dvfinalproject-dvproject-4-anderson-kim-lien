#ui.R
require(shiny)
require(shinydashboard)
require(DT)
require(leaflet)
require(plotly)


dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Boxplot", tabName = "boxplot", icon = icon("dashboard")),
      menuItem("Histogram", tabName = "histogram", icon = icon("dashboard")),
      menuItem("Scatterplot", tabName = "scatterplot", icon = icon("dashboard")),
      menuItem("Crosstab", tabName = "crosstabs", icon = icon("dashboard")),
      menuItem("Barcharts", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(    
    tabItems(
      tabItem(tabName = "boxplot",
              tabsetPanel(
                tabPanel("Data","This data is a join of the population_byname and the Adult_Adolescent_Obesity data",hr(),DT::dataTableOutput("boxplotData")),
                tabPanel("Boxplot","This boxplot covers information about obesity rates over states",hr(),plotlyOutput("boxplot",height=1000))
                )),
      
      tabItem(tabName = "histogram",
              tabsetPanel(
                tabPanel("Data","This data is a join of the population_byname and the Adult_Adolescent_Obesity data",hr(),DT::dataTableOutput("histogramData")),
                tabPanel("Histogram","This histogram visualizes data of the death counts vs the fruits and vegetables consumption by state",hr(),plotlyOutput("histogram",height=1000))
              )),
      
      tabItem(tabName = "scatterplot",
              tabsetPanel(
                tabPanel("Data","This data is a join of the Adult_Adolscent_Obesity data and the LeadingCOD table",hr(),DT::dataTableOutput("scatterplotData")),
                tabPanel("Scatterplot","This scatterplot analyzes the correlation between heart disease and obesity by state",hr(),plotlyOutput("scatterplot",height=1000))
                )),
      
      tabItem(tabName = "crosstabs",
              tabsetPanel(
                tabPanel("Data","this data is a join of the Adult_Adolescent_Obesity data and the statetable data",hr(), DT::dataTableOutput("crosstabData"  )),
                tabPanel("Crosstab","Crosstab of obesity by state grouped by region",hr(),plotOutput("crosstabplot",height=2000))
                )),
      
      tabItem(tabName = "barchart",
              tabsetPanel(tabPanel("Data", "This data is a join of the Adult_Adolescent_Obesity data and the CHSI Risk Factors data",hr(),DT::dataTableOutput("barchartData1")),
                tabPanel("Obesity & Risk Factor Data", "Barchart Obesity Rates & Risk Factor Data by State",hr(),plotOutput("barchartplot1",height=2000)),
                tabPanel("Top 10 Obesity Rates","Barcharts of the top 10 states with obesity and associated risk factors",hr(),plotlyOutput("barchartplot2"),hr(),plotlyOutput("barchartplot3"),hr(),plotlyOutput("barchartplot4"),hr(),plotlyOutput("barchartplot5"),hr(),plotlyOutput("barchartplot6"))))
    )
  )
)