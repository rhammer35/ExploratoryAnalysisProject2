## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load ggplot2
library(ggplot2)

## Subset NEI data into data frame containing only Baltimore City data
NEI_Baltimore_City <- subset(NEI, fips == "24510")

## Subset NEI data into data frame containing only Los Angeles County data
NEI_LA_County <- subset(NEI, fips == "06037")

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

## Subset Los Angeles County data to only those SCC types corresponding to 
## motor vehicles
NEI_LA_Vehicles <- NEI_LA_County[NEI_LA_County$SCC %in% SCC_Vehicle_Types, ]

## Calculating total emissions per year in each NEI subset
pm25_Bmore_vehicle_total <- tapply(NEI_Baltimore_Vehicles$Emissions,
                                   NEI_Baltimore_Vehicles$year, sum)
pm25_LA_vehicle_total <- tapply(NEI_LA_Vehicles$Emissions, NEI_LA_Vehicles$year,
                                sum)

## Create vector of data showing percent change in total emissions since 1999
## to answer question of which city has seen greater changes over time
Bmore_change <- ((pm25_Bmore_vehicle_total[1:4]-pm25_Bmore_vehicle_total[1])
                 *100/pm25_Bmore_vehicle_total[1])
LA_change <- ((pm25_LA_vehicle_total[1:4]-pm25_LA_vehicle_total[1]) * 100
              /pm25_LA_vehicle_total[1])

## Create data frame combining data from both cities
Bmore_sum_data <- data.frame(Value = pm25_Bmore_vehicle_total, 
                         Year = names(pm25_Bmore_vehicle_total),
                         Location = rep("Baltimore", 4),
                         Percent_Change = Bmore_change)
LA_sum_data <- data.frame(Value = pm25_LA_vehicle_total, 
                          Year = names(pm25_LA_vehicle_total),
                          Location = rep("Los Angeles County", 4),
                          Percent_Change = LA_change)
Combined_City_df <- rbind.data.frame(Bmore_sum_data, LA_sum_data)

## Initialize png plotting device
png(filename = "plot6.png")

## Convert Year column to integer class for smoothing the plot
Combined_City_df$Year <- as.integer(as.character(Combined_City_df$Year))

## Create plot
theme_update(plot.title = element_text(hjust = 0.5))
print(qplot(Year, Percent_Change, data = Combined_City_df, color=Location,
            geom = c("point", "smooth"),
            ylab = "Percent Change",
            main = "Change in Total pm2.5 Emissions Over Time"))

## End plotting device
dev.off()
