# food_deserts

# DATA SOURCES:
NYS Retail Food Stores:
https://data.ny.gov/Economic-Development/Retail-Food-Stores/9a8c-vfzj/about_data

Car Ownership by Census Tract:
https://data.census.gov/table/ACSST5Y2022.S2504?q=car%20ownership

NYC Census Tracts Shapefile:
https://www.nyc.gov/site/planning/data-maps/open-data/census-download-metadata.page




# QGIS DOCUMENTATION

For the first set of maps comparing areas within 10 minutes of a grocery store by foot and by car, we started by loading in the filtered retail food stores dataset, and using TravelTimes' simple time map function to determine the areas within a 10 minute walk or drive from the points in this data set. The parameters for the API call included using "UNION" for result aggregation and single shape for level of detail in order to ensure the entire area was contained as simply/readably as possible in a combined geometry rather than having stacked catchment areas around each grocery store which could impede legibility of the maps. These maps were then set side by side and had a legend and text added for context with the print layout in QGIS.

For the second map illustrating percentages of car ownership in areas not within the areas identified as being within a 10 minute walk of a grocery store via the previous map, we began by loading in a dataset obtain from the census, specifically focusing on car ownership rates by census tract in New York. This dataset was filtered to remove all tracts not in New York City and all impertinent columns other than the percentage of households without access to a car were removed. Using a shapefile from NYC Open Data corresponding to the NYC census tracts, we created a choropleth classifying each census tract by its % of households lacking a car. Next, using the symmetric difference tool, we were able to identify the areas in the city not contained within a 10-minute walk using the layer from the previous map, leaving only the NYC census tracts not contained in these walkable areas. The resulting layer's symbology then was classified based upon percentage of non-car owning households for each remaining census tract. This map was then marked up with highlighted neighborhoods (those with very low-levels of car ownership and significant swathes of area not within a 10-minute walk of a store), a legend, and additional text for context about our findings.
