# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037")
# Which city has seen greater changes over time in motor vehicle emissions?


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

#Subset the California data
Cali <- subset (NEI, fips == "06037") %>%
    subset(vehSCC %in% SCC, c(year, Emissions))

# Create a DF and preload it with the years
emTot <- data.frame(years = unique(bMore$year))
# load the DF with the 'total' emissions from each year
emTot$Emissions.Bali <- tapply (bMore$Emissions, bMore$year, sum)
emTot$Emissions.Cali <- tapply (Cali$Emissions, Cali$year, sum)

rng <- range(emTot$Emissions.Bali,emTot$Emissions.Cali )

png('plot6.png')
plot(emTot[,1], emTot[,2], type = 'l', lwd = 2, col = 'steelblue', xlab = 'Year',
     ylab = 'PM2.5 emissions [tons]', ylim = rng)
points (emTot[,1], emTot[,2], lwd = 4, col = 'deepskyblue1')
lines (emTot[,1], emTot[,3], lwd = 2, col = 'tomato4')
points (emTot[,1], emTot[,3], lwd = 4, col = 'tomato')
legend('topright', c('Baltimore', 'California'), col = c('deepskyblue1', 'tomato'), pch = 19)

title (main = 'Total pm 2.5 emissions from all motor vehicle sources in \n Baltimore and California')
dev.off()
