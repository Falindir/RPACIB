FROM r-base:latest

MAINTAINER Jimmy Lopez

RUN apt-get update && apt-get install -y -t unstable \ 
sudo \ 
gdebi-core \ 
openssl \ 
pandoc \ 
pandoc-citeproc \ 
libcurl4-gnutls-dev \ 
libcairo2-dev/unstable \ 
libxt-dev

RUN apt-get install -y libssl-dev

RUN apt-get update

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'shinydashboard', 'shinyjs', 'shinycssloaders', 'DT', 'dplyr', 'githubinstall', 'stringi', 'devtools', 'yaml'), repos='https://cran.rstudio.com/')"

RUN apt-get install -y git

RUN git clone https://github.com/Falindir/RPACIB.git

RUN R -e "devtools::install_github('rstudio/httpuv')"

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/RPACIB/', port=3838)"]
