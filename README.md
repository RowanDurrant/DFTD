# DFTD Metapopulation simulations

Date created: 26/02/2021

Author: Rowan Durrant - Department of Biosciences, Swansea University 

Contact me at: RowanG.Durrant@gmail.com


## Data generating scripts:
- [forest script.R](R%20Code/forest%20script.R) : takes TASVEG landcover rasters and produces network topology & over patch related data
- [extract densities.R](R%20Code/extract%20densities.R) : takes raster brick from [Cunningham et al., 2021](https://doi.org/10.1111/ele.13703) and extracts the predicted devil densities from our patch locations.
### Dependencies:
- [TASVEG landcover data](https://dpipwe.tas.gov.au/conservation/development-planning-conservation-assessment/planning-tools/monitoring-and-mapping-tasmanias-vegetation-%28tasveg%29/tasveg-the-digital-vegetation-map-of-tasmania)
- Predicted devil densites from [Cunningham et al., 2021](https://onlinelibrary.wiley.com/doi/abs/10.1111/ele.13703)

## Main simulation scripts:
- [main sim.R](R%20Code/main%20sim.R) : Base version of the metapopulation model code with density-independent dispersal. Runs a devil metapopulation system for 1820 weekly time steps, introducing DFTD at week 520, and outputs an .rda file containing time series of population size, no. individuals infected, etc. for each local population.
- [Degree.R](R%20Code/Degree.R), [Betweenness.R](R%20Code/Betweenness.R) & [Random.R](R%20Code/Random.R) : As above, but isolating patches at t=1040 based on their degree, their betweenness or at random, respectively. Also includes a function to calculate a measure of genetic diversity. 
- [Degree-noDFTD.R](R%20Code/Degree-noDFTD.R), [Betweenness-noDFTD.R](R%20Code/Betweenness-noDFTD.R) & [Random-noDFTD.R](R%20Code/Random-noDFTD.R) : As above, but without DFTD being introduced to the system.

### Dependencies: 
- [igraph](https://igraph.org/r/) 
- [dry wet networktopology.csv](Data%20Files/dry%20wet%20networktopology.csv) : contains data to set up the network structure
- [dry wet patch areas.csv](Data%20Files/dry%20wet%20patch%20areas.csv) : contains data to set up local populations 


## Data processing scripts:
- [2701 graph code.R](R%20Code/2701%20graph%20code.R) : produces figures 2 and 3 from .rda files.
- [big map processing.R](R%20Code/big%20map%20processing.R) : processes .rda files to find best match to [Lazenby et al. (2018)'s](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2664.13088) disease wave map, and then you can plot the results as figure 4.
- [fragmentation graph code.R](R%20Code/fragmentation%20graph%20code.R) : produces figure 5 from .rda files from the patch isolation simulations.


### Dependencies: 
- [ggplot2](https://ggplot2.tidyverse.org/)
- [dry wet locations 5.csv](Data%20Files/dry%20wet%20locations%205.csv) : locations of patches for mapping
- [disease front.csv](Data%20Files/disease%20front.csv) : the 5-year wave that each patch belongs to, based on the map from Lazenby et al., 2018 and additional data from Rodrigo Hamede.



