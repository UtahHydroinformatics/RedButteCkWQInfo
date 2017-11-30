
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(theme="bootstrap3.css",

  # Application title
  titlePanel(h1("Water Quality App for Red Butte Creek, Utah")),
  help("Developed By: "),
  tags$img(src="logo_RB.jpg", height=80, width=80),
  # Sidebar with user input controls
  sidebarLayout(position="left",
    sidebarPanel(selectInput(inputId='site', 
                             label=h3('Site Selection'), 
                             choices=unique(RBdata$SiteID), 
                             selected = NULL, 
                             multiple = FALSE,
                             selectize = TRUE, 
                             width = NULL, 
                             size = NULL),
                 
                 radioGroupButtons(inputId = 'param', 
                                   label = h3("Selection of WQ Parameter"), choices = c("Temp_C" = "WaterTemp_EXO", 
                                                                "DO_mg_L"= "ODO", "  pH  " = "pH", 
                                                                "Turbidity"= "TurbAvg"), checkIcon = list(yes = tags$i(class = "fa fa-check-square", 
                                                                                                           style = "color: steelred"), 
                                                                                              no = tags$i(class = "fa fa-square-o", 
                                                                                               style = "color: steelred"))),
                 
                 
                 #checkboxGroupInput(inputId = 'bpsite', 
                  #                  label = h3("Select Site for Boxplot"), choices = list("Knowlton Fork"=1,"RB Gate"=2,"RB 900W"=3,"RB 1300E"=4,"Foothill Dr"=5, "RB Reservoir"=6, direction = "vertical")),
                 
                 
    dateRangeInput("dates", label = h3("Date range")),
                 
    helpText(h6("Note: This data view will show observations of specified WQ parameters",
                          "recorded by iUTAH GAMUT Network icluding",
                          "the statistical summary and correlation between temperature and other parameters."))
                  ),
                

    # Show outputs, text, etc. in the main panel
    mainPanel(
      textOutput("selected_var"),
      h5(("WQ Data Visualization"),plotOutput("wqplot")),
      h5(("Box Plot"),
         plotOutput("boxplot")),
      h5(("Statistical Summary of Selected Parameter"), verbatimTextOutput("paramsummary")),
      h5(("Correlation Between Temperature and Selected WQ Parameter"),plotOutput("chlplot")),
      h5(("Correlation result"),textOutput("modelresults")),
      h5(("Location of Sites WQ Monitoring Sites"),leafletOutput("sitemap"))
      
      )
  )
))