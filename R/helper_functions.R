getPackagesWithTitle <- function() {
       contrib.url("https://cran.rstudio.com/", "source") 
       description <- sprintf("%s/web/packages/packages.rds", 
                              "https://cran.rstudio.com/")
       con <- if(substring(description, 1L, 7L) == "file://") {
            file(description, "rb")
         } else {
              url(description, "rb")
           }
     on.exit(close(con))
       db <- readRDS(gzcon(con))
       rownames(db) <- NULL
  
         db[, c("Package", "Title", "Version")]
   }




getBioconductorPackage <- function() {

  data <- yaml.load_file("container.yaml")$containers
  
  size <- 0 
  
  for (tools in data) {
    if(length(tools$install) > 0) {
      size <- size + 1
    }
  }
  
  Tool <- character(size)
  Version <- character(size)
  Description <- character(size)
  Link <- character(size)

  i=1
  for (tools in data) {
    
    if(length(tools$install) > 0) {
    
    Tool[i] = tools$name
    Version[i] = tools$version
    Description[i] = tools$description
    Link[i] = paste0("<a href='", tools$documentation, "'>documentation</a>")
    i = i + 1
    }
  }
  
  # Link = c("<a href='https://github.com/r78v10a07/DiffExpIR'>documentation</a>",
  #          "<a href='https://github.com/bcgsc/abyss#abyss'>documentation</a>",
  #          "<a href='https://www.zfmk.de/dateien/atoms/files/aliscore_v.2.0_manual_0.pdf'>documentation</a>"
  #          
  # )
  
  result <- data.frame(BioContainer_Tool=Tool,
                       Version=Version,
                       Description=Description,
                       Link=Link)
  
  return(result)
}

getInstallToolPackageBioContainer <- function(tool) {
  
  data <- yaml.load_file("container.yaml")$containers

  size <- length(data)
  
  intalls <- ""
  
  for (tools in data) {
      if(tools$name == tool) {
        res <- paste0("\t", tools$install, collapse='\n' )
        return(res)
      } 
  }

  return("\t")

}



