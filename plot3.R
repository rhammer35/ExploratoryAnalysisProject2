## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load ggplot2
library(ggplot2)

## Subset NEI data into data frame containing only Baltimore City data
NEI_Baltimore_City <- subset(NEI, fips == "24510")

## Subset Baltimore City data by source type
Baltimore_City_pt <- subset(NEI_Baltimore_City, type == "POINT")
Baltimore_City_np <- subset(NEI_Baltimore_City, type == "NONPOINT")
Baltimore_City_rd <- subset(NEI_Baltimore_City, type == "ON-ROAD")
Baltimore_City_nr <- subset(NEI_Baltimore_City, type == "NON-ROAD")

## Calculate yearly mean and sum for each source type and combine to data frame
averages <- c(tapply(Baltimore_City_pt$Emissions, Baltimore_City_pt$year, mean),
              tapply(Baltimore_City_np$Emissions, Baltimore_City_np$year, mean),
              tapply(Baltimore_City_rd$Emissions, Baltimore_City_rd$year, mean),
              tapply(Baltimore_City_nr$Emissions, Baltimore_City_nr$year, mean))
totals <- c(tapply(Baltimore_City_pt$Emissions, Baltimore_City_pt$year, sum),
            tapply(Baltimore_City_np$Emissions, Baltimore_City_np$year, sum),
            tapply(Baltimore_City_rd$Emissions, Baltimore_City_rd$year, sum),
            tapply(Baltimore_City_nr$Emissions, Baltimore_City_nr$year, sum))
year <- unique(NEI_Baltimore_City$year)
type <- unique(NEI_Baltimore_City$type)
Baltimore_City_Summary <- data.frame(Totals = totals, Averages = averages, 
                                      Year = rep(year, 4), 
                                      Type = rep(type[1:4], each = 4))
colnames(Baltimore_City_Summary)[1] <- "Yearly Total Emission (in tons)"
colnames(Baltimore_City_Summary)[2] <- "Yearly Average Emission (in tons)"


## Initialize png plotting device
png(filename = "plot3.png")

## Create plot
print(qplot(Year, `Yearly Total Emission (in tons)`, 
            data = Baltimore_City_Summary,  geom = c("point", "smooth"),
            facets = .~ Type))

## End plotting device
dev.off()

