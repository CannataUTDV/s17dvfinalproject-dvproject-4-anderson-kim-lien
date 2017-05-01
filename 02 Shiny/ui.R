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
                tabPanel("Title 1"))), 
      
      tabItem(tabName = "histogram",
              tabsetPanel(
                tabPanel("Title 2"))),
      
      tabItem(tabName = "scatterplot",
              tabsetPanel(
                tabPanel("Title 3"))),
      
      tabItem(tabName = "crosstabs",
              tabsetPanel(
                tabPanel("Title 4"))),
      
      tabItem(tabName = "barchart",
              tabsetPanel(tabPanel("Data", "This data is a join of the Adult_Adolescent_Obesity data and the CHSI Risk Factors data",DT::dataTableOutput("barchartData1")),
                tabPanel("Obesity & Risk Factor Data", "Barchart Obesity Rates & Risk Factor Data by State",plotOutput("barchartplot1",height=2000)),
                tabPanel("Top 10 Obesity Rates",plotlyOutput("barchartplot2"),hr(),plotlyOutput("barchartplot3"),hr(),plotlyOutput("barchartplot4"),hr(),plotlyOutput("barchartplot5"),hr(),plotlyOutput("barchartplot6"))))
    )
  )
)