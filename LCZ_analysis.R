## GEOB 401 Car traverse assignment write up
## Analysis on temperature variations in different Local Climate Zones in Metro Vancouver

library(zoo) # gap filling
library(dplyr) # data munging
library(ggplot2) # plotting
library(Cairo) # outputting graphs
library(RColorBrewer) # colour scale

## setting work directory
# setwd("/Users/jane/Documents/Caffeine/geob/401_Urban_Meteorology/car_traverse/R")

## reading in 20160209 data
df_16 <- read.csv("../T160209.csv", col.names = c("Markers", "Date", "Time", "Air_T", "Air_T_uncorrected",
                                               "CO2_Conc", "Lat", "Long", "Height", "GPS Accuracy",
                                               "GPS_Speed", "GPS_Status"), header = FALSE, stringsAsFactors = FALSE)

##################################
######### Cleaning data ##########
##################################

## retain only marker number for classifying and indexing LCZs later
df_16$Markers <- substr(df_16$Markers, 0, 2)

## converting character to numemric values
df_16$Markers <- as.numeric(df_16$Markers)
df_16$Air_T <- as.numeric(df_16$Air_T)
df_16$Lat <- as.numeric(df_16$Lat)
df_16$Long <- as.numeric(df_16$Long)
df_16$Time <- as.POSIXct(df_16$Time, format = "%H:%M")

## check for markers entered more than once
unique(df_16$Markers[duplicated(df_16$Markers)])

## filling in empty marker values based on previous marker for all unmarked points for indexing
df_16$Markers <- na.locf(df_16$Markers)

###################################
######### Anaylsing data ##########
###################################

## classifying LCZs
df_16$LCZ <- NA

df_16$LCZ[df_16$Markers >= 13 & df_16$Markers < 16] <- "Compact highrise"
df_16$LCZ[df_16$Markers >= 18 & df_16$Markers < 24] <- "Compact highrise"

df_16$LCZ[df_16$Markers >= 2 & df_16$Markers < 4] <- "Open lowrise"
df_16$LCZ[df_16$Markers >= 5 & df_16$Markers < 6] <- "Open lowrise"
df_16$LCZ[df_16$Markers >= 7 & df_16$Markers < 11] <- "Open lowrise"
df_16$LCZ[df_16$Markers >= 24 & df_16$Markers < 36] <- "Open lowrise"
df_16$LCZ[df_16$Markers >= 37 & df_16$Markers < 40] <- "Open lowrise"
df_16$LCZ[df_16$Markers >= 48 & df_16$Markers < 61] <- "Open lowrise"

df_16$LCZ[df_16$Markers >= 11 & df_16$Markers < 13] <- "Open highrise"

df_16$LCZ[df_16$Markers >= 36 & df_16$Markers < 37] <- "Large lowrise"
df_16$LCZ[df_16$Markers >= 40 & df_16$Markers < 42] <- "Large lowrise"
df_16$LCZ[df_16$Markers >= 46 & df_16$Markers < 48] <- "Large lowrise"

df_16$LCZ[df_16$Markers >= 6 & df_16$Markers < 7] <- "Sparsely built"
df_16$LCZ[df_16$Markers >= 62 & df_16$Markers <= 63] <- "Sparsely built"

df_16$LCZ[df_16$Markers >= 4 & df_16$Markers < 5] <- "Dense trees"
df_16$LCZ[df_16$Markers >= 17 & df_16$Markers < 18] <- "Dense trees"
df_16$LCZ[df_16$Markers >= 61 & df_16$Markers < 62] <- "Dense trees"

df_16$LCZ[df_16$Markers >= 16 & df_16$Markers < 17] <- "Scattered trees"

df_16$LCZ[df_16$Markers >= 42 & df_16$Markers < 46] <- "Low plants"

## remove non-marked (NA) markers
df_16 <- df_16[complete.cases(df_16$LCZ),]

## check for unfilled markers except for markers 1 and 64 for campus calibration
which(is.na(df_16$LCZ[df_16$Markers > 1 & df_16$Markers < 64]))


