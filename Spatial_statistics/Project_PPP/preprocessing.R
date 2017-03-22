######## Basic Processing
data<-dataset_process[!is.na(dataset_process$Northing),]   #Remove NA       data[-1,-2]
data<-dataset_process[complete.cases(dataset_process[,11]),]   #other format to remove NA
View(data)

######### Overall Data
sortedz <- dataset_process[order(dataset_process$Northing),]
coord <- cbind(dataset_process$Easting,dataset_process$Northing)
plot(coord)

###########Locations###############
sortedz <- data[order(data$Site.NGR),]       #Get to know the no. of points in each location 

NS <- data[grep("NS",data$Site.NGR),]
nrow(NS)
coord.NS <- cbind(NS$Easting,NS$Northing)
plot(coord.NS)

SJ <- data[grep("SJ",data$Site.NGR),]
nrow(SJ)
coord.SJ <- cbind(SJ$Easting,SJ$Northing)
plot(coord.SJ)

SK <- data[grep("SK",data$Site.NGR),]
nrow(SK)
coord.SK <- cbind(SK$Easting,SK$Northing)
plot(coord.SK)

SO <- data[grep("SO",data$Site.NGR),]
nrow(SO)
coord.SO <- cbind(SO$Easting,SO$Northing)
plot(coord.SO)

SP <- data[grep("SP",data$Site.NGR),]
nrow(SP)
coord.SP <- cbind(SP$Easting,SP$Northing)
plot(coord.SP)

ST <- data[grep("ST",data$Site.NGR),]
nrow(ST)
coord.ST <- cbind(ST$Easting,ST$Northing)
plot(coord.ST)

#############Operators################
sortedz <- data[order(data$Operator),]       #Get to know the no. of points with each operator 
unique(data$Operator)

nrow(data[data$Operator=='Airwave',])
Airwave <- data[data$Operator=='Airwave',]
coord.Airwave <- cbind(Airwave$Easting,Airwave$Northing)
plot(coord.Airwave)

nrow(data[data$Operator=='Network Rail',])
Network_Rail <- data[data$Operator=='Network Rail',]
coord.Network_Rail <- cbind(Network_Rail$Easting,Network_Rail$Northing)
plot(coord.Network_Rail)

nrow(data[data$Operator=='O2',])
O2 <- data[data$Operator=='O2',]
coord.O2 <- cbind(O2$Easting,O2$Northing)
plot(coord.O2)

nrow(data[data$Operator=='Orange',])
Orange <- data[data$Operator=='Orange',]
coord.Orange <- cbind(Orange$Easting,Orange$Northing)
plot(coord.Orange)

nrow(data[data$Operator=='Three',])
Three <- data[data$Operator=='Three',]
coord.Three <- cbind(Three$Easting,Three$Northing)
plot(coord.Three)

nrow(data[data$Operator=='T-Mobile',])
T_Mobile <- data[data$Operator=='T-Mobile',]
coord.T_Mobile <- cbind(T_Mobile$Easting,T_Mobile$Northing)
plot(coord.T_Mobile)

nrow(data[data$Operator=='Vodafone',])
Vodafone <- data[data$Operator=='Vodafone',]
coord.Vodafone <- cbind(Vodafone$Easting,Vodafone$Northing)
plot(coord.Vodafone)

################Mixed Plots#############
provider <- data[data$Operator=='Airwave',]
filtered.data <- provider[grep("ST",provider$Site.NGR),]
coord.filtered.data <- cbind(filtered.data$Easting,filtered.data$Northing)
plot(coord.filtered.data)
nrow(coord.filtered.data)
