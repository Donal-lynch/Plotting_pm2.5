# make a plot showing the total PM2.5 emission from all sources for each of
# the years 1999, 2002, 2005, and 2008.

library(dplyr)

if (!exists ('NEI') | !exists ('SCC')) {
    setwd("~/Coursera/Johns Hopkins Data Science Specializition/Exploratory data analysis/Week4/Code")
    fileLoc <- '../Data/'
    NEI <- readRDS(paste0(fileLoc, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(fileLoc, "Source_Classification_Code.rds"))
}

# Create a DF and preload it with the years
emTot <- data.frame(years = unique(NEI$year))
# load the DF with the 'total' emissions from each year
emTot$Emissions <- tapply (NEI$Emissions, NEI$year, sum) 


png('plot1.png')
plot(emTot[,1], emTot[,2], type = 'l', lwd = 2, col = 'blue', xlab = 'Year',
     ylab = 'Total emissions from all sources [tons]')
points (emTot[,1], emTot[,2], lwd = 4, col = 'red')
title (main = 'Total pm 2.5 emissions from all sources based on year')
dev.off()
