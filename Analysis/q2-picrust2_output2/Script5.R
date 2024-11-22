#for making the plot in ggplot2
#https://forum.qiime2.org/t/tutorial-integrating-qiime2-and-r-for-data-visualization-and-analysis-using-qiime2r/4121

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ALDEx2")
library(ALDEx2)

covariates <- data.frame("Altitude_groupLow" = c(rep(0, 5), rep(1, 4)),
                         "sulfur_groupLow" = c(rep(0, 1), rep(1, 4), rep(0, 4)))
pathway_abundance2_levels_Level_3_ALDEx2_round <- round(pathway_abundance2_levels_Level_3_ALDEx2)
mm <- model.matrix(~ Altitude_groupLow + sulfur_groupLow, covariates)
x.glm <- aldex.clr(pathway_abundance2_levels_Level_3_ALDEx2_round, mm, mc.samples=4, denom="all", verbose=T)
glm.test <- aldex.glm(x.glm, mm, fdr.method='holm')
glm.eff<- aldex.glm.effect(x.glm)

# NEW plot the glm.test and glm.eff data for particular contrasts
par(mfrow=c(1,1))
aldex.glm.plot(glm.test, eff=glm.eff, contrast='Altitude_groupLow', type='volcano', test='pval', thres.lwd=2, called.col="red", cutoff.pval=0.05, labels=)

aldex.glm.plot(glm.test, eff=glm.eff, contrast='sulfur_groupLow', type='volcano', test='pval')

#making the y axis of the volcano plot
qvalue = -log10(glm.test$`Altitude_groupLow:pval`)

#made plot in ggplot
results %>%
  left_join(taxonomy) %>%
  mutate(Significant=if_else(we.eBH<0.1,TRUE, FALSE)) %>%
  mutate(Taxon=as.character(Taxon)) %>%
  mutate(TaxonToPrint=if_else(we.eBH<0.1, Taxon, "")) %>% #only provide a label to signifcant results
  ggplot(aes(x=diff.btw, y=-log10(we.ep), color=Significant, label=TaxonToPrint)) +
  geom_text_repel(size=1, nudge_y=0.05) +
  geom_point(alpha=0.6, shape=16) +
  theme_q2r() +
  xlab("log2(fold change)") +
  ylab("-log10(P-value)") +
  theme(legend.position="none") +
  scale_color_manual(values=c("black","red"))
ggsave("volcano.pdf", height=3, width=3, device="pdf")

#return the name of the samples

names = getSampleIDs(x.glm)
features = getFeatureNames(x.glm)
