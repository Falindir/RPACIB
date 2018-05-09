
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



createHeader <- function() {
  
  result <- ""
  
  if(input$containerType == "singularity") {
    result <- "Bootstrap: docker"
    result <- paste0(result, "\nFrom: ",  input$fromTemplate)
    result <- paste(result, "IncludeCmd: yes", sep = "\n")
  } else { # else docker
    result <- paste0("FROM ", input$fromTemplate)
  }

  result <- paste0(result, "\n")
  return(result)
}

createEnv <- function(result) {
  
  Rversion = "3.4.3" 
  if(input$rtemplate == "source2") {
    Rversion = "3.4.4" 
  }else if(input$rtemplate == "source3") {
    Rversion = "3.5.0" 
  }
  
  if(input$containerType == "singularity") {
      result <- paste(result, "%environment", sep = "\n")
    
      if(input$rtemplate == "none") {
        
      } else if(input$rtemplate == "base") {
        result <- paste(result, "\tR_VERSION=3.2.5", sep = "\n")
        result <- paste(result, "\texport R_VERSION", sep = "\n")
        result <- paste(result, "\tR_CONFIG_DIR=/etc/R/", sep = "\n")
        result <- paste(result, "\texport R_CONFIG_DIR", sep = "\n")
      } else {

        result <- paste0(result, "\n\tR_VERSION=", Rversion)
        result <- paste(result, "\texport R_VERSION", sep = "\n")
        result <- paste(result, "\tR_CONFIG_DIR=/etc/R/", sep = "\n")
        result <- paste(result, "\texport R_CONFIG_DIR", sep = "\n")
      }
      
      if(!is.null(input$dtbiocontainer_rows_all)) {
        result <- paste(result, "\texport PATH=/opt/conda/bin:$PATH", sep = "\n")
        result <- paste(result, "\texport PATH=/opt/biotools/bin:$PATH", sep = "\n")
      }
  } else {
      if(input$rtemplate == "none") {
        
      } else if(input$rtemplate == "base") {
        result <- paste0(result, "ENV R_VERSION=", Rversion)
        result <- paste(result, "RUN export R_VERSION", sep = "\n")
        result <- paste(result, "ENV R_CONFIG_DIR=/etc/R/", sep = "\n")
        result <- paste(result, "RUN export R_CONFIG_DIR", sep = "\n")
        
      } else {
        result <- paste(result, "ENV R_VERSION=3.4.3", sep = "\n")
        result <- paste(result, "RUN export R_VERSION", sep = "\n")
        result <- paste(result, "ENV R_CONFIG_DIR=/etc/R/", sep = "\n")
        result <- paste(result, "RUN export R_CONFIG_DIR", sep = "\n")
      }
      
      if(!is.null(input$dtbiocontainer_rows_all)) {
        result <- paste(result, "RUN export PATH=/opt/conda/bin:$PATH", sep = "\n")
        result <- paste(result, "RUN export PATH=/opt/biotools/bin:$PATH", sep = "\n")
      }
  }

  result <- paste0(result, "\n")
  return(result)
}

createLabel <- function(result) {
  
    if(input$containerType == "singularity") {
        result <- paste(result, "%labels", sep = "\n")
        result <- paste(result, "\tAuthor YourName", sep = "\n")
        result <- paste(result, "\tVersion v0.0.1", sep = "\n")
        result <- paste0(result, "\n\tbuild_date ", format(Sys.time(), "%Y %b %d")) 
    } else {
      result <- paste(result, "LABEL Author YourName", sep = "\n")
      result <- paste(result, "LABEL Version v0.0.1", sep = "\n")
      result <- paste0(result, "\n", "LABEL build_date ", format(Sys.time(), "%Y %b %d")) 
    }

    result <- paste0(result, "\n")
    return(result)
}

createExect <- function(result) {
  
    if(input$containerType == "singularity") {
        result <- paste(result, "%apprun run", sep = "\n")
        result <- paste(result, '\texec /bin/bash "$@"', sep = "\n")
        result <- paste0(result, "\n")
        result <- paste(result, "%runscript", sep = "\n")
        result <- paste(result, '\texec /bin/bash "$@"', sep = "\n")
    } else {
        result <- paste(result, "CMD exec /bin/bash \"$@\"", sep = "\n")
    }
  
    result <- paste0(result, "\n")
    return(result)
}

