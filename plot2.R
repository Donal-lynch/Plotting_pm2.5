# Have total emissions from PM2.5 decreased in the
# Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base
# plotting system to make a plot answering this question.

library(dplyr)

if (!exists ('NEI') | !exists ('SCC')) {
    setwd("~/Coursera/Johns Hopkins Data Science Specializition/Exploratory data analysis/Week4/Code")
    fileLoc <- '../Data/'
    NEI <- readRDS(paste0(fileLoc, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(fileLoc, "Source_Classification_Code.rds"))
}

#Subset the Baltimorte data. Discard unrequired data too
bMore <- subset (NEI, fips == "24510", c('Emissions', 'year'))

# Create a DF and preload it with the years
emTot <- data.frame(years = unique(bMore$year))
# load the DF with the 'total' emissions from each year
emTot$Emissions <- tapply (bMore$Emissions, bMore$year, sum) 

png('plot2.png')
plot(emTot[,1], emTot[,2], type = 'l', lwd = 2, col = 'blue', xlab = 'Year',
     ylab = 'Total emissions from all sources [tons]')
points (emTot[,1], emTot[,2], lwd = 4, col = 'red')
title (main = 'Total pm 2.5 emissions from all sources in \n Baltimore, Maryland based on year')
dev.off()
