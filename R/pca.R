# Purpose: principal component analysis of the log antibody titers, and logistic
#   regression of cryptococcosis status on the principal components.
# Needs: CleanData_NoMissingTiters, LogTiterVariables (import_clean.R).
# Produces: PCA (prcomp object), columns (component scores), PCAData,
#   pc_regression_table, used by tables.R and figures.R.
# Source: the "corrplot1" chunk of the original 2022 R Markdown file. The
#   correlation plots and PCA plots from that chunk are in figures.R, and the
#   eigenvalue table is in tables.R. The PCA code is unchanged; the final
#   regression table, which the R Markdown file printed, is assigned to a name.

## ---- fit-pca
#PCA analysis

#Run PCA on log of titer data
PCA<-CleanData_NoMissingTiters%>%
  select(LogTiterVariables)%>%
  prcomp(scale=TRUE)

## ---- pca-scores
#Add PCA results to CleanData_NoMissingTiters
columns<-predict(PCA)
PCAData<-cbind(CleanData_NoMissingTiters, columns)

## ---- pca-regression
#Are the principal components predictors of cryptococcus status?
pc_regression_table <- glm(HasCryptococcus ~ PC1+PC2+PC3+PC4+PC5+PC6+PC7, family = binomial, data=PCAData) %>%
  tbl_regression(., exponentiate = TRUE)%>%
  bold_p()
