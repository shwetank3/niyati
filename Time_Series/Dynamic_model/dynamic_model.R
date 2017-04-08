setwd("C:/Users/shwetank/Desktop/SEM3/Time-Series/project/data_file")
library(readr)
temp = list.files(pattern="*.csv")
myfiles = lapply(temp, read_csv)
summary(myfiles)
head(myfiles[1])
########### Shifting Columns where Wind-Chill is missing#########
head(myfiles[[2]][(regexpr("%",myfiles[[2]]$`Dew point`))>0,])
myfiles[[2]]$X14 = NA                                   
myfiles[[2]]$X15 = NA                              
myfiles[[2]]$X16 = NA                              
myfiles[[2]]$X17 = NA
for (i in 1:4){
myfiles[[i]][(regexpr("%",myfiles[[i]]$`Dew point`))>0,][, c(5:17)] <- myfiles[[i]][(regexpr("%",myfiles[[i]]$`Dew point`))>0,][, c(17,5:16)]
myfiles[[i]][is.na(myfiles[[i]]$Windchill),5] = "-"}
View(myfiles[[1]])

##################################################################





###################Combining Data in one format######
#weather = {}                                       #
#myfiles[[2]]$X14 = NA                              #        
#myfiles[[2]]$X15 = NA                              #
#myfiles[[2]]$X16 = NA                              #
#myfiles[[2]]$X17 = NA                              #
#                                                   #
#for (i in (1:length(myfiles))) {                   #
#  print(i)                                         #
#weather = rbind(weather,myfiles[[i]])}             #
#                                                   #
########### Dirty Cleaning ##########################
#View(myfiles[1])                                   #
#View(myfiles[2])                                   #
#View(myfiles[3])                                   #
#View(myfiles[4])                                   #  
#sum = 0                                            #  
#for (i in (1:4)){                                  #  
#  sum = sum + dim(myfiles[[i]])[1]}                #
#myfiles[[1]][!is.na(myfiles[[1]]$X17),c(1,2,3,17)] #
#myfiles[[1]][(myfiles[[1]]$`AM/PN`)=="AM",]        #
#a = c("212%","0.3%4a3%","4","5")                   #
#pos <- regexpr('%', a)                             #
#a[(pos>0)]                                         # 
#trial <- myfiles[[1]]                              #
#df <- trial[(regexpr("%",myfiles[[1]]$`Dew point`))>0,]
#df[, c(6:17)] = df[, c(17,6:16)]                    #
########### Dirty Cleaning ##########################
head(weather)
plot(weather$Date,weather$Humidity)






