# Disease Surveillance and Outbreak Analytics with R

---

## 1. Directory Structure
```
course/
├── README.md                          <- this file
├── slides/
│   ├── day1_slides.qmd                <- Day 1 Quarto revealjs slides
│   └── day2_slides.qmd                <- Day 2 Quarto revealjs slides
├── R/
│   ├── day1_import_and_cleaning.R     <- full Day 1 hands-on script
│   └── day2_visualization_and_measures.R <- full Day 2 hands-on script
└── data/
    ├── awd_linelist_raw.csv           <- MESSY data
    ├── awd_linelist_clean.csv         <- CLEAN data
    └── ward_population.csv            <- population denominators for attack rates
```

## 2. Scenario

A simulated outbreak of **Acute Watery Diarrhoea (AWD)** in a fictional
**"Ogun North" LGA**, Nigeria, spanning 10 weeks (late April–early July
2026) across 6 wards (Iwo Road, Bodija, Sango, Apata, Agodi, Ring Road).
337 true cases, deliberately "dirtied" into 353 messy rows for the
cleaning exercise (duplicates, typos, mixed date formats, impossible
ages, inconsistent Yes/No and category coding). 


## 3. Setup instructions 

1. Install **R** (≥ 4.2): https://cran.r-project.org/
2. Install **RStudio Desktop**: https://posit.co/download/rstudio-desktop/
3. Install **Quarto** (if you also want to view/render the slides):
   https://quarto.org/docs/get-started/
4. Open RStudio and run:
   ```r
   install.packages(c("tidyverse", "janitor", "lubridate", "here",
                       "skimr", "scales", "zoo"))
   ```
5. Download the course folder (data + scripts) and open it as an
   **RStudio Project** (File > New Project > Existing Directory).

## 4. Rendering the slides

The slide decks are Quarto (`.qmd`) files using the `revealjs` format.
To render and present them:

```bash
quarto render slides/day1_slides.qmd
quarto render slides/day2_slides.qmd
```

Or open the `.qmd` file in RStudio and click **Render**. This produces
a self-contained `.html` slideshow (press `F` for fullscreen, `S` for
speaker notes view, `?` for all keyboard shortcuts).
