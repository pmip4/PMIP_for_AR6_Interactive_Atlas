# Palaeoclimate Modelling Intercomparison Outputs for IPCC AR6
### This repository holds (some of the) results from the [Paleoclimate Modelling Intercomparison Project](https://pmip.lsce.ipsl.fr/) that were included in the the Sixth Assesment Report from the Intergovernmental Panel on Climate Change (IPCC AR6). 
There are four directories in the repositories that each contain different kind of things and are outlined below.

## Authors & Publications
* Chris Brierley: University College London ([c.brierley@ucl.ac.uk](mailto:c.brierley@ucl.ac.uk))
* Anni Zhao: University College London

_Please also refer to [Zhao et al (2020)](https://doi.org/10.5194/gmd-15-2475-2022), which describes the process that has been followed to collate the data provided in this repository_

## Figures
There are 2 subdirectories containing the code and data used to create two panels for Chapter 3. They each also have their own repositories under the IPCC WGI organisation. You can access those repositories by clicking on the images below. Please do be aware that some of the titling and legend elements in Fig 3.11 were manually edited in Inkscape to improve to provide better visuals. 

![Fig3 2b](https://github.com/pmip4/PMIP_for_AR6_Interactive_Atlas/assets/22472193/3af919c0-f320-463a-85d2-afa8e36f46c5)

![SRL-image-0](https://github.com/pmip4/PMIP_for_AR6_Interactive_Atlas/assets/22472193/8c3f3ca7-31ea-498d-aa8b-29e755b81f89)


## Metadata Files
This directory contains a selection of tables that list all of the individual models that have data stored on the Earth System Grid Federation. Each table lists the files available at the time of the creation of Interactive Atlas, along with their `hdl` where available. All the tables are in comma separated value format.

## Network Common Data Files (netcdfs)
There are two sub-directories that each contain a series of spatial data files. Only data on surface air temperature (_tas_) and precipitation (_pr_) are provided, and on a common 1° by 1° grid (using bilinear interpolation). Files are labelled as either `annClim` or `monClim` depending on whether they provide the annual mean or data for each of the twelve months.

Calendar adjustment has been applied to the monthly data to correct for the differing lengths of the months in the _lig127k_, _midHolocene_ and _lgm_ experiments (using the PaleoCalAdjust software of [Bartlein & Shafer](https://doi.org/10.5194/gmd-12-3889-2019)). This approach provides better estimates of the values for individual months, but has the potential to alter the annual average - hence the decision to provide that information separately. _Please select the correct files for your particular application, and if in doubt contact [c.brierley@ucl.ac.uk](mailto:c.brierley@ucl.ac.uk)_.

- `ensemble_combined` sub-directory contains the available model outputs that have undertaken a particular experiment. There are multiple instances of files for the preindustrial control (`piControl`) experiment from which  baseline anomalies are computed: to match the ensemble members of the different palaeoclimate experiments.
- `ensemble_differences` sub-directory contains just the ensemble-averaged anomalies for each experiment. All the anomalies have been computed on a model's native grid first, before being regridded to a common 1° by 1° grid. This distinction can be minor for temperature changes, but may be important for rainfall percentage changes.

## Scripts
This directory contains the scripts that have been written to create the netcdfs described above. They are provided for completeness sake, and may be of little use as they refer to file locations on an underlying curated ESGF replica as described by [Zhao et al (2020)](https://doi.org/10.5194/gmd-15-2475-2022).
