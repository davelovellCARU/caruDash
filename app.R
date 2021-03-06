#DL a shiny app that shows some CARU numbers
library("shiny")
library("readxl")
library("tidyverse")


# Ui ------------------------------------------------------------------------
ui = fluidPage(
  h1("CARU Dashboard 2019/2020"),
  h2("So far this year:"),
  # actionButton(inputId = "bigButton",
  #              label = "Get Data"),
  tableOutput(outputId = "overview")
)

# Server function -------------------------------------------------------------
server = function(input, output) {

  # Code which gets the excel data every time new user arrives \\\\\\\\\\\\\\\\\\\\
  
  ### Define URL to download excel file from
  excelUrl = "https://www.dropbox.com/s/v9lm9y7nso8yw1x/dashboardTotals.xlsx?dl=1&raw=1"
  
  ### Write binary from excel url to a tempFile
  # Make tmpF (to write to) and theFile (to read from)
  tmpF <- tempfile()
  theFile <- url(excelUrl, open = "rb")
  # write contents of theFile to tmpF
  writeBin({readBin(theFile, raw(), 100000)}, tmpF)
  
  ### Read context of temp binary to a df, statsTable
  (readxl::read_excel(tmpF)) %>%
    rename(
      surveys = 1,
      interviews = 2,
      focusGroups = 3,
      focusGroupParticipants = 4,
      researchersTrained = 5) -> statsTable
  
  # Overview table output \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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

# ShinyApp ------------------------------------------------------------------
shinyApp(ui = ui, server = server)
