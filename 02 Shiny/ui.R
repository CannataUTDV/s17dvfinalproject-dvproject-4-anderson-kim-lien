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
      menuItem("Obesity Boxplot", tabName = "boxplot", icon = icon("dashboard")),
      menuItem("Obesity Histogram", tabName = "histogram", icon = icon("dashboard")),
      menuItem("Obesity Scatterplot", tabName = "scatterplot", icon = icon("dashboard")),
      menuItem("Obesity Crosstabs", tabName = "crosstabs", icon = icon("dashboard")),
      menuItem("Risk Factors of Obesity Barcharts", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(    
    tabItems(
      tabItem(tabName = "boxplot",
              tabsetPanel(
                tabPanel("Data","This data is a join of the population_byname and the Adult_Adolescent_Obesity data",DT::dataTableOutput("boxplotData")),
                tabPanel("Boxplot",plotlyOutput("boxplot",height=1000))
                )),
      
      tabItem(tabName = "histogram",
              tabsetPanel(
                tabPanel("Data","This data is a join of the population_byname and the Adult_Adolescent_Obesity data",DT::dataTableOutput("histogramData")),
                tabPanel("Histogram",plotlyOutput("histogram",height=1000))
              )),
      
      tabItem(tabName = "scatterplot",
              tabsetPanel(
                tabPanel("Data","This data is a join of the Adult_Adolscent_Obesity data and the LeadingCOD table",hr(),DT::dataTableOutput("scatterplotData")),
                tabPanel("Scatterplot",hr(),plotlyOutput("scatterplot",height=1000))
                )),
      
      tabItem(tabName = "crosstabs",
              tabsetPanel(
                tabPanel("Data","this data is a join of the Adult_Adolescent_Obesity data and the statetable data", DT::dataTableOutput("crosstabData"  )),
                tabPanel("Obesity by region Crosstab","Crosstab of obesity by state grouped by region",plotOutput("crosstabplot",height=2000))
                )),
      
      tabItem(tabName = "barchart",
              tabsetPanel(tabPanel("Data", "This data is a join of the Adult_Adolescent_Obesity data and the CHSI Risk Factors data",DT::dataTableOutput("barchartData1")),
                tabPanel("Obesity & Risk Factor Data", "Barchart Obesity Rates & Risk Factor Data by State",plotOutput("barchartplot1",height=2000)),
                tabPanel("Top 10 Obesity Rates",plotlyOutput("barchartplot2"),hr(),plotlyOutput("barchartplot3"),hr(),plotlyOutput("barchartplot4"),hr(),plotlyOutput("barchartplot5"),hr(),plotlyOutput("barchartplot6"))))
    )
  )
)