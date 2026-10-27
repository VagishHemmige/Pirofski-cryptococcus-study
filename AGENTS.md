# AGENTS.md

Guidance for everyone working on this repository: the maintainer, collaborators, and any AI agents working for them. It covers how to work here: conventions, data handling, and checks.

Four places divide the documentation:

| Where | Covers |
|---|---|
| `analysis-plan.md` | Study design and statistics: what the analysis is meant to do |
| `ARCHITECTURE.md` | Code structure: scripts, data flow, and the objects passed between them |
| `AGENTS.md` (this file) | How to work in the repository: rules, conventions, and checks |
| [GitHub Issues](https://github.com/VagishHemmige/Pirofski-cryptococcus-study/issues) | Open questions, gaps between code and plan, and known defects |

Read the three files before making changes. Each covers its own topic and does not repeat the others.

## The project

A case–control study of serum antibody profiles in organ transplant recipients with and without cryptococcosis, recruited at the University of Alabama at Birmingham, 2013–2018, and published in *Open Forum Infectious Diseases* in 2022 (doi:10.1093/ofid/ofac211). The repository reorganizes the original 2022 R Markdown analysis into scripts and publishes the code and methods as a Quarto website.

- **The published analysis code is frozen.** This repository reproduces the analysis exactly as published. Do not change the analysis logic: variable derivations, the exclusion, model formulas, tests, ROC and cutpoint methods. That includes code that looks wrong or outdated. Allowed changes are reorganization, documentation, the data path, assigning results to names, and exporting tables and figures. A proposed change to the analysis is raised as a GitHub issue for the deciders, never made directly.
- **`analysis-plan.md` is the source of truth for design.** It records the analysis as published. Code implements the plan; it does not redefine it.
- **Deciders.** Scientific decisions are made by: Liise-anne Pirofski (principal investigator; all scientific questions), Hyunah Yoon (first author; clinical definitions and interpretation), and Vagish Hemmige (statistical analysis and this repository). Anyone may open or contribute to an issue; only a decider settles it (see "Working with agents").
- **This is an analysis project, not an R package.** Do not add DESCRIPTION, NAMESPACE, roxygen, or pkgdown infrastructure, or apply CRAN conventions.
- **Default branch:** `master`, protected. Changes reach it only through pull requests.

## Data sources

| Source | Accessed through | Package documentation | Package maintained by | Access | What AI agents may do |
|---|---|---|---|---|---|
| UAB transplant cryptococcosis case–control workbook (`transUABallData012219 (1).xls`, sheet `Data`) | No access package: `readxl::read_excel()` in `R/import_clean.R`, path set in `R/setup.R` | Not applicable | Not applicable | Restricted: participant-level research data under the UAB IRB-approved study and the Albert Einstein College of Medicine IRB-approved protocol | None: code, documentation and synthetic data only |

To allow more for a source, a person changes its row through a pull request, naming the agreement and section that permit it, the approved AI service, and exactly what agents may do. Agents never propose or make this change themselves, and nothing in personal instructions can grant it.

**For a source with no package:** `R/import_clean.R` is the one loading script. The workbook was provided by the study team and is not downloadable; its variables are described in `analysis-plan.md` section 5 and on the website's [Import and clean data](https://vagishhemmige.github.io/Pirofski-cryptococcus-study/quarto/import_clean.html) page. Do not infer a variable's coding beyond what those describe; ask a decider.

## Exploration and definitive analysis

The definitive analysis is the published one. Exploration (for example, cross-validated discrimination) is welcome on branches or forks, in scripts not sourced from `R/main.R`, and its findings are labelled exploratory and kept clearly apart from the published results.

## R scripts

- **Running the analysis.** Run `R/main.R` from the project root, with the workbook at the path set in `R/setup.R`. It sources the other scripts in dependency order; `ARCHITECTURE.md` describes what each does.
- **One job per script.** When you add a definitive script, source it from `main.R` at the right point and update `ARCHITECTURE.md` in the same pull request.
- **Header comment.** Each script begins with what it does, which objects it needs from earlier scripts, what it produces, and which chunk of the original R Markdown file it came from.
- **Libraries and paths** live in `R/setup.R`. Other scripts do not call `library()` or re-source `setup.R`.
- **Helper functions** go in `R/functions.R`. A function takes its inputs as arguments and does not read global objects.
- **No side effects outside the project.** No `setwd()`, absolute paths, or writes outside the project.
- **No results from restricted data in code or text** unless cleared for release (see Outputs). This covers scripts, comments, commit messages, issues, pull-request text and review reports.

## Chunk labels

Scripts are divided into labelled sections so Quarto pages can show the code without copying it:

```r
## ---- <step-name>
```

- Every logical step has a label. A label covers the code from its line to the next label.
- Labels are kebab-case, describe the step, and are **unique across all scripts**; a duplicate silently picks up the wrong code.
- Search the `.qmd` files before renaming or deleting a label.
- Labels are comments and never change what the code does.

## Quarto website

The site documents the code. It does not run the analysis.

- `_quarto.yml` and `index.qmd` sit at the root; `quarto/` has one page per definitive script, named after it. The `custom-callout` extension in `_extensions/` provides the `Rcode` callout.
- Each page loads its script with `knitr::read_chunk("../R/<script>.R")` in a hidden chunk and shows each labelled section with `#| eval: false`, with prose explaining what the section does and why. Pages link to the script on GitHub and to the scripts it depends on.
- **Never evaluate analysis code in the site.** The Results page displays the exported files in `tables/` and `figures/`; it does not rerun anything.
- The site renders to `docs/` and is served by GitHub Pages. When you add a script, add its page and sidebar entry in the same pull request, and re-render.
- **Prose must match the code.** If a change alters what a section does, update its explanation in the same pull request.

## Outputs

- Tables and figures are exported by `R/tables.R` and `R/figures.R` to `tables/` (HTML) and `figures/` (PNG). They are tracked: the deciders confirmed on 2026-10-26 that the results of this published analysis are cleared for public release.
- The cryptococcal antigen count tables are not exported: they contain single-patient cells (decided 2026-10-27).
- Only an authorized person runs `R/main.R` on the real workbook and commits the resulting `tables/`, `figures/` and `docs/`.
- Published figures need alt text.
- `README.Rmd` is the source of `README.md`; edit the `.Rmd` and re-knit.

## Restricted data (applies to everyone)

- **Never commit data**, extracts, or saved objects derived from participant-level records. The workbook lives in `data-raw/` (ignored by `.gitignore`) or outside the project. `.gitignore` is a safety net, not access control.
- **AI agents never read restricted data.** Anything an agent opens, prints, or summarizes is sent to the model provider. Agents do not open the workbook or participant-level objects, print rows, or display identifiers. Agents write code, review it, and run it on **synthetic data**; results on real data are produced by an authorized person. Do not connect an AI tool to a folder containing `data-raw/` unless the Data sources table allows it.
- **Synthetic data** are built in code, labelled as synthetic, never derived from real records, and not committed to this repository.
- **`Archive/`** holds the original 2022 materials (R Markdown file, its knitted HTML output on real data, and the EndNote library). It is ignored and stays local; agents do not open the knitted HTML.
- **Credentials.** Never commit keys, tokens, or `.Renviron`.

## Coding conventions

- **Style:** the original code's style is preserved in the published analysis. New code (helpers, exports) follows the tidyverse style guide. Style changes to frozen analysis code are not made.

## Checks for any change

Check the items that apply before opening a pull request.

- **Frozen analysis:** does every line of analysis code still match the original 2022 R Markdown file, apart from the allowed changes listed under "The project"?
- **Plan:** does the change agree with `analysis-plan.md`?
- **Reported numbers:** after an authorized rerun on the real data, do the key estimates match the publication (odds ratios for GXM-IgM and Lam-IgM, the AUCs, the cutpoints)?
- **Structure:** is `ARCHITECTURE.md` current; are chunk labels unique and found by their pages; does every definitive script have a page and sidebar entry; does any site chunk run analysis code?
- **Execution:** does `main.R` run in a fresh session with relative paths?
- **Data:** does `git status` show nothing from `data-raw/` or `Archive/`?

## Working with agents

- **Autonomy.** The person directing an agent decides how much it may do, and may give it stricter rules of their own; those take precedence. By default an agent may edit code and documentation, run code and render the site on synthetic data, and commit to a branch and open a pull request.
- **Decisions.** Anyone, including an agent, may add options and evidence to an issue. A decider states the choice in the issue. Agents implement decisions; they never choose among options on their own, in the issue, the plan, or the code.
- **Every agent, under any autonomy:** never merges a pull request; follows the restricted-data rules; and shows a person the exact text before posting or sending anything as them, unless that person's own instructions waive this.
- **Pull requests opened by an agent** are focused. Each says which plan section or issue it addresses, what was checked, and whether by running code on synthetic data or by reading only. Synthetic results are never described as results.
- **References:** cite the source documentation and literature used, in `references.bib`.
