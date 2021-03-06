tabHome = fluidPage(align="left",
                    
                    column(width = 12,
                           box(
                             title = "Help",
                             width = NULL,
                             collapsible = TRUE,
                             status="primary",
                             solidHeader = TRUE,
                             tags$b("Bioinformatics tools: "),
                             p("Select each tool by clicking on the corresponding field in the table. They appear in the field below."),
                             tags$b("CRAN R Packages: "),
                             p("Select each tool by clicking on the corresponding field in the table. They appear in the field below."),
                             tags$b("Bioconductor R Packages: "),
                             p("Select each tool by clicking on the corresponding field in the table. They appear in the field below."),
                             tags$b("Github R Packages: "),
                             p("Select each tool by clicking on the corresponding field in the table. They appear in the field below."),
                             p("Use 'Generate' button to generate your recipe in the preview area then copy/paste the text or use dowload button to get your file."),
                             tags$b("For Singularity containers: To build the image from the recipes file named ubuntu6.10_stacks2.0.simg :"),
                             p("sudo singularity build ubuntu6.10_stacks2.0.simg ubuntu6.10_stacks2.0.recipes"),
                             tags$b("To run a program inside the image container :"),
                             p(" singularity exec ubuntu6.10_stacks2.0.simg python --version "),
                             p("singularity exec ubuntu6.10_stacks2.0.simg python -c 'import pysam; print 2*2'")
                           )),
  
                    column(width = 2,
                           box(
                               title = "Params",
                               width = NULL,
                               collapsible = TRUE,
                               solidHeader = TRUE,
                               status="primary",
                               
                               textInput("imageName", "Image Name", ""),
                               br(),
                               #selectizeInput('fromTemplate', 'From:', choices = c(`ubuntu:16.04` = 'ubuntu:16.04', `r-base` = 'r-base'), selected = "r-base", multiple = FALSE),
                               selectizeInput('fromTemplate', 'From:', choices = c(`ubuntu:16.04` = 'ubuntu:16.04'), selected = "ubuntu:16.04", multiple = FALSE),
                               
                               br(),
                               radioButtons("containerType", "Container type:", choices = list("Singularity" = "singularity", "Docker" = "docker"), selected = "singularity"),
                               br(),
                               #selectizeInput('rcranpackagelist', 'R CRAN:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                               selectizeInput('rtemplate', 'R origin:', choices = c(`None` = 'none', `R from source 3.4.3` = 'source', `R from source 3.4.4` = 'source2', `R from source 3.5.0` = 'source3', `R from r-base` = 'base', `R from CRAN depo` = 'cran'), selected = "none", multiple = FALSE),
                               #selectizeInput('biocontainers', 'BioContainers tools :', choices = getBioconductorPackage(), multiple = TRUE),
                               
                               
                               
                               textAreaInput("customDataContainer", "Add custom line to container file:"),
                               br(), br(),
                              
                               actionButton("createContainer", label = "Generate", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
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
                                          tabPanel('Bioinformatics tools',
                                                   div(id = "formContainer",
                                                       br(),
                                                       selectizeInput('selectedBiocontainer', 'Biocontainer tools selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000))),
                                                   
                                                   DT::dataTableOutput('dtbiocontainer')
                                          ),
                                          tabPanel('CRAN Packages', 
                                                   div(id = "formCRAN",
                                                    selectizeInput('selectedCRAN', 'CRAN package selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000))
                                                   ,
                                          
                                                    withSpinner(DT::dataTableOutput('dtrcranpackage'), type = 4, proxy.height = "150px")
                                                  )
                                          ),
                                          tabPanel('Bioconductor Packages',   
                                            div(id = "formBioconductor",
                                            #  br(),
                                            #selectizeInput('selectedBioconductor', 'R Bioconductor selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                                            selectizeInput('selectedConductor', 'Bioconductor package selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                                            
                                            DT::dataTableOutput('dtrbioconductorpackage'))),
                                          tabPanel('Github R Packages',
                                            textInput("inputGithub", "Package name:", ""),
                                            actionButton("findGithub", label = "Find", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                            div(id = "formGithub",
                                            br(), br(),
                                            selectizeInput('rgithubpackagelist', 'R Github selected:', choices = NULL, multiple=TRUE, options = list(maxItems = 30000)),
                                            
                                            br(), br(),
                                            DT::dataTableOutput('dtrgithubpackage')))
                                          
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