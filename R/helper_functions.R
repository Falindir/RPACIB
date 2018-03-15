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
  
  Tool = c("DiffExpIR", 
           "abyss",
           "Aliscore"
  )
  
  Version = c("0.0.1", 
              "1.9.0",
              "v.2.0"
  )
  
  Description = c("Differentially expressed intron retention",
                  "ABySS is a *de novo* sequence assembler",
                  "Aliscore is designed to filter alignment ambiguous or randomly similar sites in multiple sequence alignments (MSA)."
  )
  
  Link = c("<a href='https://github.com/r78v10a07/DiffExpIR'>documentation</a>",
           "<a href='https://github.com/bcgsc/abyss#abyss'>documentation</a>",
           "<a href='https://www.zfmk.de/dateien/atoms/files/aliscore_v.2.0_manual_0.pdf'>documentation</a>"
           
  )
  
  result <- data.frame(BioContainer_Tool=Tool,
                       Version=Version,
                       Description=Description,
                       Documentation=Link)
  
  
  return(result)
}

getInstallToolPackageBioContainer <- function(tool) {
  
  if(tool == "DiffExpIR") {
    return("")
  } else if(tool == "abyss") {
    return("\tconda install abyss=1.9.0")
  }
  
  
    
  return("")
}



