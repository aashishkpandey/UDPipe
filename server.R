#-----------------------------------------#
# Server.R UDPipe App
#-----------------------------------------#
shinyServer(function(input, output) {
  
  Dataset <- reactive({
    if (is.null(input$file1)) { return(NULL) }
    else{
      text <- readLines(input$file1$datapath)
      text = str_replace_all(text, "<.*?>", "")
      text = text[text != ""]
      
      return(text)
    }
  })
  
  english_model = reactive({
    english_model = udpipe_load_model("english-ud-2.0-170801.udpipe")  # file_model only needed  
    return(english_model)
  })
  
  
  annot.obj = reactive({
    
    x <- udpipe_annotate(english_model(), x = Dataset()) #%>% as.data.frame() %>% head()
    x <- as.data.frame(x)
    return(x)
    
  })
  
  output$dout1 = renderDataTable({
    if (is.null(input$file1)) { return(NULL) }
    else{
    out = annot.obj()[,-4] # Remove sentence
    return(out)
    }
  })

  output$plot1 = renderPlot({ 
    if (is.null(input$file1)) { return(NULL) }
    else{
    all_nouns = annot.obj() %>% subset(., upos %in% "NOUN") 
    top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
    
    wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3,colors = 1:10)
    }
  })
  
  
  output$plot2 = renderPlot({ 
    if (is.null(input$file1)) { return(NULL) }
    else{
    all_verbs = annot.obj() %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(all_verbs$lemma)
    head(top_verbs, 10)
    wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3, colors = 1:10)
    }
  })
  
  
  output$plot3 = renderPlot({ 
    if (is.null(input$file1)) { return(NULL) }
    else{
    nokia_cooc <- cooccurrence(     # try `?cooccurrence` for parm options
      x = subset(annot.obj(), upos %in% input$upos), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
    
    wordnetwork <- head(nokia_cooc, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences Plot", subtitle = "Nouns & Adjective")
    }
  })
})
