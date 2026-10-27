# Analysis plan: Antibody profiles in organ transplant recipients with and without cryptococcosis

Status: retrospective record of the analysis as published [@yoon2022antibody]. This plan was written in 2026 from the published methods and the original 2022 analysis code. It was not prospectively locked, and the analysis was not registered.

## Scope

This document is the authoritative specification of the study's scientific objectives, population, definitions and statistical methods. `ARCHITECTURE.md` documents the implementation, `AGENTS.md` the working conventions, and GitHub Issues any open questions. Neither file supersedes this plan.

## 1. Objective

To compare serum cryptococcus-specific antibodies (glucuronoxylomannan [GXM]- and laminarin [Lam]-binding IgM and IgG) and non-specific antibodies (total IgM, IgG1, IgG2) between organ transplant recipients with and without a history of posttransplant cryptococcosis, and to describe how well these antibodies discriminate cases from controls [@yoon2022antibody].

All analyses are exploratory. No hypotheses were designated as primary, and there is no correction for multiple comparisons.

## 2. Design

Single-center case–control study. Antibodies were measured once, after transplantation (and, for cases, after the cryptococcosis diagnosis). The design supports association, not causal inference or prediction of future disease.

## 3. Data source

- **Setting:** University of Alabama at Birmingham (UAB); participants recruited 1 January 2013 to 31 December 2018.
- **Clinical data:** abstracted from the medical record: type and year of transplant, age, sex, race and the immunosuppression regimen at enrollment; for cases, site of infection and time from diagnosis to sample collection.
- **Laboratory data:** serum total IgM, IgG1 and IgG2 by Luminex (µg/mL); GXM- and Lam-binding IgM and IgG reported as titers; serum cryptococcal antigen (CrAg) by lateral flow assay.
- **Analysis file:** one Excel workbook, sheet `Data`, one row per participant. The workbook is restricted and is not part of the repository.
- **Approvals:** UAB Institutional Review Board approval with written informed consent; samples studied under an Albert Einstein College of Medicine IRB-approved protocol.

## 4. Study population

- **Cases:** organ transplant recipients with a history of posttransplant cryptococcosis diagnosed by a positive CrAg test or body fluid culture.
- **Controls:** organ transplant recipients without a history of posttransplant cryptococcosis.
- **Exclusion:** one participant recruited as a control was excluded because the serum CrAg was positive (study ID 116).
- **Analytic sample:** 23 cases and 21 controls. Antibody data are missing for 2 cases; analyses requiring antibody data use the participants with measurements.

## 5. Variables

- **Outcome (case status):** case versus control, as recruited.
- **Demographics:** age (years), sex, race, transplanted organ.
- **Immunosuppression at enrollment:** corticosteroid (recorded directly), and calcineurin inhibitor, mycophenolate and mTOR inhibitor indicators derived from the free-text regimen. The regimen text is upper-cased and an indicator is set when the text contains any of these strings: calcineurin inhibitor `PRO`, `T` or `CYC`; mycophenolate `M` or `CELL`; mTOR inhibitor `SIR` or `EVER`.
- **CNS cryptococcosis (cases):** the recorded site of infection mentions CNS.
- **Serum CrAg:** numeric titer, with negative results coded 0.
- **Antibodies:** GXM-IgG, GXM-IgM, Lam-IgG, Lam-IgM (titers); IgM, IgG1, IgG2 (µg/mL). Each is analyzed on its original scale and after natural-log transformation.

## 6. Statistical analysis

1. **Descriptive comparison (Table 1).** Medians with interquartile ranges, and counts with percentages, by case status. Continuous variables are compared with the Wilcoxon rank-sum test; categorical variables with Fisher's exact or the χ² test. Reported for all participants and for those with antibody data.
2. **Antibody distributions.** Each antibody plotted by case status on a log scale, with a Wilcoxon p-value per antibody.
3. **Univariable logistic regression** of case status on each of: sex, race, corticosteroid, mycophenolate and mTOR inhibitor use, age, and each antibody. Run on the original and on the log antibody scale; odds ratios with 95% confidence intervals.
4. **Multivariable logistic regression:**
   - Original scale: sex + Lam-IgM.
   - Log scale, model 1: sex + log Lam-IgM + log GXM-IgM.
   - Log scale, model 2: log Lam-IgM + log GXM-IgM, to check that sex is not driving the discrimination.
5. **Discrimination.** ROC curves from each multivariable model's predicted probabilities, with the AUC and 95% confidence intervals by DeLong's method and by bootstrap. Predicted probabilities are computed on the data used to fit the model.
6. **Optimal cutpoints** for GXM-IgM and Lam-IgM (original and log scale), chosen to maximize the sum of sensitivity and specificity, with sensitivity, specificity and positive and negative predictive values at the cutpoint. Cutpoints are chosen and evaluated on the same data.
7. **Correlation and principal component analysis.** Pearson correlations between the log antibodies (all participants, cases, controls). PCA of the seven standardized log antibodies, and logistic regression of case status on the seven components.
8. **Missing data:** complete-case analysis; no imputation.
9. **Software:** R and RStudio.

## 7. Sensitivity analyses

- **Collinearity of GXM-IgM and Lam-IgM:** each modeled separately with sex (sex + log Lam-IgM; sex + log GXM-IgM), since with both in one model neither is individually significant.
- **Influence of sex:** log-scale model 2 omits sex (section 6, item 4).
- **Antibody correlation:** PCA replaces the correlated antibodies with uncorrelated components (section 6, item 7).

## 8. Disclosure control

The study data are participant-level and restricted; they are never committed to the repository. Results from this analysis were published [@yoon2022antibody], and the investigators confirmed on 2026-10-26 that the tables and figures produced by this code are cleared for public release.

## 9. Limitations

As stated in the publication [@yoon2022antibody]: retrospective, single-center design; variable time between transplantation, cryptococcosis and enrollment; cases and controls not recruited concurrently; a single, non-standardized blood sample with no pre-cryptococcosis sample; no causal inference; B-cell subsets and cellular immunity not assessed; no cohort without immunosuppression; possible unmeasured confounding (cirrhosis, hematologic malignancy, chemotherapy); small sample size.

## References

References are in `references.bib`.
