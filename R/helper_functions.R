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

