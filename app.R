library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinycssloaders)
library(DT)
library(dplyr)
library(tools)
library(githubinstall)
require(stringi)
library(devtools)
library(yaml)

source("./R/helper_functions.R", local = T)
source("./R/menugauche.R", local = T)
source("./pages/pages_def_home.R", local = T)

options(encoding = 'UTF-8')

jscode <- "
shinyjs.collapse = function(boxid) {
$('#' + boxid).closest('.box').find('[data-widget=collapse]').click();
}
"

#style <- tags$style(HTML(readLines("www/added_styles.css")) )
UI <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "RPACIB"),
  dashboardSidebar(MenuGauche),
  dashboardBody(
    
    shinyjs::useShinyjs(),
    extendShinyjs(text = jscode),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.readable.css")) ,
    #tags$head(style),

    tabItems(
      tabItem(tabName = "Home",         tabHome)
    )
  )
)

server <- function( input, output, session) {
  
  source("https://bioconductor.org/biocLite.R")
  
  session$userData <- c()
  
  disable("rcranpackagelist")
  
  #allCRAN <<- as.data.frame(available.packages(repo = "http://cran.us.r-project.org")[, c("Package")])
  allCRAN <<- as.data.frame(getPackagesWithTitle())
  allBIO <<- as.data.frame(available.packages(repo = biocinstallRepos()[1])[, c("Package", "Version")])
  allGITHUB <<- data.frame(Package=character(), Version=character())
  TMP <<- yaml.load_file("container.yaml")$containers 
  i = 1
  j = 1
  allBIOCONTAINER <<- list()
  for(x in TMP) {
    if(length(TMP[[i]]$install) > 0) {
      
      allBIOCONTAINER[[j]] <<- TMP[[i]]
      j = j + 1
    }
    i = i + 1
  }
  
  hide("downloadContainerFile")

  source("./server/opt_home.R", local=TRUE)
}

shinyApp(ui = UI, server = server)