#-----------------------------------------#
# ui.R UDPipe App
#-----------------------------------------#

library("shiny")

if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(ggplot2)){install.packages("ggplot2")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(stringr)){install.packages("stringr")}

library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

#-----------------------------------------#
#-----------------------------------------#

shinyUI(
  fluidPage(
    
    titlePanel("UDPipe Text Analysis"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file1", "Upload text file"),
        
        checkboxGroupInput("upos", 
                           label = h3("Select UPS for co-occurrences filtering"), 
                           choices = list("Adjective" = 'ADJ', 
                                          "Noun" = "NOUN", 
                                          "Proper Noun" = "PROPN",
                                          "Adverb" = 'ADV',
                                          "Verb" ='VERB' ),
                           selected = c("ADJ","NOUN","PROPN"))
      ),   # end of sidebar panel
      # adjective (ADJ)
      # noun(NOUN)
      # proper noun (PROPN)
      # adverb (ADV)
      # verb (VERB)
      
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only text files. ",align="justify"),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload text file")),
                               'and uppload the text file.')),
                    tabPanel("Annotation", 
                             dataTableOutput('dout1')),
                    
                    tabPanel("Plots",
                             h3("Nouns"),
                             plotOutput('plot1'),
                             h3("Verbs"),
                             plotOutput('plot2')),
                    
                    tabPanel("Co-occurrences",
                             plotOutput('plot3'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI



