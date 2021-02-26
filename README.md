# DFTD

Date created: 26/02/2021

Author: Rowan Durrant - Department of Biosciences, Swansea University 

Main script files:
- 100_years_dftd.R : Base version of the metapopulation model code with density-independent dispersal. Runs a devil metapopulation system for 5200 time steps, introducing DFTD at week 520, and outputs an .rda file containing time series of population size, no. individuals infected, etc. for each local population.
- 100_years_dftd_densitydep.R : As above, but with density-dependent dispersal.
