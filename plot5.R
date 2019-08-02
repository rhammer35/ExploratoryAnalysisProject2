## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load ggplot2
library(ggplot2)

## Subset NEI data into data frame containing only Baltimore City data
NEI_Baltimore_City <- subset(NEI, fips == "24510")

## Subset SCC data into data frame containing only motor vehicle sources
## by sorting Short.Name variable using phrase "Highway Veh"
## It should be noted that I am choosing to interpret "motor vehicle" as
## referring to only motorized vehicles driven on roadways
SCC_Motor_Vehicle <- SCC[grep("Highway Veh", SCC$Short.Name), ]

## Subset Baltimore City data to only those SCC types corresponding to 
## motor vehicles
SCC_Vehicle_Types <- as.character(unique(SCC_Motor_Vehicle$SCC))
NEI_Baltimore_Vehicles <- NEI_Baltimore_City[NEI_Baltimore_City$SCC %in% 
                                             SCC_Vehicle_Types, ]

## Calculating total number of sources measured per year in NEI data subset
Bmore_vehicle_sources <- tapply(NEI_Baltimore_Vehicles$SCC,
                                NEI_Baltimore_Vehicles$year, length)

## Taking yearly totals for emissions in NEI Baltimore motor vehicle subset
pm25_Bmore_vehicle_total <- tapply(NEI_Baltimore_Vehicles$Emissions,
                                   NEI_Baltimore_Vehicles$year, sum)

## Calculating yearly emission averages in NEI Baltimore motor vehicle subset
pm25_Bmore_vehicle_avg <- tapply(NEI_Baltimore_Vehicles$Emissions,
                                 NEI_Baltimore_Vehicles$year, mean)

## Calculating max yearly emission in NEI Baltimore motor vehicle subset
pm25_Bmore_vehicle_max <- tapply(NEI_Baltimore_Vehicles$Emissions,
                                 NEI_Baltimore_Vehicles$year, max)

## Initialize png plotting device
png(filename = "plot5.png")

## Create 2x2 panel plot in base plotting system containing line graphs of
## each data component calculated off of NEI Baltimore vehicle subset
par(mfrow = c(2, 2), mar = c(5, 4, 2, 2), oma = c(0, 0, 2, 0))
plot(unique(NEI_Baltimore_Vehicles$year), pm25_Bmore_vehicle_total, type = "l",
     ylab = "Total Emissions (in tons)", xlab = "")
plot(unique(NEI_Baltimore_Vehicles$year), pm25_Bmore_vehicle_avg,
     type = "l", ylab = "Average Emissions (in tons)", xlab = "")
plot(unique(NEI_Baltimore_Vehicles$year), pm25_Bmore_vehicle_max,
     type = "l", ylab = "Maximum Measured Emission (in tons)", xlab = "")
plot(unique(NEI_Baltimore_Vehicles$year), Bmore_vehicle_sources,
     type = "l", ylab = "Number of Coal Emission Sources", xlab = "")
mtext("pm2.5 motor vehicle emissions in Baltimore City", side = 3, outer = TRUE)

## End plotting device
dev.off()
