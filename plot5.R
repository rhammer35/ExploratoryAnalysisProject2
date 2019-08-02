## Reads data into data frame from intial txt file in working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load ggplot2
library(ggplot2)

## Subset NEI data into data frame containing only Baltimore City data
NEI_Baltimore_City <- subset(NEI, fips == "24510")