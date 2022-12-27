#PACOTES

library(dplyr)
library(RVenn)
library(igraph)
library(shiny)
library(shinydashboard)
library(flexdashboard)
library(visNetwork)
library(networkD3)

# UI e Server R

ui <- fluidPage(dashboardPage(title= 'the_coupler: Academic Genealogy', skin="purple", dashboardHeader(title = img(src="gc.png")), 
                              
                              dashboardSidebar(
                                
                                fileInput("file1", "Selecione o arquivo:", accept = ".txt"),
                                
                                selectInput("sep", "Separador:", c(" ", Vírgula = ",", Ponto_Vírgula = ";", Tabulado = "\t")),
                                
                                selectInput("normalization", "Normalizações:", c("sem normalização", "Cosseno de Salton", "Índice de Jaccard", "CAG")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="https://github.com/rafaelcastanha/The-Genealogic-Coupler", "Instruções e Código (GitHub)", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="https://zenodo.org/record/7130614#.YzdGCnbMLIU", "Arquivos para testes", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="https://zenodo.org/record/7275086#.Y2LqIHbMLIU", "Sobre a métrica CAG", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="http://lattes.cnpq.br/4834832439175113", "Currículo Lattes", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="https://www.researchgate.net/profile/Rafael-Gutierres-Castanha-2", "ResearchGate", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                fluidPage(tags$a(href="https://rafaelcastanha.shinyapps.io/thecoupler/", "The Coupler (Original)", style = "margin-left:15px;")),
                                
                                fluidPage(h5(" ")),
                                
                                out = fluidPage(p("Desenvolvido por:", style = "margin-left:15px;")), 
                                
                                out = fluidPage(p("Rafael Gutierres Castanha", style = "margin-top:-8px;margin-left:15px;")), 
                                
                                out = fluidPage(p("rafael.castanha@unesp.br", style = "margin-top:-10px;margin-left:15px;")),
                                
                                actionButton("runmodel", "Coupling!")),
                              
                              dashboardBody(tags$head(tags$style(HTML('
      .content-wrapper {
        background-color: #E2DDF0;
      }'))),
                                            tags$head(tags$style(HTML('
      .container-fluid {
    padding-right: 0px;
    padding-left: 0px;}'))),
                                            fluidRow(width = 12, height = NULL,
                                                     
                                                     tabsetPanel(type="tab",
                                                                 
                                                                 tabPanel(title=h5("Rede de Genealogia Acadêmica", style='color:black;'), column(textOutput("erro"), width = 12, visNetworkOutput(outputId = "PlotCoupling",  width = "100%", heigh=540))), 
                                                                 
                                                                 tabPanel(title=h5("Frequências de Acoplamento",style='color:black;'), dataTableOutput(outputId = "DataFrameCoupling"),downloadButton("dlfreq", "Download Data")),
                                                                 
                                                                 tabPanel(title=h5("Unidades de Acoplamento",style='color:black;'),style='overflow-x: scroll', dataTableOutput(outputId = "DataFrameUnits"),downloadButton("dlunits", "Download Data")),
                                                                 
                                                                 tabPanel(title=h5("Matriz de Citação",style='color:black;'), style='overflow-x: scroll', dataTableOutput(outputId = "DataFrameCit"),downloadButton("dlcit", "Download Data")),
                                                                 
                                                                 tabPanel(title=h5("Matriz de Acoplamento",style='color:black;'), style='overflow-x: scroll', dataTableOutput(outputId = "DataFrameMatrix"),downloadButton("dlaba", "Download Data")),
                                                                 
                                                                 tabPanel(title=h5("Matriz de Cocitação",style='color:black;'), style='overflow-x: scroll', dataTableOutput(outputId = "DataFrameCocit"),downloadButton("dlcocit", "Download Data"))
                                                                 
                                                     )))))

server <- function(input, output){
  
  observe({
    
    #Arquivo
    
    input$runmodel
    
    if (input$runmodel==0)
      return()
    else
      
      isolate({
        
        r<-reactive({input$file1})
        
        req(r())
        
      })
    
    corpus<-isolate(read.table(r()$datapath, header = FALSE, sep = input$sep, quote="\""))
    
    colnames(corpus)<-corpus[1,]
    corpus<-corpus[(-1),]
    hd<-gsub("\\.$","",names(corpus))
    colnames(corpus)<-hd
    
    #Corpus para dataframe
    
    corpus<-as.data.frame(corpus)
    
    #remover espaços e vazios
    
    corpus<-corpus
    corpus[corpus==""|corpus==" "|corpus=="   "]<-NA
    empty_columns<-sapply(corpus, function(x) all(is.na(x)|x==""))
    corpus<-corpus[,!empty_columns]
    
    #Contagem de itens citados por lista
    
    citados<-function(x){return(length(which(!is.na(x))))}
    itens_citados<-apply(X=corpus,FUN=citados,MARGIN=c(1,2))
    df1<-as.data.frame(itens_citados, header=TRUE)
    df2<-colSums(df1)
    df2<-as.data.frame(df2, header=TRUE)
    df2<-tibble::rownames_to_column(df2, "VALUE")
    colnames(df2)[1]<-"units"
    colnames(df2)[2]<-"refs"
    references<-df2
    
    #Transformação em objeto Venn
    
    corpus_aba<-Venn(corpus)
    
    #Intersecção Pareada: identificação das unidades de acoplamento
    
    ABA<-overlap_pairs(corpus_aba)
    ABA<-ABA[1:length(corpus)-1]
    ABA_GA<-ABA
    
    #Unidades por acoplamento
    
    
    unit_aba<-na.omit(stack(ABA))
    
    units_coupling<-unit_aba %>% group_by(ind) %>% summarise(valeus=(paste(values, collapse="; ")))
    
    units_final<-as.data.frame(units_coupling)
    
    colnames(units_final)[1]<-"Unidades de Análise"
    colnames(units_final)[2]<-"Unidades de Acoplamento"
    
    #Intensidades de ABA
    
    df<-as.data.frame(table(stack(ABA)))
     
    
    if (nrow(df)==0) {
      
      nodes <- data.frame(id = 1, shape = "icon", icon.face = 'Ionicons',
                          icon.code = c("f100"))
      edges <- data.frame(from = c(1))
      
      output$PlotCoupling<-renderVisNetwork({
        
        visNetwork(nodes=nodes, edges=edges,shape = "icon",
                   main="WARNING: No couplings between units (ALERTA: Não há acoplamento entre as unidades!)") %>% addIonicons()
        
      })
      
      stop
      
    }
    
    else {
      
      int_aba<-aggregate(Freq ~ ind, data = df, FUN = sum)
      Freq_ABA<-data.frame(do.call("rbind",strsplit(as.character(int_aba$ind),"...",fixed=TRUE)))
      Freq_ABA["Coupling"]<-int_aba$Freq
      colnames(Freq_ABA)[1]<-"Orientador"
      colnames(Freq_ABA)[2]<-"Orientandos"
      
      m2=merge(Freq_ABA,df2,by.x="Orientandos",by.y="units",all.x=TRUE)
      m1=merge(m2,df2,by.x="Orientador",by.y="units",all.x=TRUE)
      colnames(m1)[4]<-"L2"
      colnames(m1)[5]<-"L1"
      Freq_ABA<-m1 %>% select("Orientador","Orientandos","L1","L2","Coupling")
      
      #Normalizações 
      
      novacoluna<-c("Saltons_Cosine")
      Freq_ABA[,novacoluna]<-Freq_ABA$Coupling/sqrt(Freq_ABA$L1*Freq_ABA$L2)
      novacoluna_2<-c("Jaccard_Index")
      Freq_ABA[,novacoluna_2]<-Freq_ABA$Coupling/(Freq_ABA$L1+Freq_ABA$L2-Freq_ABA$Coupling)
      novacoluna_3<-c("CAG")
      Freq_GA<-Freq_ABA
      Freq_GA[,novacoluna_3]<-Freq_ABA$Coupling/references[1,2]
      Freq_GA<-Freq_GA[1:(length(corpus)-1),]
      Freq_ABA<-Freq_GA
            
      #Rede de acoplamento bibliográfico
      
      net_list<-filter(Freq_ABA, Coupling>0)
      links<-data.frame(source=c(net_list$Orientador), target=c(net_list$Orientandos))
      network_ABA<-graph_from_data_frame(d=links, directed=F)
      
      edge_ABA<-net_list$Coupling
      edge_CS<-net_list$Saltons_Cosine
      edge_IJ<-net_list$Jaccard_Index
      edge_CAG<-net_list$CAG
      
      node1<-as.data.frame(references$units)
      node2<-as.data.frame(references$units)
      colnames(node1)[1]<-"id"
      colnames(node2)[1]<-"label"
      node<-data.frame(node1, node2)
      
      ED_coupling<-mutate(links, width = edge_ABA)
      colnames(ED_coupling)[1]<-"from"
      colnames(ED_coupling)[2]<-"to"
      
      ED_salton<-mutate(links, width = edge_CS*10)
      colnames(ED_salton)[1]<-"from"
      colnames(ED_salton)[2]<-"to"
      
      ED_jaccard<-mutate(links, width = edge_IJ*10)
      colnames(ED_jaccard)[1]<-"from"
      colnames(ED_jaccard)[2]<-"to"
      
      ED_CAG<-mutate(links, width = edge_CAG*10)
      colnames(ED_CAG)[1]<-"from"
      colnames(ED_CAG)[2]<-"to"
      
      #Matrizes Adjacencia
      
      dt<-stack(corpus)
      dt2<-table(dt$values[row(dt[-1])], unlist(dt[-1]))
      mtx_cit<-t(dt2)
      mtx_cocit<-(t(mtx_cit) %*% mtx_cit)
      mtx_cocit<-as.table(mtx_cocit)
      
      #Matriz Acoplamento
      
      mtx_aba<-(mtx_cit %*% t(mtx_cit))
      diag(mtx_aba)<-0
      mtx_aba<-as.data.frame(mtx_aba)
      mtx_aba<-tibble::rownames_to_column(mtx_aba, " ")
      
      #Matriz de Citação
                
      mtx_cit<-as.data.frame.matrix(mtx_cit)
      mtx_cit<-tibble::rownames_to_column(mtx_cit, " ")
      
      #Matriz Cocitação
            
      mtx_cocit_df<-as.data.frame(mtx_cocit)
      links_cocit<-data.frame(source=c(mtx_cocit_df$Var1), target=c(mtx_cocit_df$Var2))
      network_cocit<-graph_from_data_frame(d=links_cocit, directed=T)
      E(network_cocit)$weight<-mtx_cocit_df$Freq
      mtx_adj_cocit<-as_adjacency_matrix(network_cocit, attr="weight")
      mtx_adj_cocit_df<-as.data.frame(as.matrix(mtx_adj_cocit))
      mtx_adj_cocit_df<-tibble::rownames_to_column(mtx_adj_cocit_df, " ")
      
      #Outputs
                      
      output$erro<-renderText({
        
        input$runmodel
        
        if (nrow(df)!=0) {print(" ")}
        
      })
      
      #Plots
   
      output$PlotCoupling <- renderVisNetwork({
        
        input$runmodel
        
        if ("sem normalização" %in% input$normalization){
          
          visNetwork(node, ED_coupling) %>%
            visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
            visEdges(arrows = "to") %>%
            visHierarchicalLayout(sortMethod="directed")}
        
        else{
          
          if ("Cosseno de Salton" %in% input$normalization){
            
            visNetwork(node, ED_salton) %>%
              visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
              visEdges(arrows = "to") %>%
              visHierarchicalLayout(sortMethod="directed")}
          
          else{        
            
            if  ("Índice de Jaccard" %in% input$normalization){
              
              visNetwork(node, ED_jaccard) %>%
                visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
                visEdges(arrows = "to") %>%
                visHierarchicalLayout(sortMethod="directed")}
            
            else{
              
              if  ("CAG" %in% input$normalization)
                
                visNetwork(node, ED_CAG) %>%
                visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
                visEdges(arrows = "to") %>%
                visHierarchicalLayout(sortMethod="directed")
              
            }
            
          }
        }
        
      })
      
      #Output Tabelas
      
      output$DataFrameCoupling <- renderDataTable(Freq_ABA)
      
      output$DataFrameUnits <- renderDataTable(units_final)
      
      output$DataFrameCit <- renderDataTable(mtx_cit)
      
      output$DataFrameMatrix <- renderDataTable(mtx_aba)
      
      output$DataFrameCocit <- renderDataTable(mtx_adj_cocit_df)
      
      #Downloads
      
      output$dlfreq <- downloadHandler(
        filename = function(){
          paste("Frequências de Acoplamento", "txt", sep=".")
        },
        content = function(file){
          write.table(Freq_ABA, file, sep="\t", row.names = F, col.names = TRUE)
        })
      
      output$dlunits <- downloadHandler(
        filename = function(){
          paste("Unidades de Acoplamento", "txt", sep=".")
        },
        content = function(file){
          write.table(units_final, file, sep="\t", row.names = F, col.names = TRUE)
        })
      
      output$dlcit <- downloadHandler(
        filename = function(){
          paste("Matriz de Citacao", "txt", sep=".")
        },
        content = function(file){
          write.table(mtx_cit, file, sep="\t", row.names = F, col.names = TRUE)
        })
      
      
      output$dlaba <- downloadHandler(
        filename = function(){
          paste("Matriz de Acoplamento", "txt", sep=".")
        },
        content = function(file){
          write.table(mtx_adj, file, sep="\t", row.names = F, col.names = TRUE)
        })
      
      output$dlcocit <- downloadHandler(
        filename = function(){
          paste("Matriz de Cocitacao", "txt", sep=".")
        },
        content = function(file){
          write.table(mtx_adj_cocit_df, file, sep="\t", row.names = F, col.names = TRUE)
        })
    }
    
  })
  
}

 #Rodar The Genealogic Coupler      
          
shinyApp(ui, server)
