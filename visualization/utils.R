# Function ---------------------------------------------------------------------
# Faceted Histogram plot of the Incidence rate per 100,000 by disease
# Require: "df_plot": data frame with columns
#    - "date": date in ISO format YYYY-MM-DD
#    - "incidence_rate": value to plot as y axis
#    - "vaccine": date of the vaccine introduction in ISO format YYYY-MM-DD
#    - "disease": name of the associated disease
# X-axis labelled by default with date breaks of 5 years, label with YYYY only.
plot_national_incidence <- function(df_plot,
                                    filename = "national_incidence_rate.png",
                                    ylab = "Incidence Rate per 100,000",
                                    y_axis = "incidence_rate",
                                    save = TRUE, width = 25, height = 20,
                                    font_size = 12, font_face = "plain",
                                    line_width = 2, dpi = 300) {

  plot <- ggplot(data = df_plot) +
    geom_col(aes(x = date, y = .data[[y_axis]])) +
    geom_vline(aes(xintercept = vaccine), color = "red", na.rm = TRUE,
               linewidth = line_width)

  if (length(unique(df_plot$disease)) > 1 )
    plot <- plot + facet_wrap(~disease, scales = "free", ncol = 2)

  plot <- plot +
    theme_classic() +
    theme(legend.text = element_text(size = font_size),
          axis.text = element_text(size = font_size),
          axis.title = element_text(size = font_size + 2, face = font_face)) +
    labs(x = "Date", y = ylab)

  if (length(unique(df_plot$disease)) > 1 )
    plot <- plot + theme(strip.text = element_text(size = font_size + 2,
                                                   face = font_face))

  if (save) ggsave(filename, plot, width = width, height = height, dpi = dpi)

  return(plot)
}