createLibPrePost <- function(result) {
  
  if(input$containerType == "singularity") {
      result <- paste(result, "%post", sep = "\n")
      result <- paste(result, "\tapt-get update", sep = "\n")
      result <- paste(result, "\tapt-get install -y wget libblas3 libblas-dev liblapack-dev liblapack3 curl", sep = "\n")
      result <- paste(result, "\tapt-get install -y gcc fort77 aptitude", sep = "\n")
      result <- paste(result, "\taptitude install -y g++ xorg-dev libreadline-dev  gfortran", sep = "\n")
      result <- paste(result, "\tapt-get install -y libssl-dev libxml2-dev libpcre3-dev liblzma-dev libbz2-dev libcurl4-openssl-dev", sep = "\n")
      result <- paste(result, "\tapt-get update", sep = "\n")
  } else {
      result <- paste(result, "RUN apt-get update", sep = "\n")
      result <- paste(result, "RUN apt-get install -y wget libblas3 libblas-dev liblapack-dev liblapack3 curl", sep = "\n")
      result <- paste(result, "RUN apt-get install -y gcc fort77 aptitude", sep = "\n")
      result <- paste(result, "RUN aptitude install -y g++ xorg-dev libreadline-dev  gfortran", sep = "\n")
      result <- paste(result, "RUN apt-get install -y libssl-dev libxml2-dev libpcre3-dev liblzma-dev libbz2-dev libcurl4-openssl-dev openjdk-8-jre", sep = "\n")
      result <- paste(result, "RUN apt-get update", sep = "\n")
      result <- paste(result, "ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64", sep = "\n")
      
  }
  
  result <- paste0(result, "\n")
  return(result)
}

#' Use for create install R from RBase content
createRBase <- function(result) {
  
  result <- paste(result, '############### Install R From RBase ##############', sep = "\n")
  
  if(input$containerType == "singularity") {
      result <- paste(result, "\tapt-get install -y r-base r-base-dev", sep = "\n")
  } else {
    result <- paste(result, "RUN apt-get install -y r-base r-base-dev", sep = "\n")
  }
  
  result <- paste0(result, "\n")
  return(result)
}

#' Use for create install R from Source content
createRSource <- function(result, Rversion) {
  
  result <- paste(result, '############### Install R From Source ##############', sep = "\n")
  
  if(input$containerType == "singularity") {
      result <- paste(result, '\tcd $HOME', sep = "\n")
      result <- paste0(result, '\n\twget https://cran.rstudio.com/src/base/R-3/R-', Rversion, '.tar.gz')
      result <- paste0(result, '\n\ttar xvf R-', Rversion, '.tar.gz')
      result <- paste0(result, '\n\tcd R-', Rversion)
      result <- paste(result, "\t./configure --enable-R-static-lib --with-blas --with-lapack --enable-R-shlib=yes ", sep = "\n") 
      result <- paste(result, "\tmake", sep = "\n") 
      result <- paste(result, "\tmake install", sep = "\n") 
  } else {
    result <- paste(result, 'RUN cd $HOME \\', sep = "\n")
    result <- paste0(result, '\n\t&& wget https://cran.rstudio.com/src/base/R-3/R-', Rversion, '.tar.gz \\')
    result <- paste0(result, '\n\t&& tar xvf R-', Rversion, '.tar.gz \\')
    result <- paste0(result, '\n\t&& cd R-', Rversion, ' \\')
    result <- paste(result, "\t&& ./configure --enable-R-static-lib --with-blas --with-lapack --enable-R-shlib=yes \\", sep = "\n") 
    result <- paste(result, "\t&& make \\", sep = "\n") 
    result <- paste(result, "\t&& make install \\", sep = "\n") 
  }
  
  result <- paste0(result, "\n")
  return(result)
}

#' Use for create install R from CRAN content
createRCran <- function(result) {
  
  result <- paste(result, '############### Install R From CRAN ##############', sep = "\n")
  
  if(input$containerType == "singularity") {
      result <- paste(result, "\tapt-get install -y software-properties-common", sep = "\n")
      result <- paste(result, "\tadd-apt-repository 'deb http://cloud.r-project.org/bin/linux/ubuntu xenial/'", sep = "\n")
      result <- paste(result, "\tapt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9", sep = "\n")
      result <- paste(result, "\tapt-get update", sep = "\n")
      result <- paste(result, "\tapt-get install -y r-base r-base-dev", sep = "\n")
  } else {
      result <- paste(result, "RUN apt-get install -y software-properties-common", sep = "\n")
      result <- paste(result, "RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/ubuntu xenial/'", sep = "\n")
      result <- paste(result, "RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9", sep = "\n")
      result <- paste(result, "RUN apt-get update", sep = "\n")
      result <- paste(result, "RUN apt-get install -y r-base r-base-dev", sep = "\n")
  }
  
  result <- paste0(result, "\n")
  return(result)
}

