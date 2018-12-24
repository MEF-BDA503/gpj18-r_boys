library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# saveRDS(object = cur_pop,file = "curpopulationShiny.rds")
# saveRDS(object = org_pop,file = "orgpopulationShiny.rds")

#Loading the dataframes for shiny
current_population <- readRDS("curpopulationShiny.rds")
colnames(current_population) <- c("Birth_Place","Current_Population")

original_population <- readRDS("orgpopulationShiny.rds")
colnames(original_population) <- c("Birth_Place","Original_Population")
# original_population <- original_population %>% 
#   filter(!Birth_Place %in% c("Bilinmeyen","Yurtdisi"))

org_pop_Shiny <- merge(x = current_population, y = original_population, by = "Birth_Place")

org_pop_Shiny$Birth_Place <- as.factor(org_pop_Shiny$Birth_Place)
all_cities <- sort(unique(org_pop_Shiny$Birth_Place))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      selectInput(inputId = "city",
                  label = "Select City/Cities:",
                  choices = all_cities,
                  selected = "Adana",
                  multiple = TRUE)
      
    ),
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "citiestable")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create data table
  output$citiestable <- DT::renderDataTable({
    req(input$city)
    cities_from_selected <- org_pop_Shiny %>%
      filter(Birth_Place %in% input$city)
    DT::datatable(data = cities_from_selected, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

