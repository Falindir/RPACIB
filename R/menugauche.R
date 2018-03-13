MenuGauche = sidebarMenu(id = "sidebarmenu",
                         menuItem("Home", tabName = "Home",  icon = icon("home", lib="font-awesome")),
                         
                         tags$br(), tags$br(), tags$br(),
                         
                         menuItem("Team", icon = icon("book", lib="font-awesome"),
                                  menuItem("Jimmy Lopez",  href = "http://www.isem.univ-montp2.fr/recherche/les-plate-formes/bioinformatique-labex/personnel/", newtab = TRUE,   icon = shiny::icon("male"), selected = NULL  )
                         )
                         
)
