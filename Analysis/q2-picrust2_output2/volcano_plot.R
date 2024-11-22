# Volcano plot in ggplot
library(ggplot2)
install.packages("ggrepel")
library(ggrepel)


#making the y axis of the volcano plot
qvalue = -log10(glm.test$`Altitude_groupLow:pval`)
# making the x axis of the volcano plot 
xvalue = (glm.eff$Altitude_groupLow$diff.btw)
#the names of different metabolic pathways
metabolic_names <- rownames(glm.test)
# Making a dataframe for ggplot
df = data.frame(Feature = metabolic_names, effect = xvalue, pval = qvalue)
# Add a column to mark significance (p < 0.05)
df$significance = ifelse(df$pval > 1.3, "Significant", "Not Significant")

ggplot(df, aes(x = effect, y = pval, color = significance, label = Feature)) +
  geom_point(alpha = 0.5, size = 1) +  # Puntos del gráfico
  scale_color_manual(values = c("Significant" = "red", "Not Significant" = "black")) +  # Colores
  geom_text_repel(data= subset(df,significance == "Significant"), aes(label = Feature), size = 2, box.padding = 1, max.overlaps = 11, color = "black") +  # Etiquetas
  theme_bw()+
  labs(
    title = "Volcano Plot",
    x = "Median Log2 Difference",
    y = "-1* MedianLog10 q value") +
  theme( plot.title = element_text(hjust = 0.5),
         legend.position = "none") 