#' Use for create CRAN content
createCRANPackage <- function(result) {
  
  
  
  selectCRAN <- allCRAN[input$dtrcranpackage_rows_all,]
  selectCRAN <- selectCRAN[,"Package"]
  sizeCRAN <- length(selectCRAN)
  
  
  if(!is.null(sizeCRAN)) {
    if(sizeCRAN < length(allCRAN[,"Package"])) { 
      if(sizeCRAN >= 1) { 
        
        result <- paste(result, '############### Install CRAN Package ##############', sep = "\n")
        
        if(input$containerType == "singularity") {
          listRCRAN <- '\tR --slave -e "install.packages( c('
        } else {
          listRCRAN <- 'RUN R --slave -e "install.packages( c('
        }
        
        for (pkg in 1:sizeCRAN){
          if(pkg < sizeCRAN) {
            listRCRAN <- paste0(listRCRAN, "'",selectCRAN[pkg],"', ")
          } else {
            listRCRAN <- paste0(listRCRAN, "'",selectCRAN[pkg],"'), repos='https://cloud.r-project.org'))\"")
          }
        }
        
        result <- paste(result, listRCRAN, sep = "\n")
        result <- paste0(result, "\n")
      }
    }
  }
  
  return(result)
}

#' Use for create Github content
createGithubPackage <- function(result) {
  
  if(!is.null(input$rgithubpackagelist)) {
  
    selectGithub <- input$rgithubpackagelist
    sizeGITHUB <- length(selectGithub)
    
    if(sizeGITHUB >= 1) {
      
      result <- paste(result, '############### Install Github Package ##############', sep = "\n")
      
      
      if(input$containerType == "singularity") {
        listRGITHUB <- '\tR --slave -e "install_github(c('
      } else {
        listRGITHUB <- 'RUN R --slave -e "install_github(c('
      }
      
      
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
  

  
  result <- paste0(result, "\n")
  return(result)
}

#' Use for create Bioconductor content
createBioconductorPackage <- function(result) {
  
  selectBIO <- allBIO[input$dtrbioconductorpackage_rows_all,]
  selectBIO <- selectBIO[,"Package"]
  sizeBIO <- length(selectBIO)
  
  if(!is.null(sizeBIO)) {
    if(sizeBIO < length(allBIO[,"Package"])) { 
      if(sizeBIO >= 1) { 
        
        result <- paste(result, '############### Install Bioconductor Package ##############', sep = "\n")
        
        
        if(input$containerType == "singularity") {
          result <- paste(result, '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); biocLite(); "', sep = "\n")
          listRBIO <- '\tR --slave -e "source(\'https://bioconductor.org/biocLite.R\'); biocLite(\\'
        } else {
          result <- paste(result, 'RUN R --slave -e "source(\'https://bioconductor.org/biocLite.R\'); biocLite(); "', sep = "\n")
          listRBIO <- 'RUN R --slave -e "source(\'https://bioconductor.org/biocLite.R\'); biocLite(\\'
        }
      
        for (pkg in 1:sizeBIO){
          if(pkg < sizeBIO) {
            listRBIO <- paste0(listRBIO, '\'',selectBIO[pkg],'\', ')
          } else {
            listRBIO <- paste0(listRBIO, '\'',selectBIO[pkg],'\')"')
          }
        }
        
        result <- paste(result, listRBIO, sep = "\n")
        result <- paste0(result, "\n")
      }
    }
  }
  
  return(result)
}

#' Use for create Biocontainer content
createBiocontainer <- function(result, haveR) {

  if(input$containerType == "singularity") {
    selectBioTool <- input$selectedBiocontainer
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "\tapt-get install -y  autotools-dev automake cmake curl grep sed dpkg fuse git zip openjdk-8-jre build-essential pkg-config python python-dev python-pip bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion zlib1g-dev", sep = "\n")
    result <- paste(result, "\tapt-get update", sep = "\n")
    
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
    
    result <- paste(result, "\tmkdir /opt/biotools", sep = "\n")
    result <- paste(result, "\tmkdir /opt/biotools/bin", sep = "\n")
    result <- paste(result, "\tchmod 777 -R /opt/biotools/", sep = "\n")
    result <- paste(result, "\texport PATH=/opt/biotools/bin:$PATH", sep = "\n")
    
    result <- paste(result, "\tchmod 777 -R /opt/conda/", sep = "\n")
    result <- paste(result, "\texport PATH=/opt/conda/bin:$PATH", sep = "\n")
    
    if(!haveR) {
      result <- paste(result, "\tconda config --add channels r", sep = "\n")
    }
    
    result <- paste(result, "\tconda config --add channels bioconda", sep = "\n")
    result <- paste(result, "\tconda upgrade conda", sep = "\n")
    
    result <- paste0(result, "\n")
    
    for (tool in selectBioTool){
      
      result <- paste(result, '############### Install BioContainer tools ##############', sep = "\n")
      
      
      result <- paste(result, getInstallToolPackageBioContainer(tool, input$containerType), sep="\n\n")
    }
  } else {
    selectBioTool <- input$selectedBiocontainer
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "RUN apt-get install -y  autotools-dev automake cmake curl grep sed dpkg fuse git zip openjdk-8-jre build-essential pkg-config python python-dev python-pip bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion zlib1g-dev", sep = "\n")
    result <- paste(result, "RUN apt-get update", sep = "\n")
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "RUN echo \'export PATH=/opt/conda/bin:$PATH\' > /etc/profile.d/conda.sh && \\",
                    "\twget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.0.5-Linux-x86_64.sh -O ~/miniconda.sh && \\",
                    "\t/bin/bash ~/miniconda.sh -b -p /opt/conda && \\",
                    "\trm ~/miniconda.sh", sep = "\n")
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o \"/v.*\\\"\" | sed \'s:^..\\(.*\\).$:\\1:\'` && \\",
                    "\tcurl -L \"https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb\" > tini.deb && \\",
                    "\tdpkg -i tini.deb && \\",
                    "\trm tini.deb && \\",
                    "\tapt-get clean", sep = "\n")
    
    result <- paste0(result, "\n")
    
    result <- paste(result, "RUN mkdir /opt/biotools", sep = "\n")
    result <- paste(result, "RUN mkdir /opt/biotools/bin", sep = "\n")
    result <- paste(result, "RUN chmod 777 -R /opt/biotools/", sep = "\n")
    result <- paste(result, "ENV PATH=/opt/biotools/bin:${PATH}", sep = "\n")
    
    result <- paste(result, "RUN chmod 777 -R /opt/conda/", sep = "\n")
    result <- paste(result, "ENV PATH=/opt/conda/bin:${PATH}", sep = "\n")
    
    if(!haveR) {
      result <- paste(result, "RUN conda config --add channels r", sep = "\n")
    }
    
    result <- paste(result, "RUN conda config --add channels bioconda", sep = "\n")
    result <- paste(result, "RUN conda upgrade conda", sep = "\n")
    
    result <- paste0(result, "\n")
    
    for (tool in selectBioTool){
      
      result <- paste(result, '############### Install BioContainer tools ##############', sep = "\n")
      
      
      result <- paste0(result, "\nRUN ", getInstallToolPackageBioContainer(tool, input$containerType))
    }
    
  }
  
    result <- paste0(result, "\n")
    return(result)
}

