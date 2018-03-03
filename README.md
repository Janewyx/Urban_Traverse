# Study on the effect of urban density on nocturnal temperatures

This is a past project in February, 2017 for the Urban Meteorology class in the Department of Geography at the University of British Columbia, Vancouver, Canada.

Night-time car traverse was done in Metro Vancouver area with mobile air sensor system. We investigate the intra-urban differences in air temperature by classifying selected marker points of the traverse route into different Local Climate Zones (LCZs, discussed by Stewart and Oke, 2012) and compare the zonal differences in temperature statistics.


### Observed air temperature 
Strong regional variations of air temperature can be seen from the map below. Lower than average temperatures in the Stanley Park region on the north of the map, Pacific Spirit Park forests along the Southwest Marine Drive, and open agriculture fields in Richmond, southeast on the map. Downtown areas and central 41st Avenue with busy traffic and highrise architectures show some of the highest observed air temperatures:

<img src="/Users/jane/Documents/Caffeine/geob/401_Urban_Meteorology/car_traverse/R/plots/origmap.png">

### Averaged air temperature within each Local Climate Zone
Zonal differences in air temperature are mapped. Density and height of buildings, surface perviousness, surface vegetation covers, and distance from urban centres will influence the observed nocturnal temperature and the heat dispersion:

<img src="/Users/jane/Documents/Caffeine/geob/401_Urban_Meteorology/car_traverse/R/plots/lczmap.png">

### More statistics
Below is a boxplot of the air temperature per minute during traverse colour coded by LCZ. Dashed line represents the mean traverse air temperature. The temperatures exhibit high fluctuations from different LCZs:

<img src="/Users/jane/Documents/Caffeine/geob/401_Urban_Meteorology/car_traverse/R/plots/boxplot.png">

Averaged temperature departures for each LCZ from mean temperature of the traversed route are also graphed:

<img src="/Users/jane/Documents/Caffeine/geob/401_Urban_Meteorology/car_traverse/R/plots/bar_chart.png">

The LCZ_analysis.R file shows the code for cleaning and analysing traverse data, as well as creating these graphs above.