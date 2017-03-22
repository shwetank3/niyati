#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Crime Report"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          selectInput("choice.factor", label = h3("Choose the Graph"), 
                     choices = list("City Count"=1,"Gender of Killer"=2,"Alchohol Factor"=3,"Drug Factor"=4, 
                                    "Mode of Killing"=5,"Span of Crime"=6,"No. of Victim (Minor)"=7,"Span (Minor)"=8,"Age Series (sex of Victim)"=9), 
                     selected = 1),
          checkboxGroupInput("data", label = h3("Attributes"), 
                             choices = list("Name" = 1,"Country" = 8, "City" = 11, "Birth Year"=13,"Type"=24, "Occupation"=49, "Method"=60),
                             selected = 1)
         ),
 
         # Show a plot of the generated distribution
      mainPanel(
        plotOutput("map",click = "plot_click"),
        verbatimTextOutput("info"),
        dataTableOutput("crimefactor"))
        
   )
)
library(readr)
library(ggplot2)
library(plyr)
library(plotly)
library(tidyr)  
killer <- read_csv("Serial Killers Data.csv", col_types = cols(KillMethod = col_character()))
del.killer <- c("PerfIQ","VerbalIQ","LocAbduct","Nickname","IQ2","Chem","Fired","GetToCrime","XYY","Killed",
                "Combat","BedWet","AgeEvent","IQ1","PsychologicalDiagnosis","Otherinformation","News",
                "DadSA","DadStable","LivChild","LocKilling","PoliceGroupie","MomSA","ParMarSta","Fire",
                "AppliedCop","Attrac","LiveWith","Educ","FamEvent","MomStable","Mental","Animal",
                "HeadInj","PartSex")
killer <- killer[,!names(killer) %in% del.killer,drop=F]
########City count
city.split <- strsplit(as.character(killer$City),',')
citylist <- as.data.frame(matrix(unlist(city.split)))
city.count <- count(citylist)
city.count.top <- city.count[order(-city.count$freq),][2:31,]
city.pic <- ggplot(data = city.count.top,aes(x = reorder(city.count.top$V1,city.count.top$freq), y = city.count.top$freq))+geom_bar(stat = "identity",fill = "red")+
  xlab("City")+ylab("Freq")+ggtitle("City count")+coord_flip()

########Gender count
gender.count <- count(killer$Sex)[-3,]
gender.dict <-list('1'="Male",'2'="Female")
gender.count[[1]]  <-gender.dict[gender.count[[1]]] 
gender.pic<-ggplot(data = gender.count , aes(x=as.character(gender.count$x),y=gender.count$freq) )+geom_bar(stat = "identity")+xlab("Gender")+ylab("count")+ggtitle("Gender of Killer")

####################### Alcohol
alcohol.count <- count(killer$Killerabusealcohol)[-(3:4),]
alcohol.dict<-c("No","Yes")
map<-setNames(alcohol.dict,alcohol.count$x)
alcohol.count$x<-map[as.character(alcohol.count$x)]
alcohol.pic<-ggplot(data = alcohol.count , aes(x=as.character(alcohol.count$x),y=alcohol.count$freq) )+geom_bar(stat = "identity")+xlab("Killer abuse Alcohol")+ylab("count")+ ggtitle("Did Killer abuse alcohol") 

####################### Drugs
drugs.count <- count(killer$Killerabusedrugs)[-(3:4),]
drugs.count$x <- mapvalues(drugs.count$x,from = c("0","1"),to=c("No","Yes") )
drugs.pic<-ggplot(data = drugs.count , aes(x=as.character(drugs.count$x),y=drugs.count$freq) )+geom_bar(stat = "identity")+xlab("Killer abuse Alcohol")+ylab("count")+ggtitle("Did Killer abuse drugs")

