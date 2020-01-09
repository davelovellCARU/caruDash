#DL a shiny app that shows some CARU numbers
library("shiny")
library("readxl")
library("tidyverse")

ui = fluidPage(
  actionButton(inputId = "bigButton",
               label = "Get Data"),
  textOutput(outputId = "numInterviews")
)


server = function(input, output) {
  datum = eventReactive(input$bigButton,
                        {excelUrl = "https://www.dropbox.com/s/v9lm9y7nso8yw1x/dashboardTotals.xlsx?dl=1&raw=1"
                          
                          tmpF <- paste0(getwd(), "/newTing.xlsx")
                          theFile <- url(excelUrl, open = "rb")
                          
                          binary = readBin(theFile, raw(), 100000)
                          
                          writeBin(binary, tmpF)
                          
                          ((readxl::read_excel(tmpF)) %>%
                              select(2) %>%
                              pull(1) %>%
                              as.character)[1] -> tmp
                          return(tmp)})
  
  output$numInterviews =
    renderText({
      datum()
    })
  }


shinyApp(ui = ui, server = server)
