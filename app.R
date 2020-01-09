#DL a shiny app that shows some CARU numbers
library("shiny")
library("readxl")
library("tidyverse")

# Initial code which reads the excel data -------------------------------------
  ### Define URL to download excel file from
excelUrl = "https://www.dropbox.com/s/v9lm9y7nso8yw1x/dashboardTotals.xlsx?dl=1&raw=1"

  ### Write binary from excel url to a tempFile
tmpF <- paste0(getwd(), "/newTing.xlsx")
theFile <- url(excelUrl, open = "rb")
binary = readBin(theFile, raw(), 100000)
writeBin(binary, tmpF)

  ### Read context of temp binary to a df, statsTable
(readxl::read_excel(tmpF)) %>%
  rename(
    surveys = 1,
    interviews = 2,
    focusGroups = 3,
    focusGroupParticipants = 4,
    researchersTrained = 5) -> statsTable
                          

# Server function -------------------------------------------------------------
server = function(input, output, statsTable) {

  output$overview =
    renderTable({
      as.matrix(
        statsTable %>%
          rename(
            "Surveys\ncompleted" = surveys,
            "Interviews\nconducted" = interviews,
            "Focus groups\nfacillitated" = focusGroups,
            "Focus group\nparticipants" = focusGroupParticipants,
            "Action researchers\ntrained" = researchersTrained
          )
      )
    }, digits = 0)
}

# Ui ------------------------------------------------------------------------
ui = fluidPage(
  h1("CARU Dashboard 2019/2020"),
  h2("So far this year:"),
  actionButton(inputId = "bigButton",
               label = "Get Data"),
  tableOutput(outputId = "overview")
)

# ShinyApp ------------------------------------------------------------------
shinyApp(ui = ui, server = server)


# Unused code
# 
# statsTable = eventReactive(input$bigButton,
#                            {excelUrl = "https://www.dropbox.com/s/v9lm9y7nso8yw1x/dashboardTotals.xlsx?dl=1&raw=1"
#                            
#                            tmpF <- paste0(getwd(), "/newTing.xlsx")
#                            theFile <- url(excelUrl, open = "rb")
#                            
#                            binary = readBin(theFile, raw(), 100000)
#                            
#                            writeBin(binary, tmpF)
#                            
#                            (readxl::read_excel(tmpF)) %>%
#                              rename(surveys = 1,
#                                     interviews = 2,
#                                     focusGroups = 3,
#                                     focusGroupParticipants = 4,
#                                     researchersTrained = 5) -> tmp
#                            return(tmp)
#                            })