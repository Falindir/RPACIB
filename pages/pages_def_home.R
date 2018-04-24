tabHome = fluidPage(align="left",
  
                    column(width = 2,
                           box(
                               title = "Params",
                               width = NULL,
                               collapsible = TRUE,
                               solidHeader = TRUE,
                               status="primary",
                               
                               textInput("imageName", "Image Name", ""),
                               br(),
                               radioButtons("containerType", "Container type:", choices = list("Singularity" = "singularity", "Docker" = "docker"), selected = "singularity"),
                               br(),
                               #selectizeInput('rcranpackagelist', 'R CRAN:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                               selectizeInput('rtemplate', 'R origin:', choices = c(`None` = 'none', `R from source 3.4.3` = 'source', `R from source 3.4.4` = 'source2', `R from source 3.5.0` = 'source3', `R from r-base` = 'base', `R from CRAN depo` = 'cran'), selected = "source", multiple = FALSE),
                               #selectizeInput('biocontainers', 'BioContainers tools :', choices = getBioconductorPackage(), multiple = TRUE),
                               
                               
                               
                               textAreaInput("customDataContainer", "Add custom line to container file:"),
                               br(), br(),
                               actionButton("createContainer", label = "Create", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                               downloadButton('downloadContainerFile', label = "Dowload",  style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                               
                           )),
                    column(width = 10,
                           box(
                             id = "boxPackage",
                             title = "Packages and tools",
                             width = NULL,
                             collapsible = TRUE,
                             solidHeader = TRUE,
                             status="primary",
                             tabsetPanel( id='rpackages',
                                          tabPanel('CRAN',    
                                            withSpinner(DT::dataTableOutput('dtrcranpackage'), type = 4, proxy.height = "150px")
                                          ),
                                          tabPanel('Bioconductor',   
                                            div(id = "formBioconductor",
                                            #  br(),
                                            #selectizeInput('selectedBioconductor', 'R Bioconductor selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                                            DT::dataTableOutput('dtrbioconductorpackage'))),
                                          tabPanel('Github',
                                            textInput("inputGithub", "Package name:", ""),
                                            actionButton("findGithub", label = "Find", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                            div(id = "formGithub",
                                            br(), br(),
                                            selectizeInput('rgithubpackagelist', 'R Github selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                                            br(), br(),
                                            DT::dataTableOutput('dtrgithubpackage'))),
                                          tabPanel('BioContainer tools',
                                                   div(id = "formContainer",
                                                       br(),
                                                   selectizeInput('selectedBiocontainer', 'Biocontainer tools selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000))),
                                                   DT::dataTableOutput('dtbiocontainer')
                                                   )
                             )
                          )
                    ),
                    column(width = 12,
                           box(
                             title = "Preview File:",
                             width = NULL,
                             collapsible = TRUE,
                             solidHeader = TRUE,
                             status="primary",
                             style='height:1000px; overflow-y: scroll',
                             textAreaInput("previewContainer", label = "", height = "1000px")
                           )
                    )
                    
)