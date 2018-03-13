
output$dtrcranpackage <- DT::renderDataTable({
  
  
  result <- allCRAN
  
  return(result)
}, filter='top', escape = FALSE, rownames= FALSE,server = TRUE)

output$dtrbioconductorpackage <- DT::renderDataTable({
  result <- allBIO
  
  return(result)
}, filter='top', escape = FALSE, rownames= FALSE,server = TRUE)

output$dtrgithubpackage <- DT::renderDataTable({
  result <- data.frame(Package=character(),
                             Version=character())
  
  return(result)
}, filter='top', escape = FALSE, rownames= FALSE,server = TRUE)


createContentFile <- function() {
  result <- "Bootstrap: docker"
  result <- paste(result, "From: ubuntu:16.04", sep = "\n")
  result <- paste(result, "IncludeCmd: yes", sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%environment", sep = "\n")
  result <- paste(result, "\tR_VERSION=3.4.3", sep = "\n")
  result <- paste(result, "\texport R_VERSION", sep = "\n")
  result <- paste(result, "\tR_CONFIG_DIR=/etc/R/", sep = "\n")
  result <- paste(result, "\texport R_CONFIG_DIR", sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%labels", sep = "\n")
  result <- paste(result, "\tAuthor Jimmy Lopez", sep = "\n")
  result <- paste(result, "\tVersion v0.0.1", sep = "\n")
  result <- paste(result, "\tR_Version 3.4.3", sep = "\n")
  result <- paste0(result, "\n\tbuild_date ", format(Sys.time(), "%Y %b %d"), "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%apprun R", sep = "\n")
  result <- paste(result, '\texec R "$@"', sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%apprun Rscript", sep = "\n")
  result <- paste(result, '\texec Rscript "$@"', sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%runscript", sep = "\n")
  result <- paste(result, '\texec R "$@"', sep = "\n")
  
  result <- paste(result, "%post", sep = "\n")
  result <- paste(result, "\tapt-get update", sep = "\n")
  result <- paste(result, "\tapt-get install -y wget libblas3 libblas-dev liblapack-dev liblapack3 curl", sep = "\n")
  result <- paste(result, "\tapt-get install -y gcc fort77 aptitude", sep = "\n")
  result <- paste(result, "\taptitude install -y g++ xorg-dev libreadline-dev  gfortran", sep = "\n")
  result <- paste(result, "\tapt-get install -y libssl-dev libxml2-dev libpcre3-dev liblzma-dev libbz2-dev libcurl4-openssl-dev", sep = "\n")
  result <- paste(result, "\tapt-get update", sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, '\tcd $HOME', sep = "\n")
  result <- paste(result, '\twget https://cran.rstudio.com/src/base/R-3/R-3.4.3.tar.gz', sep = "\n")
  result <- paste(result, '\ttar xvf R-3.4.3.tar.gz', sep = "\n")
  result <- paste(result, '\tcd R-3.4.3', sep = "\n")
  result <- paste(result, "\t./configure --enable-R-static-lib --with-blas --with-lapack --enable-R-shlib=yes ", sep = "\n") 
  result <- paste(result, "\tmake", sep = "\n") 
  result <- paste(result, "\tmake install", sep = "\n") 
  
  result <- paste(result, "\n", sep = "\n")
  
  selectCRAN <- allCRAN[input$dtrcranpackage_rows_selected,]
  selectCRAN <- selectCRAN[,"Package"]
  
  
  sizeCRAN <- length(selectCRAN)
  
     if(!is.null(sizeCRAN)) {
       if(sizeCRAN >= 1) { 
    listRCRAN <- '\techo install.packages\\(c('
    for (pkg in 1:sizeCRAN){
      if(pkg < sizeCRAN) {
        listRCRAN <- paste0(listRCRAN, '"',selectCRAN[pkg],'", ')
      } else {
        listRCRAN <- paste0(listRCRAN, '"',selectCRAN[pkg],'"), repos\\=\'https://cloud.r-project.org\'\\) | R --slave ')
      }
    }
    result <- paste(result, listRCRAN, sep = "\n")
  
       }
     }
  result <- paste(result, "\n", sep = "\n")
  

  
  selectBIO <- allBIO[input$dtrbioconductorpackage_rows_selected,]
  selectBIO <- selectBIO[,"Package"]
  sizeBIO <- length(selectBIO)
  
  print(sizeBIO)
  
  if(!is.null(sizeBIO)) {
    if(sizeBIO >= 1) { 
      
      result <- paste(result, '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); \\', sep = "\n")
      result <- paste(result, '\tbiocLite()\n"', sep = "\n")
      
  listRBIO <- '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); \\'
  listRBIO <- paste0(listRBIO, "\n\tbiocLite(")
  for (pkg in 1:sizeBIO){
    if(pkg < sizeBIO) {
      listRBIO <- paste0(listRBIO, '"',selectBIO[pkg],'", ')
    } else {
      listRBIO <- paste0(listRBIO, '"',selectBIO[pkg],'")"')
    }
  }
  result <- paste(result, listRBIO, sep = "\n")
    }
  }
  
  result <- paste(result, "\n", sep = "\n")
  
  
  selectGITHUB <- allGITHUB[input$dtrgithubpackage_rows_selected,]
  selectGITHUB <- selectGITHUB[,"Package"]
  
  print(selectGITHUB)
  
  sizeGITHUB <- length(selectGITHUB)

  
  if(!is.null(sizeGITHUB)) {
    if(sizeGITHUB >= 1) { 
    
      listRGITHUB <- '\tR --slave -e "install_github(c('
      for (pkg in 1:sizeGITHUB){
        if(pkg < sizeGITHUB) {
          listRGITHUB <- paste0(listRGITHUB, '"',selectGITHUB[pkg],'", ')
        } else {
          listRGITHUB <- paste0(listRGITHUB, '"',selectGITHUB[pkg],'"))"')
        }
      }
      result <- paste(result, listRGITHUB, sep = "\n")
    }
  }
  
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, input$customDataContainer, sep = "\t\n")
  return(result)
}

createContainerPackage <- eventReactive(input$createContainer, {

  result <- createContentFile()
  
  show("downloadContainerFile")
  
  HTML(result)
})



output$previewContainer <- renderText({
  createContainerPackage()
})

output$downloadContainerFile <- downloadHandler(
  filename = function() {
    paste("Singularity",input$imageName, sep = ".")
  },
  content = function(file) {
    print(file)
    result <- createContentFile()
    print(result)
    write(result,file=file)
  }
)

#observeEvent(input$dtrcranpackage_rows_selected, {
#  selectCRAN <- allCRAN[input$dtrcranpackage_rows_selected,]
#  selectCRAN <- selectCRAN[,"Package"]
#  
#  updateSelectizeInput(session,"rcranpackagelist", choices = selectCRAN, selected = selectCRAN, options = list())
#
#})

observeEvent(input$findGithub, {
  
  name <- input$inputGithub
  
  
  if(!stri_isempty(name)) {
    allGITHUB <<- data.frame(Package = gh_suggest(name, keep_title = FALSE), Title = attr(gh_suggest(name, keep_title = TRUE), "title"))
    
    if(length(allGITHUB)  >= 1 ) {
    output$dtrgithubpackage <- DT::renderDataTable({
      result <- allGITHUB
      return(result)
    }, filter='top', escape = FALSE, rownames= FALSE,server = TRUE)
    }
  }
  
})