#' Use for create Singularity or Dockerfile
createContentFile <- function() {
  
  haveR = FALSE

  result <- createHeader()
  result <- createEnv(result)
  result <- createLabel(result)
  result <- createLibPrePost(result)

  if(input$rtemplate != "none") {
    
      haveR = TRUE
    
      if(input$rtemplate == "source" || input$rtemplate == "source2" || input$rtemplate == "source3") {
          Rversion = "3.4.3" 
          if(input$rtemplate == "source2") {
            Rversion = "3.4.4" 
          }else if(input$rtemplate == "source3") {
            Rversion = "3.5.0" 
          }
        
          result <- createRSource(result, Rversion)
      } else if(input$rtemplate == "base") {
          result <- createRBase(result)
      } else if(input$rtemplate == "cran") {
          result <- createRCran(result)
      }
      
      result <- createCRANPackage(result)
      result <- createBioconductorPackage(result)
      result <- createGithubPackage(result)
  } 

  if(!is.null(input$selectedBiocontainer)) {
    result <- createBiocontainer(result, haveR)
  }
  
  result <- createExect(result)
  
  result <- paste(result, input$customDataContainer, sep = "\t\n")
  
  return(result)
}

observeEvent(input$createContainer, {

  js$collapse("boxPackage")
  
  show("downloadContainerFile")
  
  result <- createContentFile()
  
  updateTextAreaInput(session, "previewContainer",
                      label = "",
                      value = result)
  
})

#createContainerPackage <- eventReactive(input$createContainer, {

  #result <- createContentFile()
  
  #show("downloadContainerFile")
  

  #HTML(result)

#})



#output$previewContainer <- renderText({
#  createContainerPackage()
#})


output$downloadContainerFile <- downloadHandler(
  filename = function() {
    name <- ""
    if(input$containerType == "singularity") {
      name <- paste("Singularity",input$imageName, sep = ".")
    } else {
      name <- paste("Dockerfile",input$imageName, sep = ".")
    }
  },
  content = function(file) {
    result <- input$previewContainer
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


