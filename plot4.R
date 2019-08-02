## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset SCC data to sources that could use coal combustion
## This includes sources with "combustion" in the title
SCC_Combustion <- SCC[grep("Combustion", SCC$SCC.Level.One), ]

## Now further subset to include only sources listing "Coal" or "Lignite"
## in level three (perusing the data showed lignite in level three 
## corresponded to a type of coal in level four)
SCC_Coal <- SCC_Combustion[grep("Coal", SCC_Combustion$SCC.Level.Three), ]
SCC_Lignite <- SCC_Combustion[grep("Lignite", 
                                   SCC_Combustion$SCC.Level.Three), ]

## Merge lignite and coal data and remove any overlapping rows
SCC_Coal_Combustion <- merge(SCC_Coal, SCC_Lignite, all = TRUE)

## Subset NEI data to only those SCC types corresponding to coal combustion
SCC_Combustion_Types <- as.character(unique(SCC_Coal_Combustion$SCC))
NEI_Coal_Combustion <- NEI[NEI$SCC %in% SCC_Combustion_Types, ]

## Calculating total number of sources measured per year in NEI data subset
Coal_Combustion_Sources <- tapply(NEI_Coal_Combustion$SCC, 
                                  NEI_Coal_Combustion$year, length)

## Taking yearly totals for emissions in NEI subset and converting to kilotons
pm25_totals <- tapply(NEI_Coal_Combustion$Emissions, NEI_Coal_Combustion$year,
                      sum)
pm25_totals <- pm25_totals/1000

## Calculating yearly emission averages in NEI subset
pm25_averages <- tapply(NEI_Coal_Combustion$Emissions,
                        NEI_Coal_Combustion$year, mean)

## Calculating maximum yearly emission values in NEI subset
pm25_max_values <- tapply(NEI_Coal_Combustion$Emissions, 
                          NEI_Coal_Combustion$year, max)

## Initialize png plotting device
png(filename = "plot4.png")

## Create 2x2 panel plot in base plotting system containing line graphs of
## each data component calculated off of NEI subset
par(mfrow = c(2, 2), mar = c(5, 4, 2, 2), oma = c(0, 0, 2, 0))
plot(unique(NEI_Coal_Combustion$year), pm25_totals, type = "l",
     ylab = "Total Emissions (in kilotons)", xlab = "")
plot(unique(NEI_Coal_Combustion$year), pm25_averages, type = "l",
     ylab = "Average Emissions (in tons)", xlab = "")
plot(unique(NEI_Coal_Combustion$year), pm25_max_values, type = "l",
     ylab = "Maximum Measured Emission (in tons)", xlab = "")
plot(unique(NEI_Coal_Combustion$year), Coal_Combustion_Sources, type = "l",
     ylab = "Number of Coal Emission Sources", xlab = "")
mtext("pm2.5 emission data from coal combustion", side = 3, outer = TRUE)

## End plotting device
dev.off()

