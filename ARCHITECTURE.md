# Architecture

How the code is organized and how data flow through it. The intended layout is in `REPOSITORY-BLUEPRINT.md`; the scientific specification is in `analysis-plan.md`.

## Origin

The analysis was written in 2022 as one R Markdown file. Each script below comes from one or more chunks of that file, with the analysis code unchanged. Three kinds of change were made: the workbook path moved to `R/setup.R`; results the R Markdown file printed inline are assigned to named objects, because `source()` does not print; and new code exports tables and figures to files.

| Original chunk | Now in |
|---|---|
| `library` | `R/setup.R` |
| `dataimport` | `R/import_clean.R` |
| `exploratoryanalysis` | `R/tables.R` (Table 1, CrAg counts) |
| `factetedplots` | `R/figures.R` |
| `regressiontables` | `R/modeling.R` |
| `corrplot1` | `R/pca.R` (PCA fit, scores, regression); `R/figures.R` (correlation and PCA plots); `R/tables.R` (eigenvalues) |
| `citations` | Not carried over; package citations are in `references.bib` and on the website |

## Execution order

`R/main.R` sources, in order:

```text
setup.R ──► functions.R ──► import_clean.R ──► modeling.R ──► pca.R ──► tables.R ──► figures.R
```

| Script | Needs | Produces |
|---|---|---|
| `setup.R` | — | Attached packages; `raw_data_path`, `raw_data_sheet`, `tables_dir`, `figures_dir` |
| `functions.R` | `setup.R` | `save_gtsummary_html()`, `save_flextable_html()`, `summarise_cutpoint()`, `summarise_auc_ci()` |
| `import_clean.R` | `raw_data_path`, `raw_data_sheet` | `RawData`, `CleanData`, `CleanData_NoMissingTiters`, `CategoricalVariables`, `TiterVariables`, `LogTiterVariables`, `ContinuousVariables` |
| `modeling.R` | `CleanData` and variable lists | Univariable and multivariable gtsummary tables; `mvtitermodel1`, `mvlogtitermodel1`–`4`; `titer_roc`, `logtiter_roc1`, `logtiter_roc2`; `auc_ci_*`; `sensitivity_table_*`; `cutpoint_*` |
| `pca.R` | `CleanData_NoMissingTiters`, `LogTiterVariables` | `PCA`, `columns`, `PCAData`, `pc_regression_table` |
| `tables.R` | All of the above | `table1_all`, `table1_no_missing_titers`, `crag_*_counts`, `pca_eigenvalue_table`, `auc_ci_summary`, `cutpoint_summary`; HTML files in `tables/` |
| `figures.R` | `CleanData*`, ROC objects, `PCA`, `columns` | `faceted_titer_plot`, `pca_individuals_plot`, `pca_biplot`; PNG files in `figures/` |

## Data flow

```text
data-raw/transUABallData012219 (1).xls   (restricted; never committed)
        │  read_excel(), sheet "Data"
        ▼
RawData ──► CleanData ──────────────┬──► modeling.R ──┐
             │ filter(!is.na(GXMIgG)) │                  ├──► tables.R ──► tables/*.html
             ▼                        │                  │
   CleanData_NoMissingTiters ─────────┴──► pca.R ───────┴──► figures.R ─► figures/*.png
                                                                              │
                                     quarto/results.qmd displays both ◄───────┘
```

## Website

`_quarto.yml` renders `index.qmd` and `quarto/*.qmd` to `docs/`. Each script page imports its script's labelled sections with `knitr::read_chunk()` and shows them without running them. `quarto/results.qmd` displays the files in `tables/` and `figures/`, which `_quarto.yml` copies into the site as resources.

## Revision scope

Written 2026-10-26 for the initial reorganization.
