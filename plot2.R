## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset NEI data into data frame containing only Baltimore City data
NEI_Baltimore_City <- subset(NEI, fips == "24510")

## Use tapply to sum the pm2.5 emissions for each year in the Baltimore City
## data set and store the values
pm25_totals_Baltimore_City <- tapply(NEI_Baltimore_City$Emissions,
                                     NEI_Baltimore_City$year, sum)

## Initialize png plotting device
png(filename = "plot2.png")

## Create line graph in base plotting system showing Baltimore City emissions
## over time
plot(unique(NEI_Baltimore_City$year), pm25_totals_Baltimore_City, type = "l",
     ylab = "Total Emissions (in tons)", xlab = "",
     main = "pm2.5 emissions in Baltimore City, Maryland over time")

## End plotting device
dev.off()