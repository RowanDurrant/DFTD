# DFTD Metapopulation simulations

Date created: 26/02/2021

Author: Rowan Durrant - Department of Biosciences, Swansea University 

Contact me at: RowanG.Durrant@gmail.com


## Dependencies: 
- [igraph](https://igraph.org/r/) (main simulation files)
- [ggplot2](https://ggplot2.tidyverse.org/) (plotting)


## Data generating scripts:
- The network topology making one
- The density extraction one


## Main simulation scripts:
- [main sim.R](R%20Code/main%20sim.R) : Base version of the metapopulation model code with density-independent dispersal. Runs a devil metapopulation system for 1820 weekly time steps, introducing DFTD at week 520, and outputs an .rda file containing time series of population size, no. individuals infected, etc. for each local population.
- [Degree.R](R%20Code/Degree.R), [Betweenness.R](R Code/Betweenness.R) & [Random.R](R Code/Random.R) : As above, but isolating patches at t=1040 based on their degree, their betweenness or at random, respectively. Also includes a function to calculate a measure of genetic diversity. 


## Data processing scripts:
- [2701 graph code.R](R%20Code/2701%20graph%20code.R) : produces figures 2, 3 and 4 from .rda files.


## Required data:
- All simulation scripts require the following datasets:
  - [dry wet networktopology.csv](Data%20Files/dry%20wet%20networktopology.csv) : contains data to set up the network structure
  - [dry wet patch areas.csv](Data%20Files/dry%20wet%20patch%20areas.csv) : contains data to set up local populations 
