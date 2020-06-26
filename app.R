library(tidyverse)   #incl tidyr, readr, dplyr etc
library(ggplot2)
library(ggthemes)
library(shiny)

# Load data
load(".Rdata")

# Define UI
ui <- fluidPage(
    
    titlePanel("GeoNames Entities in Zurich"),

    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "Feature",
                        label = h3("Select a GeoNames feature:"), 
                        choices = levels(featCodeZH$featName),
                        multiple = FALSE,
            ),
            hr()
        ),

        
    mainPanel(plotOutput("plot"))
    )
)


server <- function(input, output){
      
      output$plot <- renderPlot({ 
            ggplot(data = ZHmap_WGS, aes(x=long, y=lat)) +
            geom_polygon(colour="darkgrey", fill="lightgrey") +
                geom_point(data=filter(ZH, featCode == c("PPLA2","PPLA")),
                       aes(x=long, y=lat, size=pop), shape=22, alpha=0.5) +
                geom_text(data=filter(ZH, featCode == c("PPLA2","PPLA")), aes(label=name),
                     check_overlap=T, hjust = 0, nudge_x = 0.025, show.legend=F,
                     family = "Calibri", alpha=0.5) +
                geom_text(data=filter(ZH, featCode == "RGN"),
                         aes(label=name, size=pop), alpha=0.5) +
            coord_quickmap() +
            theme_map() +
            theme(legend.position = "right") +
            geom_point(data=filter(ZH, featName == input$Feature),
                   aes(x=long, y=lat, colour=name), size=3)
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
