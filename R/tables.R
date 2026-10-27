# Purpose: create the descriptive tables and export every table to tables/.
# Needs: CleanData, CleanData_NoMissingTiters, CategoricalVariables,
#   ContinuousVariables (import_clean.R); regression tables, ROC CIs and
#   cutpoints (modeling.R); PCA, pc_regression_table (pca.R); helper functions
#   (functions.R); tables_dir (setup.R).
# Produces: HTML tables in tables/.
# Source: the Table 1 and cryptococcal antigen code is the "exploratoryanalysis"
#   chunk of the original 2022 R Markdown file, unchanged apart from assigning
#   each printed result to a name. The eigenvalue table is from the "corrplot1"
#   chunk. The export calls are new.

## ---- table-1
#Create a Table 1 which compares cases in controls with regards to categorical and continuous variables
table1_all <- CleanData %>% select(CategoricalVariables, ContinuousVariables) %>%
  tbl_summary(by=CaseOrControl) %>%
  add_p() %>%
  bold_labels() %>%
  bold_p()

#Create a Table 1 which compares cases in controls with regards to categorical and continuous variables, excluding pts with missing titers
table1_no_missing_titers <- CleanData_NoMissingTiters %>% select(CategoricalVariables, ContinuousVariables) %>%
  tbl_summary(by=CaseOrControl) %>%
  add_p() %>%
  bold_labels() %>%
  bold_p()

## ---- cryptococcal-antigen-counts
#Explore cryptococcal Ag titer
crag_titer_counts <- CleanData%>%
  filter(CaseOrControl=="Case")%>%
  count(CryptococcalAg)

crag_result_counts <- CleanData%>%
  filter(CaseOrControl=="Case")%>%
  count(SerumCrAg)

## ---- pca-eigenvalues
#How much of the variance of the antibody titers can be collapsed into one or two variables?
pca_eigenvalue_table <- PCA %>%get_eigenvalue()%>%
  rownames_to_column("PCA Number")%>%
  flextable() %>%
  autofit()

## ---- summarise-roc-and-cutpoints
# Collect the AUC confidence intervals and optimal cutpoints computed in modeling.R
auc_ci_summary <- bind_rows(
  summarise_auc_ci(auc_ci_logtiter1_delong, auc_ci_logtiter1_bootstrap,
                   "Sex + log Lam-IgM + log GXM-IgM"),
  summarise_auc_ci(auc_ci_logtiter2_delong, auc_ci_logtiter2_bootstrap,
                   "log Lam-IgM + log GXM-IgM")
)

cutpoint_summary <- bind_rows(
  summarise_cutpoint(cutpoint_gxm_igm, "GXM-IgM"),
  summarise_cutpoint(cutpoint_log_gxm_igm, "log GXM-IgM"),
  summarise_cutpoint(cutpoint_lam_igm, "Lam-IgM"),
  summarise_cutpoint(cutpoint_log_lam_igm, "log Lam-IgM")
)

## ---- export-tables
dir.create(tables_dir, showWarnings = FALSE)

save_gtsummary_html(table1_all, file.path(tables_dir, "table1_all.html"))
save_gtsummary_html(table1_no_missing_titers, file.path(tables_dir, "table1_no_missing_titers.html"))
save_gtsummary_html(regression_table_titer, file.path(tables_dir, "regression_titer.html"))
save_gtsummary_html(regression_table_logtiter_1, file.path(tables_dir, "regression_log_titer_model1.html"))
save_gtsummary_html(regression_table_logtiter_2, file.path(tables_dir, "regression_log_titer_models1_2.html"))
save_gtsummary_html(sensitivity_table_log_lam_igm, file.path(tables_dir, "sensitivity_log_lam_igm.html"))
save_gtsummary_html(sensitivity_table_log_gxm_igm, file.path(tables_dir, "sensitivity_log_gxm_igm.html"))
save_gtsummary_html(pc_regression_table, file.path(tables_dir, "regression_principal_components.html"))

save_flextable_html(crag_titer_counts, file.path(tables_dir, "crag_titer_counts.html"))
save_flextable_html(crag_result_counts, file.path(tables_dir, "crag_result_counts.html"))
save_flextable_html(auc_ci_summary, file.path(tables_dir, "auc_confidence_intervals.html"))
save_flextable_html(cutpoint_summary, file.path(tables_dir, "optimal_cutpoints.html"))
save_as_html(pca_eigenvalue_table, path = file.path(tables_dir, "pca_eigenvalues.html"))
