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

