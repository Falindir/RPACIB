library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinycssloaders)
library(DT)
library(dplyr)

source("./R/menugauche.R", local = T)
source("./pages/pages_def_home.R", local = T)

options(encoding = 'UTF-8')

#style <- tags$style(HTML(readLines("www/added_styles.css")) )
UI <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "RPACIB"),
  dashboardSidebar(MenuGauche),
  dashboardBody(
    
    shinyjs::useShinyjs(),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.readable.css")) ,
    #tags$head(style),

    tabItems(
      tabItem(tabName = "Home",         tabHome)
    )
  )
)



server <- function( input, output, session) {
  
  shinyCheckBoxPackage <- function(df ) {
    inputs = sprintf('<input id="%s" type="checkbox">', df[,"Package"])
    inputs
  }
  
  source("https://bioconductor.org/biocLite.R")
  
  allCRAN <<- as.data.frame(available.packages(repo = "http://cran.us.r-project.org")[, c("Package", "Version")])
  allBIO <<- as.data.frame(available.packages(repo = biocinstallRepos()[1])[, c("Package", "Version")])
  
  hide("downloadContainerFile")
  
  #allCRAN$select <- sprintf('<input id="chekcboxCRAN_%s" type="checkbox" onclick=\"Shiny.onInputChange(&#39;select_cran_package&#39;,  this.id)\">', allCRAN[,"Package"])
  #allBIO$select <- sprintf('<input id="chekcboxBIO_%s" type="checkbox">', allBIO[,"Package"])
  
  #allCRAN <- allCRAN[c("select", "Package", "Version")]
  #allBIO <- allBIO[c("select", "Package", "Version")]
  
  source("./server/opt_home.R", local=TRUE)
}

shinyApp(ui = UI, server = server)