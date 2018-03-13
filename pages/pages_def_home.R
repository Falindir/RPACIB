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
                               radioButtons("containerType", "Container type:", choices = list("Singularity" = "singularity"), selected = "singularity"),
                               br(),
                               textAreaInput("customDataContainer", "Add custom line to container file:"),
                               br(), br(),
                               actionButton("createContainer", label = "Create", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                               downloadButton('downloadContainerFile', label = "Dowload",  style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                               

                            
                               
                               
                           )),
                    column(width = 10,
                           box(
                             title = "R Packages",
                             width = NULL,
                             collapsible = TRUE,
                             solidHeader = TRUE,
                             status="primary",
                             tabsetPanel( id='rpackages',
                                          tabPanel('CRAN',    
                                            withSpinner(DT::dataTableOutput('dtrcranpackage'), type = 4, proxy.height = "150px")
                                          ),
                                          tabPanel('Bioconductor',   
                                            DT::dataTableOutput('dtrbioconductorpackage')),
                                          tabPanel('Github',
                                            DT::dataTableOutput('dtrgithubpackage'))
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
                             verbatimTextOutput("previewContainer")
                           )
                    )
                    
)