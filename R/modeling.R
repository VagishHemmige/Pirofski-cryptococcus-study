# Purpose: fit the logistic regression models, ROC curves and optimal titer cutpoints.
# Needs: CleanData, CategoricalVariables, ContinuousVariables, TiterVariables,
#   LogTiterVariables (import_clean.R).
# Produces: regression tables (gtsummary objects), fitted glm models, ROC objects,
#   AUC confidence intervals and cutpointr results, used by tables.R and figures.R.
# Source: the "regressiontables" chunk of the original 2022 R Markdown file. The
#   model code is unchanged. Results that the R Markdown file printed inline are
#   now assigned to named objects, because sourced scripts do not print.

## ---- univariate-titer-models
#Univariate regression tables utilizing titer
univariatetitertable<-CleanData %>%
  select(HasCryptococcus, CategoricalVariables, ContinuousVariables) %>%
  select(-CaseOrControl, -TransplantOrgan, -LogTiterVariables, -DrugCNI, -CNSDisease) %>%
  tbl_uvregression(method = glm, y = HasCryptococcus, method.args = list(family = binomial),
                   exponentiate = TRUE) %>%
  bold_p()%>%
  add_inline_forest_plot()

## ---- multivariable-titer-model
#Multivariate model

mvtitermodel1 <- glm(HasCryptococcus ~ Sex+LAMIgM, family = binomial, data=CleanData)

multivariatetitertable<-tbl_regression(mvtitermodel1, exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()


#Prints the final regression table
regression_table_titer <- tbl_merge( tbls = list(univariatetitertable, multivariatetitertable), tab_spanner = c("**Univariate Model**", "**Multivariate Model**"))

## ---- roc-titer-model
#ROC curve
test_prob_titer = predict(mvtitermodel1, newdata = CleanData, type = "response")
titer_roc = pROC::roc(CleanData$HasCryptococcus ~ test_prob_titer, plot = TRUE, print.auc = TRUE)

## ---- univariate-log-titer-models
#Repeat the same model building analysis except with log titers:

univariatelogtitertable<-CleanData %>%
  select(HasCryptococcus, CategoricalVariables, ContinuousVariables) %>%
  select(-CaseOrControl, -TransplantOrgan, -TiterVariables, -DrugCNI, -CNSDisease) %>%
  tbl_uvregression(method = glm, y = HasCryptococcus, method.args = list(family = binomial),
                   exponentiate = TRUE) %>%
  bold_p()%>%
  add_inline_forest_plot()

## ---- multivariable-log-titer-models
#Multivariate modeling

mvlogtitermodel1 <-glm(HasCryptococcus ~ Sex+log_LAMIgM+log_GXMIgM, family = binomial, data=CleanData)
mvlogtitermodel2<-glm(HasCryptococcus ~ log_LAMIgM+log_GXMIgM,
                      family = binomial, data=CleanData)
mvlogtitermodel3<-glm(HasCryptococcus ~ Sex+log_LAMIgM, family = binomial, data=CleanData)
mvlogtitermodel4<-glm(HasCryptococcus ~ Sex+log_GXMIgM, family = binomial, data=CleanData)


multivariatelogtitertable1<-tbl_regression(mvlogtitermodel1, exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()

multivariatelogtitertable2<-tbl_regression(mvlogtitermodel2, exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()

multivariatelogtitertable3<-tbl_regression(mvlogtitermodel3, exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()

multivariatelogtitertable4<-tbl_regression(mvlogtitermodel4, exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()


#Prints the final logistic regression tables
regression_table_logtiter_1 <- tbl_merge( tbls = list(univariatelogtitertable, multivariatelogtitertable1), tab_spanner = c("**Univariate Model**", "**Multivariate Model**"))

regression_table_logtiter_2 <- tbl_merge( tbls = list(univariatelogtitertable, multivariatelogtitertable1, multivariatelogtitertable2 ), tab_spanner = c("**Univariate Model**", "**Multivariate Model 1**","**Multivariate Model 2**"))

## ---- roc-log-titer-models
#ROC curve 1
test_prob_logtiter1 = predict(mvlogtitermodel1, newdata = CleanData, type = "response")
logtiter_roc1 = pROC::roc(CleanData$HasCryptococcus ~ test_prob_logtiter1, plot = TRUE, print.auc = TRUE)

#Calculate 95% confidence intervals, both analytically and using bootstrapping
auc_ci_logtiter1_delong <- ci.auc(logtiter_roc1, method="delong")
auc_ci_logtiter1_bootstrap <- ci.auc(logtiter_roc1, method="bootstrap")

#ROC curve 2
test_prob_logtiter2 = predict(mvlogtitermodel2, newdata = CleanData, type = "response")
logtiter_roc2 = pROC::roc(CleanData$HasCryptococcus ~ test_prob_logtiter2, plot = TRUE, print.auc = TRUE)

#Calculate 95% confidence intervals, both analytically and using bootstrapping
auc_ci_logtiter2_delong <- ci.auc(logtiter_roc2, method="delong")
auc_ci_logtiter2_bootstrap <- ci.auc(logtiter_roc2, method="bootstrap")

## ---- sensitivity-single-antibody-models
#Given the collinearity between log_LAMIgM and log_GXMIgM, as a sensitivity analysis we explore the results of including only one of the two variables in the multivariable model, and not both:

sensitivity_table_log_lam_igm <- glm(HasCryptococcus ~ Sex+log_LAMIgM, family = binomial, data=CleanData) %>%
  tbl_regression(., exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()


sensitivity_table_log_gxm_igm <- glm(HasCryptococcus ~ Sex+log_GXMIgM, family = binomial, data=CleanData) %>%
  tbl_regression(., exponentiate = TRUE)%>%
  bold_p()%>%
  add_inline_forest_plot()

## ---- optimal-cutpoints
#Optimized cutpoints using sum of sensitivity and specificity
cutpoint_gxm_igm <- cutpointr(CleanData, GXMIgM, HasCryptococcus,
          method = maximize_metric, metric = sum_sens_spec, na.rm = TRUE, pos_class = "TRUE")%>%
  add_metric(list(ppv, npv))

cutpoint_log_gxm_igm <- cutpointr(CleanData, log_GXMIgM, HasCryptococcus,
          method = maximize_metric, metric = sum_sens_spec, na.rm = TRUE, pos_class = "TRUE")%>%
  add_metric(list(ppv, npv))

cutpoint_lam_igm <- cutpointr(CleanData, LAMIgM, HasCryptococcus,
          method = maximize_metric, metric = sum_sens_spec, na.rm = TRUE, pos_class = "TRUE")%>%
  add_metric(list(ppv, npv))

cutpoint_log_lam_igm <- cutpointr(CleanData, log_LAMIgM, HasCryptococcus,
          method = maximize_metric, metric = sum_sens_spec, na.rm = TRUE, pos_class = "TRUE")%>%
  add_metric(list(ppv, npv))
