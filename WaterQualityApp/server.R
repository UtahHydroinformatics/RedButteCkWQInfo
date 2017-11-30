
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output) {
  output$selected_var <- renderText({
    paste('Water Quality Data of Red Butte Creek at',input$site,'between',input$dates[1],'and',input$dates[2])
  })
output$chlplot <- renderPlot({
  plotdata <- subset(RBdata,SiteID==input$site &
                       DateTime >= input$dates[1] &
                       DateTime<= input$dates[2])
  ggplot(data=plotdata,aes(x=plotdata$WaterTemp_EXO,y=plotdata[,input$param]))+geom_point()
  
})


output$wqplot <- renderPlot({
  plotdata <- subset(RBdata,SiteID==input$site &
                       DateTime >= input$dates[1] &
                       DateTime<= input$dates[2])
  ggplot(data=plotdata,aes(x=plotdata$DateTime,y=plotdata[,input$param]))+geom_point()
  
})  

output$boxplot <- renderPlot({
  plotdata <- subset(RBdata, SiteID==input$site &
                       DateTime >= input$dates[1] &
                       DateTime<= input$dates[2])
  ggplot(data=plotdata,aes(x=plotdata$SiteID, y=plotdata[,input$param], fill=plotdata$SiteID))+
    geom_boxplot()+ labs(title="Box Plot of Selected WQ Parameter")
 
})


output$sitemap <- renderLeaflet({
  labels= c("Knowlton Fork", "RB Gate", "RB 900W", "RB_1300E", "Foothill Drive", "RB Reservoir")
  longs=  c(-111.765472, -111.817025,-111.9176, -111.854441, -111.833722, -111.806669 )
  lats=   c(40.809522, 40.774228, 40.7416, 40.744995, 40.757225, 40.779602)
    leaflet() %>%
    addTiles() %>%
    addMarkers(lng=longs, lat=lats, popup = labels )
  
})  

##Variable Summaries
summod <- reactive({
 plotdata <- subset(RBdata,SiteID==input$site &
                     DateTime >= input$dates[1] &
                     DateTime<= input$dates[2])
  summary(plotdata[,c(input$param)])
  #statsummary <- summary(stat)
  #return(statsummary)
})

output$paramsummary <- renderPrint({
  #paste("Summary of the Selected WQ Parameter",input$param," during this timeframe:",summod())
  #summary(plotdata [,c(input$param)])
  summod()
  })

##Correlation between Temperature and other parameter
chlmod <- reactive({
  plotdata <- subset(RBdata,SiteID==input$site &
                       DateTime >= input$dates[1] &
                       DateTime<= input$dates[2])
  mod <- lm(plotdata$WaterTemp_EXO~plotdata[,input$param])
  modsummary <- summary(mod)
  return(modsummary)
})

output$modelresults <- renderText({
  paste("R-Squared between Temperature and",input$param," during this timeframe:",chlmod()$r.squared)
})


})
