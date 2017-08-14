# cross the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

library(dplyr)

if (!exists ('NEI') | !exists ('SCC')) {
    setwd("~/Coursera/Johns Hopkins Data Science Specializition/Exploratory data analysis/Week4/Code")
    fileLoc <- '../Data/'
    NEI <- readRDS(paste0(fileLoc, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(fileLoc, "Source_Classification_Code.rds"))
}

coalInd <- c (
    grep ('coal|Coal', SCC$Short.Name),
    grep ('coal|Coal', SCC$EI.Sector),
    grep ('coal|Coal', SCC$EI.Sector),
    grep ('coal|Coal', SCC$Level.Three),
    grep ('coal|Coal', SCC$Level.Four)) %>%
    sort() %>%
    unique()

coalSCC <- SCC$SCC[coalInd]
Data <- subset(NEI, coalSCC %in% SCC, c(year, Emissions))

emTot <- data.frame(years = unique(Data$year))
# load the DF with the 'total' emissions from each year
emTot$Emissions <- tapply (Data$Emissions, Data$year, sum)


png('plot4.png')
plot(emTot[,1], emTot[,2], type = 'l', lwd = 2, col = 'blue', xlab = 'Year',
     ylab = 'Total emissions from coal sources [tons]')
points (emTot[,1], emTot[,2], lwd = 4, col = 'red')
title (main = 'Total pm 2.5 emissions from coal sources based on year')
dev.off()

