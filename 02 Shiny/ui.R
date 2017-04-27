#ui.R
require(shiny)
require(shinydashboard)
require(DT)


dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Adult & Adolescent Obesity", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(    
    tabItems(
      tabItem(tabName = "barchart",
              tabsetPanel(
                tabPanel("Obesity by Region", "Barchart of Adolescent & Adult Obesity Rates by Region", hr(),"Black = Average Obesity Rate, Red = Average Obesity Rate per Region",plotOutput("plot1")),
                #visualization 2 ui data
                 tabPanel("top 5 Obese states", "Barchart of the top 5 obese states", hr(),"Red = Number of obese citizens in the state",plotOutput("plot2")),
                tabPanel("Lowest 3 Obesity Rates by Region", "Barchart of Lowest 3 Obesity Rates in Each Region", hr(), "Black = Average Obesity Rate, Red = Average Obesity Rate per Region", plotOutput("plot3"))
         )
      )
    )
  )
)