## calculating traverse mean
df_16 <- mutate(df_16, Traverse_mean = mean(Air_T[df_16$Markers > 1 & df_16$Markers < 64], na.rm = TRUE))

## grouping rows by LCZ to calculate average air T for the specific zone
df_16 <- df_16 %>% 
  group_by(LCZ) %>% 
  mutate(Average_T = mean(Air_T, na.rm = TRUE),
        Departure = Average_T - Traverse_mean, sd = sd(Air_T, na.rm = TRUE),
        min = min(Air_T, na.rm = TRUE), max = max(Air_T, na.rm = TRUE))

## subset large dataset with unique LCZs for plotting
df_plot <- subset(df_16, !duplicated(df_16$LCZ))

###################################
####### Outputting results ########
###################################

## defining LCZ colours for plotting
cols <- c("#313695", "#4575b4", "#74add1", "#abd9e9", "#e0f3f8", "#fdae61",  "#d73027","#a50026")
# df_16$LCZ <- factor(df_16$LCZ, levels = df_16$LCZ[order(df_16$Average_T)])

## bar charts showing T departure
bar_plot <- ggplot(na.omit(df_plot), aes(reorder(LCZ, Departure), Departure)) +
  geom_bar(stat = "identity", width = 0.7, fill = "#1a8cff") +
  ylab(expression(paste("Departure from Traverse Mean (",degree,"C)"))) +
  coord_flip() +
  theme_bw() +
  theme(axis.title.y = element_blank())
plot(bar_plot)


## time series box plots for T
CairoPNG("plots/boxplot.png", width = 800, height = 350)

box_plot <- ggplot(df_16) +
  geom_boxplot(aes(as.factor(format(Time, "%H:%M")), Air_T, fill = LCZ)) +
  scale_fill_manual(values = cols) +
  geom_hline(yintercept = df_16$Traverse_mean, linetype = 2) +
  xlab("Time along traverse") +
  ylab(expression(paste("Air Temperature (",degree,"C)"))) +
  # annotate("Stanley Park", x = as.POSIXlt("2017-03-14 20:05:00", "%H:%M:%S"), y = 1) +
  theme_bw() +
  theme(axis.text.x = element_blank(),panel.grid = element_blank(), 
        axis.ticks.x = element_blank())
plot(box_plot)

dev.off()



## map visualisation
## keep 2 decimal places for longitude labels
scaleFUN <- function(x) sprintf("%.2f", x)

pal <- rev(brewer.pal(10, "RdYlBu"))

## original map
CairoPNG("plots/origmap.png", width = 635, height = 500)

orig_map <- ggplot(df_16) +
  geom_point(data = df_16, aes(Long, Lat, colour = Air_T ), shape = 3) +
  scale_x_continuous(labels = scaleFUN) +
  scale_colour_gradientn(colours = pal, limits = c(6, 14.2), name = expression(paste("Temperature (",degree,"C)"))) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(linetype = 2),
        panel.grid.minor = element_blank())
plot(orig_map)

dev.off()


## specifying LCZs and plot averaged temperature of each zone
## convert averaged LCZ temperature to factor for plotting
df_16$Average_T <- as.factor(df_16$Average_T)

CairoPNG("plots/LCZmap.png", width = 635, height = 500)

LCZmap <- ggplot(na.omit(df_16)) +
  geom_point(data = df_16, aes(Long, Lat, colour = Average_T), shape = 3) +
  scale_colour_manual(values = cols, drop = FALSE, name = "LCZs", 
                      labels = c("Low plants", "Large Lowrise", "Scattered trees", "Dense trees", 
                                 "Sparsely built", "Open lowrise","Open highrise", "Compact highrise")) +
  scale_x_continuous(labels = scaleFUN) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(linetype = 2),
        panel.grid.minor = element_blank(),
        legend.key = element_rect(fill = "black"))
plot(LCZmap)

dev.off()
