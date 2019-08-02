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

## Subset Baltimore Citydata to only those SCC types corresponding to 
## motor vehicles
SCC_Vehicle_Types <- as.character(unique(SCC_Motor_Vehicle$SCC))
NEI_Baltimore_Vehicles <- NEI_Baltimore_City[NEI_Baltimore_City$SCC %in% 
                                             SCC_Vehicle_Types, ]
