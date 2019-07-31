## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Use tapply to sum the pm2.5 emissions for each year in the data set and store
## the values
pm25_totals <- tapply(NEI$Emissions, NEI$year, sum)

## Convert pm2.5 emission totals from tons to kilotons for easier graph reading
pm25_totals <- pm25_totals/1000

## Initialize png plotting device
png(filename = "plot1.png")

## Create line graph in base plotting system showing total emissions over time
plot(unique(NEI$year), pm25_totals, type = "l", ylab = "Total Emissions
     (in kilotons)", xlab = "", main = "pm2.5 emissions in the US over time")

## End plotting device
dev.off()