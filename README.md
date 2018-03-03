# Study on the effect of urban density on nocturnal temperatures

This is a past project in February, 2017 for the Urban Meteorology class in the Department of Geography at the University of British Columbia, Vancouver, Canada.

Night-time car traverse was done in Metro Vancouver area with mobile air sensor system. We investigate the intra-urban differences in air temperature by classifying selected marker points of the traverse route into different Local Climate Zones (LCZs, discussed by Stewart and Oke, 2012) and compare the zonal differences in temperature statistics.


### Observed air temperature 
Strong regional variations of air temperature can be seen from the map below. Lower than average temperatures in the Stanley Park region on the north of the map, Pacific Spirit Park forests along the Southwest Marine Drive, and open agriculture fields in Richmond, southeast on the map. Downtown areas and central 41st Avenue with busy traffic and highrise architectures show some of the highest observed air temperatures:

![origmap](https://user-images.githubusercontent.com/14840520/36931741-2f1d51d4-1e71-11e8-8c39-2b91031f4214.png)


### Averaged air temperature within each Local Climate Zone
Zonal differences in air temperature are mapped. Density and height of buildings, surface perviousness, surface vegetation covers, and distance from urban centres will influence the observed nocturnal temperature and the heat dispersion:

![lczmap](https://user-images.githubusercontent.com/14840520/36931740-2f04cfa6-1e71-11e8-9ca9-d3b824735fdc.png)

### More statistics
Below is a boxplot of the air temperature per minute during traverse colour coded by LCZ. Dashed line represents the mean traverse air temperature. The temperatures exhibit high fluctuations from different LCZs:

![boxplot](https://user-images.githubusercontent.com/14840520/36931739-2eebcea2-1e71-11e8-9143-ac315b9f6d93.png)

Averaged temperature departures for each LCZ from mean temperature of the traversed route are also graphed:

![bar_chart](https://user-images.githubusercontent.com/14840520/36931738-2ed42928-1e71-11e8-9b1b-1cba8ef3c2ca.png)

The LCZ_analysis.R file shows the code for cleaning and analysing traverse data, as well as creating these graphs above.
