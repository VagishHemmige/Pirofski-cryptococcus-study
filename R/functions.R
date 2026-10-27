# Purpose: helper functions that export tables. None of them changes an estimate;
#   they only reshape or save results computed by the analysis scripts.
# Needs: setup.R. Produces: functions only.
# These are new in the repository version; the original R Markdown file printed
# its tables inline instead of saving them.

## ---- save-gtsummary-html
# Save a gtsummary table (tbl_summary, tbl_regression, tbl_merge, ...) as a
# self-contained HTML file.
save_gtsummary_html <- function(tbl, file) {
  tbl %>%
    gtsummary::as_gt() %>%
    gt::gtsave(filename = file)
  invisible(file)
}

## ---- relabel-table
# Replace variable names and category codes in a gtsummary table with readable
# labels, for display only. Variables or categories not listed are left as they
# are. Estimates, reference categories and row order are unchanged.
relabel_table <- function(tbl, variable_labels, level_labels) {
  gtsummary::modify_table_body(tbl, function(body) {
    is_label_row <- body$row_type == "label" & body$variable %in% names(variable_labels)
    body$label[is_label_row] <- unname(variable_labels[body$variable[is_label_row]])
    for (v in names(level_labels)) {
      map <- level_labels[[v]]
      is_level_row <- body$variable == v & body$row_type == "level" & body$label %in% names(map)
      body$label[is_level_row] <- unname(map[body$label[is_level_row]])
    }
    body
  })
}

## ---- save-flextable-html
# Save a data frame as an HTML table via flextable.
save_flextable_html <- function(df, file) {
  df %>%
    flextable() %>%
    autofit() %>%
    save_as_html(path = file)
  invisible(file)
}

## ---- summarise-cutpoint
# One row per cutpointr result: the optimal cutpoint and its operating
# characteristics, as computed by cutpointr() and add_metric() in modeling.R,
# rounded to 3 decimal places for display.
summarise_cutpoint <- function(cp, label) {
  tibble(
    Antibody = label,
    `Optimal cutpoint` = round(cp$optimal_cutpoint, 3),
    Sensitivity = round(cp$sensitivity, 3),
    Specificity = round(cp$specificity, 3),
    PPV = round(cp$ppv, 3),
    NPV = round(cp$npv, 3),
    AUC = round(cp$AUC, 3)
  )
}

## ---- summarise-auc-ci
# One row per ROC curve: the AUC with its DeLong and bootstrap 95% CIs, as
# computed by ci.auc() in modeling.R. ci.auc() returns c(lower, AUC, upper).
summarise_auc_ci <- function(delong, bootstrap, label) {
  tibble(
    Model = label,
    AUC = round(delong[2], 3),
    `DeLong 95% CI` = sprintf("%.3f to %.3f", delong[1], delong[3]),
    `Bootstrap 95% CI` = sprintf("%.3f to %.3f", bootstrap[1], bootstrap[3])
  )
}
