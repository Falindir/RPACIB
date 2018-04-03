
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

output$dtbiocontainer <- DT::renderDataTable({
  result <- data.frame(Tool=character(),
                       Version=character(),
                       Description=character())

  result <- getBioconductorPackage()
  
  
  return(result)
}, filter='top', escape = FALSE, rownames= FALSE,server = TRUE)





createContentFile <- function() {
  
  haveR = FALSE
  
  result <- "Bootstrap: docker"
  result <- paste(result, "From: ubuntu:16.04", sep = "\n")
  result <- paste(result, "IncludeCmd: yes", sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  if(input$rtemplate == "none") {
    result <- paste(result, "%environment", sep = "\n")
    
  } else if(input$rtemplate == "base") {
    result <- paste(result, "%environment", sep = "\n")
    result <- paste(result, "\tR_VERSION=3.2.5", sep = "\n")
    result <- paste(result, "\texport R_VERSION", sep = "\n")
    result <- paste(result, "\tR_CONFIG_DIR=/etc/R/", sep = "\n")
    result <- paste(result, "\texport R_CONFIG_DIR", sep = "\n")
  } else {
    result <- paste(result, "%environment", sep = "\n")
    result <- paste(result, "\tR_VERSION=3.4.3", sep = "\n")
    result <- paste(result, "\texport R_VERSION", sep = "\n")
    result <- paste(result, "\tR_CONFIG_DIR=/etc/R/", sep = "\n")
    result <- paste(result, "\texport R_CONFIG_DIR", sep = "\n")
  }
  
  if(!is.null(input$dtbiocontainer_rows_all)) {
    result <- paste(result, "\texport PATH=/opt/conda/bin:$PATH", sep = "\n")
    result <- paste(result, "\texport PATH=/opt/biotools/bin:$PATH", sep = "\n")
  }
  

  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%labels", sep = "\n")
  result <- paste(result, "\tAuthor Jimmy Lopez", sep = "\n")
  result <- paste(result, "\tVersion v0.0.1", sep = "\n")
  result <- paste0(result, "\n\tbuild_date ", format(Sys.time(), "%Y %b %d"), "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%apprun run", sep = "\n")
  result <- paste(result, '\texec /bin/bash "$@"', sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  #result <- paste(result, "%apprun Rscript", sep = "\n")
  #result <- paste(result, '\texec Rscript "$@"', sep = "\n")
  #result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%runscript", sep = "\n")
  #result <- paste(result, '\texec R "$@"', sep = "\n")
  result <- paste(result, '\texec /bin/bash "$@"', sep = "\n")
  
  result <- paste(result, "\n", sep = "\n")
  
  result <- paste(result, "%post", sep = "\n")
  result <- paste(result, "\tapt-get update", sep = "\n")
  result <- paste(result, "\tapt-get install -y wget libblas3 libblas-dev liblapack-dev liblapack3 curl", sep = "\n")
  result <- paste(result, "\tapt-get install -y gcc fort77 aptitude", sep = "\n")
  result <- paste(result, "\taptitude install -y g++ xorg-dev libreadline-dev  gfortran", sep = "\n")
  result <- paste(result, "\tapt-get install -y libssl-dev libxml2-dev libpcre3-dev liblzma-dev libbz2-dev libcurl4-openssl-dev", sep = "\n")
  result <- paste(result, "\tapt-get update", sep = "\n")
  
  result <- paste(result, "\n", sep = "")
  
  
  if(input$rtemplate != "none") {
    
        haveR = TRUE
    
        if(input$rtemplate == "source") {
          result <- paste(result, '\tcd $HOME', sep = "\n")
          result <- paste(result, '\twget https://cran.rstudio.com/src/base/R-3/R-3.4.3.tar.gz', sep = "\n")
          result <- paste(result, '\ttar xvf R-3.4.3.tar.gz', sep = "\n")
          result <- paste(result, '\tcd R-3.4.3', sep = "\n")
          result <- paste(result, "\t./configure --enable-R-static-lib --with-blas --with-lapack --enable-R-shlib=yes ", sep = "\n") 
          result <- paste(result, "\tmake", sep = "\n") 
          result <- paste(result, "\tmake install", sep = "\n") 
          
        } else if(input$rtemplate == "base") {
          
          result <- paste(result, "\tapt-get install -y r-base r-base-dev", sep = "\n")
          
        } else if(input$rtemplate == "cran") {
          
          result <- paste(result, "\tapt-get install -y software-properties-common", sep = "\n")
          result <- paste(result, "\tadd-apt-repository 'deb http://cloud.r-project.org/bin/linux/ubuntu xenial/'", sep = "\n")
          result <- paste(result, "\tapt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9", sep = "\n")
          result <- paste(result, "\tapt-get update", sep = "\n")
          result <- paste(result, "\tapt-get install -y r-base r-base-dev", sep = "\n")

        }
  

  
        result <- paste(result, "\n", sep = "\n")
        
        selectCRAN <- allCRAN[input$dtrcranpackage_rows_all,]
        selectCRAN <- selectCRAN[,"Package"]
        
        
        sizeCRAN <- length(selectCRAN)
        
        
        
           if(!is.null(sizeCRAN)) {
             if(sizeCRAN < length(allCRAN[,"Package"])) { 
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
        
             }}
           }
        result <- paste(result, "\n", sep = "\n")
        
      
        
        selectBIO <- allBIO[input$dtrbioconductorpackage_rows_all,]
        selectBIO <- selectBIO[,"Package"]
        sizeBIO <- length(selectBIO)
        
        if(!is.null(sizeBIO)) {
          if(sizeBIO < length(allBIO[,"Package"])) { 
          if(sizeBIO >= 1) { 
            
            result <- paste(result, '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); \\', sep = "\n")
            result <- paste(result, '\tbiocLite()"\n', sep = "\n")
            
        listRBIO <- '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); \\'
        listRBIO <- paste0(listRBIO, "\n\tbiocLite(")
        for (pkg in 1:sizeBIO){
          if(pkg < sizeBIO) {
            listRBIO <- paste0(listRBIO, '\'',selectBIO[pkg],'\', ')
          } else {
            listRBIO <- paste0(listRBIO, '\'',selectBIO[pkg],'\')"')
          }
        }
        result <- paste(result, listRBIO, sep = "\n")
          }
          }
        }
        
        result <- paste(result, "\n", sep = "\n")
        
        if(!is.null(input$rgithubpackagelist)) {
          
          
          selectGithub <- input$rgithubpackagelist
          sizeGITHUB <- length(selectGithub)
          
          if(sizeGITHUB >= 1) {
            
            listRGITHUB <- '\tR --slave -e "install_github(c('
            for (pkg in 1:sizeGITHUB){
                      if(pkg < sizeGITHUB) {
                        listRGITHUB <- paste0(listRGITHUB, '\'',selectGithub[pkg],'\', ')
                      } else {
                        listRGITHUB <- paste0(listRGITHUB, '\'',selectGithub[pkg],'\'))"')
                      }
            }
            result <- paste(result, listRGITHUB, sep = "\n")
            
          }
        }
        
        
      #  selectGITHUB <- allGITHUB[input$dtrgithubpackage_rows_all,]
      #  selectGITHUB <- selectGITHUB[,"Package"]
        
      #  sizeGITHUB <- length(selectGITHUB)
      
        
      #  if(!is.null(sizeGITHUB)) {
      #    if(sizeGITHUB < length(allGITHUB[,"Package"])) { 
      #    if(sizeGITHUB >= 1) { 
      #    
      #      listRGITHUB <- '\tR --slave -e "install_github(c('
      #      for (pkg in 1:sizeGITHUB){
      #        if(pkg < sizeGITHUB) {
      #          listRGITHUB <- paste0(listRGITHUB, '\'',selectGITHUB[pkg],'\', ')
      #        } else {
      #          listRGITHUB <- paste0(listRGITHUB, '\'',selectGITHUB[pkg],'\'))"')
      #        }
      #      }
      #      result <- paste(result, listRGITHUB, sep = "\n")
      #      }
      #    }
      # }
        
  
  } #END R



  if(!is.null(input$selectedBiocontainer)) {
    


    

  #if(!is.null(input$dtbiocontainer_rows_all)) {
    
    #biotools = getBioconductorPackage() 
    
    #selectBioTool <- biotools[input$dtbiocontainer_rows_all,]
    selectBioTool <- input$selectedBiocontainer
    
    #result <- paste(result, "\tmv /etc/apt/sources.list /etc/apt/sources.list.bkp && \\",
    #                "\techo -e \"deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse\\n\\ ",
    #                "\tdeb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse\\n\\ ",
    #                "\tdeb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse\\n\\ ",
    #                "\tdeb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse\\n\\n\\\" > /etc/apt/sources.list && \\ ",
    #                "\tcat /etc/apt/sources.list.bkp >> /etc/apt/sources.list && \\ ",
    #                "\tcat /etc/apt/sources.list", sep = "\n")
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "\tapt-get install -y  autotools-dev automake cmake curl grep sed dpkg fuse git zip openjdk-8-jre build-essential pkg-config python python-dev python-pip bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion zlib1g-dev", sep = "\n")
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "\techo \'export PATH=/opt/conda/bin:$PATH\' > /etc/profile.d/conda.sh && \\",
    "\twget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.0.5-Linux-x86_64.sh -O ~/miniconda.sh && \\",
    "\t/bin/bash ~/miniconda.sh -b -p /opt/conda && \\",
    "\trm ~/miniconda.sh", sep = "\n")
    
    result <- paste0(result, "\n")

    result <- paste(result, "\tTINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o \"/v.*\\\"\" | sed \'s:^..\\(.*\\).$:\\1:\'` && \\",
    "\tcurl -L \"https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb\" > tini.deb && \\",
    "\tdpkg -i tini.deb && \\",
    "\trm tini.deb && \\",
    "\tapt-get clean", sep = "\n")
    
    result <- paste0(result, "\n")
    
    
    result <- paste(result, "\tmkdir /opt/biotools/bin", sep = "\n")
    result <- paste(result, "\tchmod 777 -R /opt/biotools/", sep = "\n")
    result <- paste(result, "\texport PATH=/opt/biotools/bin:$PATH", sep = "\n")
    
    result <- paste(result, "\tchmod 777 -R /opt/conda/", sep = "\n")
    result <- paste(result, "\texport PATH=/opt/conda/bin:$PATH", sep = "\n")
    #result <- paste(result, "\techo 'export PATH=/opt/conda/bin:$PATH' >> $SINGULARITY_ENVIRONMENT", sep = "\n")
    
    if(!haveR) {
      result <- paste(result, "\tconda config --add channels r", sep = "\n")
    }
    
    result <- paste(result, "\tconda config --add channels bioconda", sep = "\n")
    result <- paste(result, "\tconda upgrade conda", sep = "\n")
    
    result <- paste0(result, "\n")
    
    for (tool in selectBioTool){
      
      
        
      result <- paste(result, getInstallToolPackageBioContainer(tool), sep="\n\n")
      
    }
    
  }
  
  
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
    result <- createContentFile()
    write(result,file=file)
  }
)

