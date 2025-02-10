# Tycho Data - Level 1 National Incidence Rate

This repository contains data and code to reproduce national incidence rate
results as in:
> Panhuis, Willem G. van, John Grefenstette, Su Yon Jung, Nian Shong
> Chok, Anne Cross, Heather Eng, Bruce Y. Lee, et al. 2013. “Contagious
> Diseases in the United States from 1888 to the Present.” New England
> Journal of Medicine 369 (22): 2152–58.
> <https://doi.org/10.1056/NEJMms1215400>.

## Infectious Disease - Data

### Tycho Version 1 - Level 1

Data are downloadable from [Zenodo](https://zenodo.org/records/12608992)

> Version 1.0.0 of level 1 data includes counts at the state level for 
smallpox, polio, measles, mumps, rubella, hepatitis A, and whooping cough and 
at the city level for diphtheria. The time period of data varies per disease 
somewhere between 1916 and 2011. This version includes cases as well as 
incidence rates per 100,000 population based on historical population estimates. 
These data have been used by investigators at the University of Pittsburgh to 
estimate the impact of vaccination programs in the United States, published in 
the New England Journal of Medicine.

### Additional Information

#### Measles

- Black, Francis L. 1959. “Measles Antibodies in the Population of New Haven, 
Connecticut1.” The Journal of Immunology 83 (1): 74–82. 
[https://doi.org/10.4049/jimmunol.83.1.74](https://doi.org/10.4049/jimmunol.83.1.74).
- CDC. 2024. “Chapter 13: Measles.” Epidemiology and Prevention of Vaccine-
Preventable Diseases. September 30, 2024. 
[https://www.cdc.gov/pinkbook/hcp/table-of-contents/chapter-13-measles.html](https://www.cdc.gov/pinkbook/hcp/table-of-contents/chapter-13-measles.html).
- CDC. 2024. “History of Measles.” Measles (Rubeola). May 20, 2024. 
[https://www.cdc.gov/measles/about/history.html](https://www.cdc.gov/measles/about/history.html)
- Collins, Selwyn D. 1929. “Age Incidence of the Common Communicable Diseases 
of Children: A Study of Case Rates among All Children and among Children Not 
Previously Attacked and of Death Rates and the Estimated Case Fatality.” 
Public Health Reports (1896-1970) 44 (14): 763–826. 
[https://doi.org/10.2307/4579202](https://doi.org/10.2307/4579202).
- LANGMUIR, ALEXANDER D. 1962. “Medical Importance of Measles.” American 
Journal of Diseases of Children 103 (3): 224–26.
[https://doi.org/10.1001/archpedi.1962.02080020236005](https://doi.org/10.1001/archpedi.1962.02080020236005)

#### Polio

- CDC. 2024. “Chapter 18: Poliomyelitis.” Epidemiology and Prevention of 
Vaccine-Preventable Diseases. September 30, 2024. 
[https://www.cdc.gov/pinkbook/hcp/table-of-contents/chapter-18-poliomyelitis.html](https://www.cdc.gov/pinkbook/hcp/table-of-contents/chapter-18-poliomyelitis.html).

## Census

Total population estimates per states and at national level per year from
[census.gov](https://www.census.gov/)

- [Data from 1910 to 1990](https://www.census.gov/data/tables/time-series/demo/popest/1970s-state.html) 
- [Data from 1990 to 2000](https://www.census.gov/data/tables/time-series/demo/popest/1990s-state.html) 
- [Data from 2000 to 2010](https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2000-2010-state.html)
- [Data from 2010 to 2020](https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2010-2020-state.html) 

### Age Group

Additional age group information is available at national (and state, for 
specific years) level on the census.gov website:

- Data from [1900 to 1979](https://www.census.gov/data/tables/time-series/demo/popest/pre-1980-national.html)
- Data from [1980 to 1990](https://www.census.gov/data/datasets/time-series/demo/popest/1980s-national.html)
- Data from [1990 to 2000](https://www.census.gov/data/tables/time-series/demo/popest/intercensal-national.html)
- Data from [2000 to 2010](https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2000-2010-national.html)
- Data from [2010 to 2020](https://www.census.gov/programs-surveys/popest/technical-documentation/research/evaluation-estimates/2020-evaluation-estimates/2010s-national-detail.html)

## Output

The Visualization folder contains multiple outputs files and code in a quarto file
to generate them.
All the quarto files have at least one output format, to generate all the 
available formats, please use the `quarto::quarto_render()` function.

For example:

```r
quarto::quarto_render("visualization/nat_incidence_level1.qmd", 
                      output_format = "all")
```
