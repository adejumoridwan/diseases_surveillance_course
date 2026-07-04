# Disease Surveillance and Outbreak Analytics with R
### Free Weekend Launch Course — Instructor Pack

Content adapted from **The Epidemiologist R Handbook** (epirhandbook.com),
used under its CC BY-NC-SA 4.0 license for academic/training purposes.
Consider emailing the Applied Epi team (per the handbook's terms) to let
them know you're using their material for this course.

---

## 1. What's in this pack

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
    ├── awd_linelist_raw.csv           <- MESSY data (hand out at start of Day 1)
    ├── awd_linelist_clean.csv         <- CLEAN answer key (instructor use / stragglers)
    └── ward_population.csv            <- population denominators for attack rates
```

## 2. The scenario used throughout

A simulated outbreak of **Acute Watery Diarrhoea (AWD)** in a fictional
**"Ogun North" LGA**, Nigeria, spanning 10 weeks (late April–early July
2026) across 6 wards (Iwo Road, Bodija, Sango, Apata, Agodi, Ring Road).
337 true cases, deliberately "dirtied" into 353 messy rows for the
cleaning exercise (duplicates, typos, mixed date formats, impossible
ages, inconsistent Yes/No and category coding). This mirrors the kinds
of problems trainees will meet in real line-list data.

All data is **entirely synthetic** — safe to redistribute to trainees.

## 3. Setup instructions (send to participants beforehand)

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

Each code chunk is set to `eval: false` so slides render instantly
without needing the data at render time — you will **run the code live**
in the R console/script during teaching (the code is identical to what's
in the `R/` scripts, so you can just paste from there if needed).

## 5. Schedule as advertised on the flyer

| Day | Date | Time (WAT) | Focus |
|---|---|---|---|
| Day 1 | Saturday, 11 July 2026 | 10:00 AM – 12:30 PM | R basics → import → explore → clean the line list |
| Day 2 | Sunday, 12 July 2026 | 1:30 PM – 3:30 PM | Descriptive tables → epidemic curves → outbreak measures → wrap-up |

### Detailed Day 1 timing (2h 30m)

| Time | Segment |
|---|---|
| 10:00–10:10 | Welcome, housekeeping, who's in the room |
| 10:10–10:25 | Part 1: R & RStudio basics, the pipe |
| 10:25–10:50 | Part 2: Importing & first exploration (`read_csv`, `glimpse`, `skim`) + Exercise 1 |
| 10:50–11:05 | Part 3a: Clean names, duplicates |
| 11:05–11:20 | Part 3b: Clean categorical variables + Exercise 2 |
| 11:20–11:35 | Part 3c: Clean numeric variables (age) |
| 11:35–12:05 | Part 3d: Clean dates (the hard part) + Exercise 3 |
| 12:05–12:20 | Save clean data, recap |
| 12:20–12:30 | Q&A / buffer |

### Detailed Day 2 timing (2h 00m)

| Time | Segment |
|---|---|
| 1:30–1:35 | Recap of Day 1, load clean data |
| 1:35–1:55 | Part 1: Descriptive tables (`tabyl`) + Exercise 1 |
| 1:55–2:10 | Part 2a: Basic & weekly epidemic curves |
| 2:10–2:25 | Part 2b: Faceted epicurves + Exercise 2 |
| 2:25–2:45 | Part 3a: Attack rate + visualization |
| 2:45–2:55 | Part 3b: CFR & other indicators + Exercise 3 |
| 2:55–3:05 | Part 4: Moving average trend |
| 3:05–3:15 | Part 5: One-page summary + preview of automated reporting |
| 3:15–3:25 | Recap, next steps, promo for full program |
| 3:25–3:30 | Q&A / close |

*(Note: the course description mentioned "4 hours split into two 2-hour
days" — the timings above follow the flyer's actual advertised times,
10:00–12:30 (2.5h) and 1:30–3:30 (2h). Trim the buffer/Q&A slots if you
need to hit exactly 2h on Day 1.)*

## 6. Teaching tips

- **Live-code, don't just click through slides.** Trainees retain far
  more when they see code typed and errors made/fixed in real time.
- Pause after every "Hands-on Exercise" slide — give 10–15 minutes,
  then walk through the solution together (solutions are in the `R/`
  scripts).
- Keep `data/awd_linelist_clean.csv` (the answer key) ready to share
  with anyone who falls behind during the Day 1 cleaning exercises,
  so they can still fully participate in Day 2.
- End Day 2 with a short live plug for the full training program,
  as per the flyer ("A preview of our upcoming full training program").

## 7. Attribution

Course structure and topic sequencing draws on the chapter organization
of *The Epidemiologist R Handbook* (Batra, N. et al., 2021),
https://www.epirhandbook.com/en/, licensed CC BY-NC-SA 4.0. This
instructor pack is for non-commercial training use consistent with
that license. All datasets are synthetic.
