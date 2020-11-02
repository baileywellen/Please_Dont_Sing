#Code to publish a Shiny App which can play audio and collect reviews on 88 recordings of "Happy Birthday", saving them to a Google Sheet

library(shiny)
library(DT)
library(googlesheets4)
library(shinyjs)
library(shinythemes)

get_random_files <- function(select, total_files){
  #generate a vector of random numbers
  rand_indices <- sample(0:(total_files - 1), select, replace=F)
  
  ret_val <- c()
  
  #create strings with those random numbers in the form "recording[num].mp3" to send to the UI 
  for(val in rand_indices)
  {
    ret_val <- c(ret_val, (paste("recording", val, ".mp3", sep = "")))
    
  }
  
  return(ret_val)
}

#initialize the random recordings by pulling 5 files that the user will listen to
random_recordings <- get_random_files(5,88)

#---------------------------------------------------------------------------------------------------------------------------------------------
#authentication
gs4_auth(email = "my_email@gmail.com", path = "filepath_to_my_service_account")

#----------------------------------------------------------------------------------------------------------------------------------------------
#save the google sheet data 
our_sheet <- gs4_get("link_to_my_google_sheet")

saveData <- function(data) {
  # Add the data as a new row
  sheet_append(our_sheet, data)
}

# Define the fields we want to save from the form
fields <- c("name", "rating_id", "rating")

# Create the UI where the user can listen to recordings and submit ratings 
ui <- fluidPage(
    theme = shinytheme("spacelab"),
    useShinyjs(),
    shinyjs::hidden(textOutput(outputId = "goodbye")),
    textOutput(outputId = "message_to_user"),
    textInput(inputId = "name", label = "Full Name", value = ""),
    
    verbatimTextOutput(outputId = "title1"),
    fluidRow(column(12, align = "center",
    div(id = 'audiodiv1', tags$audio(inputId = "audio1", src = random_recordings[1], type = "audio/mp3", controls = TRUE)
        ),
    sliderInput(inputId = "rating1", label = "What do you rate this recording?",
                min = 1, max = 10, value=  1, ticks = TRUE))),
    
    
    verbatimTextOutput(outputId = "title2"),
    fluidRow(column(12, align = "center",
    div(id = 'audiodiv2',tags$audio(inputId = "audio2", src = random_recordings[2], type = "audio/mp3", controls = TRUE)
        ),
    sliderInput(inputId = "rating2", label = "What do you rate this recording?",
                min = 1, max = 10, value=  1, ticks = TRUE))),
    
    
    verbatimTextOutput(outputId = "title3"),
    fluidRow(column(12, align = "center",
    div(id = 'audiodiv3', tags$audio(inputId = "audio2", src = random_recordings[3], type = "audio/mp3", controls = TRUE)
        ),
    sliderInput(inputId = "rating3", label = "What do you rate this recording?",
                min = 1, max = 10, value=  1, ticks = TRUE))),
    
    
    verbatimTextOutput(outputId = "title4"),
    fluidRow(column(12, align = "center",
    div(id = 'audiodiv4', tags$audio(inputId = "audio4", src = random_recordings[4], type = "audio/mp3", controls = TRUE)
    ),
    sliderInput(inputId = "rating4", label = "What do you rate this recording?",
                min = 1, max = 10, value=  1, ticks = TRUE))),
    
    
    verbatimTextOutput(outputId = "title5"),
    fluidRow(column(12, align = "center",
    div(id = 'audiodiv5', tags$audio(inputId = "audio5", src = random_recordings[5], type = "audio/mp3", controls = TRUE)
    ),
    sliderInput(inputId = "rating5", label = "What do you rate this recording?",
                min = 1, max = 10, value=  1, ticks = TRUE))),
    actionButton("submit", "Submit"),

    #we will start the "start over" option as hidden
    shinyjs::hidden( actionButton("start_over", "Want to Rate More Recordings?"))
    #)
   
)
  
