library(wordcloud)

# Server function
function(input, output, session) {
  
  # Choose language code in the read function (en, de, fr, ...)
  text_dataset <<- read_dataset("en")
  
  # Define a reactive expression for words frequencies per sentiment
  terms <- reactive({
    input$selection
    isolate({
      withProgress({
        setProgress(message = "Processing word cloud ...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  output$plot <- renderPlot({
    words_and_frequencies <- terms()
    wordcloud(words = words_and_frequencies$word,
                  freq = words_and_frequencies$freq, min.freq = input$freq,
                  max.words=input$max, random.order=FALSE, rot.per=0.35,
                  colors=brewer.pal(8, "Dark2"))
  })
}