####################### Method of Killing
killmethod.split <- strsplit(as.character(killer$KillMethod),',')
killmethodlist <- as.data.frame(matrix(unlist(killmethod.split)))
killmethod.count <- count(killmethodlist)
###map from list
killmethod.count$V1 <- mapvalues(killmethod.count$V1,from = c("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","18","21","22","25","27"),
                                 to = c("Unknown",'Bludgeon' ,'Gun','Poison','Stabbing','Strangulation','Pills','Bomb',
                                        'Suffication','Gassed','Drown','Fire','Starved/Neglect','Shaken',
                                        'Axed','Hanging','RanOver','AlcoholPoisoning','DrugOverdose','WithdrewTreatment','LiveAbortions' ))
killmethod.count.top <- killmethod.count[order(-killmethod.count$freq),]
methodkill.pic<-ggplot(data = killmethod.count.top,aes(x = reorder(killmethod.count.top$V1,killmethod.count.top$freq), y = killmethod.count.top$freq))+geom_bar(stat = "identity",fill = "red")+xlab("Kill Method")+ylab("Freq")+ggtitle("Method used to Kill")+coord_flip()

####################### Year between first and last
duration.pic2<-ggplot(killer, aes(x=killer$YearsBetweenFirstandLast, y=killer$NumVics)) +geom_point(size=2, shape=23)
###Filter  numvics<150
timekill <- as.data.frame(cbind(killer$YearsBetweenFirstandLast, killer$NumVics)[killer$NumVics<150,])
duration.pic <- ggplot(timekill, aes(x=timekill[,1], y=timekill[,2])) + geom_point(size=2, shape=23)+xlab("Year between first and last")+ylab("Number of Victims")

####################### Minor ##Number of Victim
killer$Minorr <- killer$Age1stKill
killer$Minorr[killer$Age1stKill<18]<-"Minor"
killer$Minorr[!killer$Age1stKill<18]<-"Adult"
legend_title <- "OMG My Title"
minor.vicnum.pic <- ggplot(killer,aes(killer$NumVics,colour = killer$Minorr))+geom_density(size= 1)+xlab("Number of Victims")+ labs(colour='Age Group')

####################### Minor ##Year between first and last
killer$Minorr <- killer$Age1stKill
killer$Minorr[killer$Age1stKill<18]<-"Minor"
killer$Minorr[!killer$Age1stKill<18]<-"Adult"
minor.duration.pic <- ggplot(killer,aes(killer$YearsBetweenFirstandLast,colour = killer$Minorr))+geom_density(size= 1)+xlab("Year between first and last")+ labs(colour='Age Group')

####################### Age Series of Killer
vicsexx <- killer$VicSex
vicsexx[killer$VicSex=="1"]<-"Male"
vicsexx[killer$VicSex=="2"]<-"Female"
vicsexx[killer$VicSex=="3"]<-"Both"
vicesexx<-vicsexx[!(is.na(killer$VicSex)|(killer$VicSex=="9"))]
Ageseriess <- killer$AgeSeries[!(is.na(killer$VicSex)|(killer$VicSex=="9"))]
agevicsex <-as.data.frame(Ageseriess,vicesexx)
age.vicsex.pic <- ggplot(agevicsex,aes(Ageseriess,colour = vicesexx))+geom_density(size= 1)+xlab("Age Series of Killer")+ labs(colour='Gender of Victim')

# Define server logic required to draw a histogram
server <- function(input, output) {
   output$map   <- renderPlot({
   switch(input$choice.factor,  
   '1'= city.pic,
   '2'= gender.pic, 
   '3'= alcohol.pic, 
   '4'= {drugs.pic},
   '5'=methodkill.pic, 
   '6'=duration.pic,
   '7'=minor.vicnum.pic, 
   '8'=minor.duration.pic, 
   '9'=age.vicsex.pic    ) 
   },height=400, width =400)
   
   output$info <- renderText({
     paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
   })
   output$crimefactor <- renderDataTable(
    killer[,as.integer(input$data)], options = list(pageLength = 5)
   )
}

# Run the application 
shinyApp(ui = ui, server = server)