#Create the server 
server <- function(input, output, session) {
    next_recordings <- reactiveValues(recording_ids = random_recordings)
     
    # When they hit submit, we save the form data 
    formData <- reactive({
      data <- data.frame("name" = rep(input$name, times = 5), "rating_id" = next_recordings$recording_ids, "rating" = c(input$rating1, input$rating2, input$rating3, input$rating4, input$rating5))
      data
    })

    
    #fill in the output text for the titles, thank you message, and instructions
    output$message_to_user <- renderText("Thank you for volunteering to help with my thesis! Please listen to the recordings below and email bwellen@carthage.edu with any questions")
    output$goodbye <- renderText("Thank you for participating! We have collected your answers. If you do not want to rate more, please close this page.")
    output$title1 <- renderText("Recording 1:")
    output$title2 <- renderText("Recording 2:")
    output$title3 <- renderText("Recording 3:")
    output$title4 <- renderText("Recording 4:")
    output$title5 <- renderText("Recording 5:")
    
    # When the Submit button is clicked, save the form data and change the screen
    observeEvent(input$submit, {
      if(input$name != "")
      {
        saveData(formData())
        shinyjs::show(id = "goodbye")
        shinyjs::hide(id = "name")
        
        #hide the slider bars
        shinyjs::hide(id = "rating1")
        shinyjs::hide(id = "rating2")
        shinyjs::hide(id = "rating3")
        shinyjs::hide(id = "rating4")
        shinyjs::hide(id = "rating5")
        
        #hide the titles
        shinyjs::hide(id = "title1")
        shinyjs::hide(id = "title2")
        shinyjs::hide(id = "title3")
        shinyjs::hide(id = "title4")
        shinyjs::hide(id = "title5")
        
        shinyjs::hide(id = "submit")
        shinyjs::show(id = "start_over")
        shinyjs::hide(id = "message_to_user")
        
        
        #remove the 5 play buttons from what they just listened to 
        removeUI(
          selector = "#audiodiv1"
        )
        removeUI(
          selector = "#audiodiv2"
        )
        removeUI(
          selector = "#audiodiv3"
        )
        removeUI(
          selector = "#audiodiv4"
        )
        removeUI(
          selector = "#audiodiv5"
        )

      }
      else
      {
        output$message_to_user <- renderText("Please enter your full name.")
      }
      })
    
    
    #if they press start over, reset to the settings from the beginning
    observeEvent(input$start_over, {
      shinyjs::show(id = "name")
      output$message_to_user <- renderText("Thank you for volunteering to help with my thesis! Please listen to the recordings below and email me with any questions")
      
      #Show the sliders again and set them back to 1
      shinyjs::show(id = "rating1")
      shinyjs::show(id = "rating2")
      shinyjs::show(id = "rating3")
      shinyjs::show(id = "rating4")
      shinyjs::show(id = "rating5")
      updateSliderInput(session = session, inputId = "rating1", label = "What do you rate this recording?", min = 1, max = 10, value = 1)
      updateSliderInput(session = session, inputId = "rating2", label = "What do you rate this recording?", min = 1, max = 10, value = 1)
      updateSliderInput(session = session, inputId = "rating3", label = "What do you rate this recording?", min = 1, max = 10, value = 1)
      updateSliderInput(session = session, inputId = "rating4", label = "What do you rate this recording?", min = 1, max = 10, value = 1)
      updateSliderInput(session = session, inputId = "rating5", label = "What do you rate this recording?", min = 1, max = 10, value = 1)
      
      #Show the titles again
      shinyjs::show(id = "title1")
      shinyjs::show(id = "title2")
      shinyjs::show(id = "title3")
      shinyjs::show(id = "title4")
      shinyjs::show(id = "title5")
      
      
      shinyjs::show(id = "submit")
      shinyjs::hide(id = "start_over")
      shinyjs::hide(id = "goodbye")
      shinyjs::show(id = "message_to_user")
      
      #select new random numbers 
      next_recordings$recording_ids <- get_random_files(5,88)
      
      #Insert the 5 newly randomized recordings for the user to rate 
      insertUI(
        selector = "#title1",
        where = "afterEnd",
        fluidRow(column(12, align = "center",
        div(id = "audiodiv1", tags$audio(inputId = "audio1", src = next_recordings$recording_ids[1], type = "audio/mp3", controls = TRUE))))
      )
      insertUI(
        selector = "#title2",
        where = "afterEnd",
        fluidRow(column(12, align = "center",
        div(id = "audiodiv2", tags$audio(inputId = "audio2", src = next_recordings$recording_ids[2], type = "audio/mp3", controls = TRUE))))
        
      )
      insertUI(
        selector = "#title3",
        where = "afterEnd",
        fluidRow(column(12, align = "center",
        div(id = "audiodiv3", tags$audio(inputId = "audio3", src = next_recordings$recording_ids[3], type = "audio/mp3", controls = TRUE))))
        
      )
      insertUI(
        selector = "#title4",
        where = "afterEnd",
        fluidRow(column(12, align = "center",
        div(id = "audiodiv4", tags$audio(inputId = "audio4", src = next_recordings$recording_ids[4], type = "audio/mp3", controls = TRUE))))
        
      )
      insertUI(
        selector = "#title5",
        where = "afterEnd",
        fluidRow(column(12, align = "center",
        div(id = "audiodiv5", tags$audio(inputId = "audio5", src = next_recordings$recording_ids[5], type = "audio/mp3", controls = TRUE))))
        
      )
    })
}


#Knit the UI and the server together 
shinyApp(ui = ui, server = server)

