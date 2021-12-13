# DFTD Metapopulation simulations

Date created: 26/02/2021

Author: Rowan Durrant - Department of Biosciences, Swansea University 

Contact me at: r.durrant.1@research.gla.ac.uk

Paper now available [here!](https://www.mdpi.com/2076-0817/10/12/1592)

## Data generating scripts:
- [patch_extraction.R](code/patch_extraction.R) : takes TASVEG landcover rasters and produces network topology & other patch related data
- [density_extraction.R](code/density_extraction.R) : takes raster brick from [Cunningham et al., 2021](https://doi.org/10.1111/ele.13703) and extracts the predicted devil densities from our patch locations.
### Dependencies:
- [TASVEG landcover data](https://dpipwe.tas.gov.au/conservation/development-planning-conservation-assessment/planning-tools/monitoring-and-mapping-tasmanias-vegetation-%28tasveg%29/tasveg-the-digital-vegetation-map-of-tasmania)
- Predicted devil densites from [Cunningham et al., 2021](https://onlinelibrary.wiley.com/doi/abs/10.1111/ele.13703)

## Main simulation scripts:
- [main_sim.R](code/main_sim.R) : Base version of the metapopulation model code with density-independent dispersal. Runs a devil metapopulation system for 1820 weekly time steps, introducing DFTD at week 520, and outputs an .rda file containing time series of population size, no. individuals infected, etc. for each local population.
- [isolate_degree.R](code/isolate_degree.R), [isolate_betweenness.R](code/isolate_betweenness.R) & [isolate_random.R](Rcode/isolate_random.R) : As above, but isolating patches at t=1040 based on their degree, their betweenness or at random, respectively. Also includes a function to calculate a measure of genetic diversity. 
- [isolate_degree_no_dftd.R](code/isolate_degree_no_dftd.R), [isolate_betweenness_no_dftd.R](code/isolate_betweenness_no_dftd.R) & [isolate_random_no_dftd.R](code/isolate_random_no_dftd.R) : As above, but without DFTD being introduced to the system.

### Dependencies: 
- [igraph](https://igraph.org/r/) 
- [dry_wet_networktopology.csv](data/dry_wet_networktopology.csv) : contains data to set up the network structure
- [dry_wet_patch_areas.csv](data/dry_wet_patch_areas.csv) : contains data to set up local populations 


## Data processing scripts:
- [part_1_graphs.R](code/part_1_graphs.R) : produces figures 2 and 3 from .rda files.
- [disease_wave_processing.R](code/disease_wave_processing.R) : processes .rda files to find best match to [Lazenby et al. (2018)'s](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2664.13088) disease wave map, and then you can plot the results as figure 4.
- [isolation_graph_code.R](code/isolation_graph_code.R) : produces figure 5 from .rda files from the patch isolation simulations.


### Dependencies: 
- [ggplot2](https://ggplot2.tidyverse.org/)
- [dry wet locations 5.csv](data/dry%20wet%20locations%205.csv) : locations of patches for mapping
- [disease_front.csv](data/disease_front.csv) : the 5-year wave that each patch belongs to, based on the map from Lazenby et al., 2018 and additional data from Rodrigo Hamede.



