# Purpose: create every figure and export it to figures/.
# Needs: CleanData, CleanData_NoMissingTiters, TiterVariables, LogTiterVariables
#   (import_clean.R); titer_roc, logtiter_roc1, logtiter_roc2 (modeling.R);
#   PCA, columns (pca.R); figures_dir (setup.R).
# Produces: PNG files in figures/.
# Source: the plotting code is from the "factetedplots" and "corrplot1" chunks of
#   the original 2022 R Markdown file and is unchanged. The png()/ggsave() export
#   calls, and the plot() calls that redraw the ROC curves into files, are new.

## ---- setup-figures-dir
dir.create(figures_dir, showWarnings = FALSE)

## ---- faceted-titer-plot
#Create a long table so that all antibody titers can be placed in one or two plots
LongTiterDataNoMissingTiters<-CleanData_NoMissingTiters%>%pivot_longer(cols=TiterVariables,
                                                                       names_to = "Antibody",
                                                                       values_to="titer")

#Create pivoted plot of titer data
faceted_titer_plot <- LongTiterDataNoMissingTiters %>% ggplot()+
  geom_violin(mapping = aes(x=CaseOrControl, y=titer), color = NA, alpha=0.5,fill = "grey",
              draw_quantiles = 1)+
  stat_summary(mapping = aes(x=CaseOrControl, y=titer),fun = median, fun.min = median, fun.max = median,
               geom = "crossbar", width = 0.9, fatten=1.5)+
  geom_quasirandom(mapping = aes(x=CaseOrControl, y=titer, color=TransplantOrgan, shape=Sex), cex=2, alpha=0.7)+
  stat_compare_means(mapping = aes(x=CaseOrControl, y=titer, label = paste0("p =", ..p.format..))) +
  theme_classic()+
  scale_y_continuous(trans='log10') +
  facet_grid(.~Antibody)+
  labs(x = "", y="Antibody titer (µg/mL)", color="Transplanted Organ",
       caption = "Patients with missing titer data excluded")

# Same size as the original chunk (fig.height=5.6, fig.width=9.38)
ggsave(file.path(figures_dir, "faceted_titer_plot.png"), faceted_titer_plot,
       width = 9.38, height = 5.6, dpi = 300)

## ---- roc-curves
# Redraw the ROC curves fitted in modeling.R into files
png(file.path(figures_dir, "roc_titer_model.png"), width = 6, height = 6, units = "in", res = 300)
plot(titer_roc, print.auc = TRUE)
dev.off()

png(file.path(figures_dir, "roc_log_titer_model1.png"), width = 6, height = 6, units = "in", res = 300)
plot(logtiter_roc1, print.auc = TRUE)
dev.off()

png(file.path(figures_dir, "roc_log_titer_model2.png"), width = 6, height = 6, units = "in", res = 300)
plot(logtiter_roc2, print.auc = TRUE)
dev.off()

## ---- correlation-plots
#We plot a correlation matrix of the antibody titer data on the logarithmic scale
png(file.path(figures_dir, "corrplot_log_titers_all.png"), width = 7, height = 7, units = "in", res = 300)
CleanData_NoMissingTiters %>%
  select(LogTiterVariables) %>%
  cor(use="complete.obs", method = "pearson")%>%
  corrplot(., method="color",
  diag=FALSE,
  addCoef.col = "black"  )
dev.off()

#We plot a correlation matrix of the antibody titer data on the logarithmic scale, Cases only
png(file.path(figures_dir, "corrplot_log_titers_cases.png"), width = 7, height = 7, units = "in", res = 300)
CleanData %>%
  filter(CaseOrControl=="Case") %>%
  select(LogTiterVariables ) %>%
  cor(use="complete.obs", method = "pearson")%>%
  corrplot(., method="color",
  diag=FALSE,
  addCoef.col = "black"  )
dev.off()

#We plot a correlation matrix of the antibody titer data on the logarithmic scale, Control patients only
png(file.path(figures_dir, "corrplot_log_titers_controls.png"), width = 7, height = 7, units = "in", res = 300)
CleanData %>%
  filter(CaseOrControl=="Control") %>%
  select(LogTiterVariables) %>%
  cor(use="complete.obs", method = "pearson")%>%
  corrplot(., method="color",
  diag=FALSE,
  addCoef.col = "black"  )
dev.off()

## ---- pca-plots
#Plot results
pca_individuals_plot <- fviz_pca_ind(PCA,
             col.ind=CleanData_NoMissingTiters$CaseOrControl,
             addEllipses = TRUE,
             ellipse.type = "confidence",
             label="none")

ggsave(file.path(figures_dir, "pca_individuals.png"), pca_individuals_plot,
       width = 7, height = 6, dpi = 300)

#Plot result along with variables themselves
pca_biplot <- fviz_pca_biplot(PCA,
                label ="var",
                col.ind=CleanData_NoMissingTiters$CaseOrControl,
                addEllipses = TRUE,
                ellipse.type = "confidence")

ggsave(file.path(figures_dir, "pca_biplot.png"), pca_biplot,
       width = 7, height = 6, dpi = 300)

## ---- pca-component-correlation
#Confirm that PCA truly resulted in uncorrelated predictors:
png(file.path(figures_dir, "corrplot_principal_components.png"), width = 7, height = 7, units = "in", res = 300)
columns %>%
  cor(use="complete.obs")%>%
  corrplot(., method="color",
           diag=FALSE,
           addCoef.col = "black"  )
dev.off()