observe({
  
  if(is.null(input$dtbiocontainer_rows_selected)) {
    shinyjs::reset("formContainer")
  } else {
    i = 1
    selectBiocontainer <- list()
    for(x in input$dtbiocontainer_rows_selected) {
      selectBiocontainer[i] = paste(allBIOCONTAINER[[x]]$name, allBIOCONTAINER[[x]]$version, sep = "%")
      i = i + 1
    }
    selectBiocontainer <- c(unlist(selectBiocontainer))
    updateSelectizeInput(session,"selectedBiocontainer", choices = selectBiocontainer, selected = selectBiocontainer, options = list())
  }
})


observe({
  if(is.null(input$dtrgithubpackage_rows_selected)) {
    
    selectGithub <- input$rgithubpackagelist
    sizeGITHUB <- length(selectGithub)
    
    if(sizeGITHUB < 1) {
      shinyjs::reset("formGithub")
    }

  } else {
    i = 1
    selectG <- list()
    for(x in input$dtrgithubpackage_rows_selected) {
      selectG[i] = toString(allGITHUB$Package[[x]])
      i = i + 1
    }
    selectG <- c(unlist(selectG))
    
    selectGithub <- input$rgithubpackagelist
    sizeGITHUB <- length(selectGithub)
    
    if(sizeGITHUB > 1) {
      selectG <- c(selectG, selectGithub)
    }
  
    updateSelectizeInput(session,"rgithubpackagelist", choices = selectG, selected = selectG, options = list())
  }
})

#observeEvent(input$dtrgithubpackage_rows_selected, {
#  
#  
#  
#  selectGITHUB <- allGITHUB[input$dtrgithubpackage_rows_selected,]
#  selectGITHUB <- selectGITHUB[,"Package"]
#  
#  if(is.null(input$rgithubpackagelist)) {
#    element <- selectGITHUB
#  } else {
#    element <- selectGITHUB
#    
#    for(x in input$rgithubpackagelist) {
#      de <- list(Package=x)
#      element = rbind(element,de)
#    }
#    
#  }
#  
#  updateSelectizeInput(session,"rgithubpackagelist", choices = element, selected = element, options = list())#
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


