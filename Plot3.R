# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in emissions
# from 1999–2008 for Baltimore City? Which have seen increases in emissions from
# 1999–2008? Use the ggplot2 plotting system to make a plot answer this question

library(dplyr)
library(ggplot2)

if (!exists ('NEI') | !exists ('SCC')) {
    setwd("~/Coursera/Johns Hopkins Data Science Specializition/Exploratory data analysis/Week4/Code")
    fileLoc <- '../Data/'
    NEI <- readRDS(paste0(fileLoc, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(fileLoc, "Source_Classification_Code.rds"))
}


# Use tapply twice, on year and type. Makes Wide format vector
byTypeW <- with (NEI, tapply (Emissions, list(year, type), sum)) %>%
    as.data.frame()

yrs <- c(1999, 2002, 2005, 2008)
typs <- make.names(names(byType))

# to make it easier for ggplot, converting wide format to long format
byTypeL <- data.frame(years = rep(c(1999, 2002, 2005, 2008), each = 4),
                      types = rep(make.names(names(byType)), 4))

#Create a vector from the Wide DF
x<- c(as.vector(byTypeW[1,]),
      as.vector(byTypeW[2,]),
      as.vector(byTypeW[3,]),
      as.vector(byTypeW[4,])) %>% unlist

# Add vector to Long DF
byTypeL <- cbind(byTypeL, Emissions = x)

# Create the graph
pic <-  ggplot (byTypeL, aes(x = years, y = Emissions)) +
    facet_grid(types~., scales = 'free_y') +
    geom_point(colour = 'red', size = 2) +
    geom_line(colour = 'blue', size = 1) + 
    xlab ('Year') +
    ylab ('Total Emissions [tons]') +
    ggtitle ('Total emissions of pm2.5 based on type') + theme(plot.title = element_text(hjust = 0.5))

ggsave("plot3.png", width = 5, height = 5)
