# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(dplyr)
if (!exists ('NEI') | !exists ('SCC')) {
    setwd("~/Coursera/Johns Hopkins Data Science Specializition/Exploratory data analysis/Week4/Code")
    fileLoc <- '../Data/'
    NEI <- readRDS(paste0(fileLoc, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(fileLoc, "Source_Classification_Code.rds"))
}

# Find the indicies of the relevand SCC codes
mtrVehInd <- c (
    grep ('On-Road', SCC$EI.Sector),
    grep('Veh', SCC$Short.Name))%>%
    sort() %>%
    unique()

vehSCC <- SCC$SCC[mtrVehInd]

#Subset the Baltimorte data
bMore <- subset (NEI, fips == "24510") %>%
    subset(vehSCC %in% SCC, c(year, Emissions))

# Create a DF and preload it with the years
emTot <- data.frame(years = unique(bMore$year))
# load the DF with the 'total' emissions from each year
emTot$Emissions <- tapply (bMore$Emissions, bMore$year, sum)

png('plot5.png')
plot(emTot[,1], emTot[,2], type = 'l', lwd = 2, col = 'blue', xlab = 'Year',
     ylab = 'PM2.5 emissions [tons]')
points (emTot[,1], emTot[,2], lwd = 4, col = 'red')
title (main = 'Total pm 2.5 emissions from all motor vehicle sources in \n Baltimore, Maryland based on year')
dev.off()
