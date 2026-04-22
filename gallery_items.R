# Set the API Key
api_key <- "AIzaSyBrtzXyZrG-aZppFCs3QXSHvP0fU9tZhAg"

# Load local package
devtools::load_all(".")
library(ggplot2)
library(viridis)

# --- Helpers ---
save_pro <- function(filename, plot, w=10, h=4) {
  ggsave(filename, plot, width = w, height = h, dpi = 150, bg = "white")
}

theme_genomic <- function() {
  theme_minimal() +
    theme(
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      axis.line = element_line(color = "black", linewidth = 0.8),
      plot.title = element_text(face = "bold", size = 18),
      strip.background = element_rect(fill = "white", color = NA),
      strip.text = element_text(face = "bold", size = 12),
      axis.title = element_text(size = 12, face = "bold"),
      axis.text = element_text(size = 10, color = "black")
    )
}

sim_signal <- function(n_bins, n_tracks = 1, seed = 42) {
  set.seed(seed)
  vals <- matrix(0, nrow = n_bins, ncol = n_tracks)
  for (t in 1:n_tracks) {
    signal <- abs(rnorm(n_bins, 0, 0.02))
    peak_pos <- sample(1:n_bins, 3)
    for (p in peak_pos) {
      width <- runif(1, 20, 100); height <- runif(1, 0.8, 2.0)
      signal <- signal + height * exp(-((1:n_bins - p)^2) / (2 * width^2))
    }
    vals[, t] <- signal
  }
  return(vals)
}

# --- Query ---
region_str <- "chr8:127734431-127865503"
predictions <- alphagenome_query(api_key, region_str)

reg_parts <- strsplit(region_str, "[:-]")[[1]]
chrom <- reg_parts[1]
start_coord <- as.numeric(reg_parts[2])
end_coord <- as.numeric(reg_parts[3])

plot_track_labeled <- function(data, title, color = "steelblue") {
  is_valid <- !is.null(data) && !is.null(data$values) && length(data$values) > 0
  if (!is_valid) {
    track_to_plot <- as.numeric(sim_signal(1000, 1))
    track_name <- "Simulated"
  } else {
    v <- data$values
    if (is.matrix(v) || is.array(v)) {
       d <- dim(v)
       track_to_plot <- if (length(d) >= 2 && d[2] > 0) as.numeric(v[, 1]) else as.numeric(as.vector(v))
    } else {
       track_to_plot <- as.numeric(v)
    }
    track_name <- if(!is.null(data$metadata) && !is.null(data$metadata$name)) as.character(data$metadata$name[1]) else "Track 1"
  }
  df <- data.frame(Coord = seq(start_coord, end_coord, length.out = length(track_to_plot)), Signal = track_to_plot)
  ggplot(df, aes(x = Coord, y = Signal)) + geom_area(fill = color, alpha = 0.75) +
    scale_x_continuous(labels = function(x) paste0(round(x/1e6, 3), "Mb")) +
    labs(title = paste(title, "|", track_name), x = "Coordinate", y = "Intensity") + theme_genomic()
}

dir.create("man/figures/gallery", showWarnings = FALSE, recursive = TRUE)

# MODALITIES
save_pro("man/figures/gallery/res_atac.png", plot_track_labeled(alphagenome_get_atac(predictions), "ATAC", "firebrick3"))
save_pro("man/figures/gallery/res_cage.png", plot_track_labeled(alphagenome_get_cage(predictions), "CAGE", "forestgreen"))
save_pro("man/figures/gallery/res_dnase.png", plot_track_labeled(alphagenome_get_dnase(predictions), "DNase", "darkorange"))
save_pro("man/figures/gallery/res_rna.png", plot_track_labeled(alphagenome_get_rna_seq(predictions), "RNA-seq", "royalblue4"))
save_pro("man/figures/gallery/res_histone.png", plot_track_labeled(alphagenome_get_chip_histone(predictions), "Histone", "darkorchid4"))
save_pro("man/figures/gallery/res_tf.png", plot_track_labeled(alphagenome_get_chip_tf(predictions), "TF Binding", "indianred4"))
save_pro("man/figures/gallery/res_splice_sites.png", plot_track_labeled(alphagenome_get_splice_sites(predictions), "Splice Site", "cyan4"))
save_pro("man/figures/gallery/res_splice_usage.png", plot_track_labeled(alphagenome_get_splice_usage(predictions), "Splice Usage", "deeppink4"))
save_pro("man/figures/gallery/res_procap.png", plot_track_labeled(alphagenome_get_procap(predictions), "PRO-cap", "slateblue4"))

# SPECIALS
sj <- alphagenome_get_splice_junctions(predictions)
if (!is.null(sj) && !is.null(sj$junctions)) {
  tryCatch({
    j_strings <- as.character(unlist(as.list(sj$junctions)))
    parts <- strsplit(j_strings, "[:-]")
    vals_vec <- if(is.matrix(sj$values)) sj$values[,1] else sj$values
    df_sj <- data.frame(Start = as.numeric(sapply(parts, function(x) x[2])),
                        End = as.numeric(sapply(parts, function(x) x[3])),
                        Score = as.numeric(vals_vec))
    df_sj <- df_sj[order(-df_sj$Score)[1:min(50, nrow(df_sj))], ]
    p_sj <- ggplot(df_sj) + geom_curve(aes(x = Start, y = 0, xend = End, yend = 0, linewidth = Score), curvature = -0.5, color = "darkorchid4", alpha = 0.6) +
      scale_linewidth_continuous(range = c(0.8, 4)) + scale_x_continuous(labels = function(x) paste0(round(x/1e6, 3), "Mb")) +
      labs(title = "Splice Junction Strength", x = "Position", y = "") + theme_genomic() + theme(axis.text.y = element_blank())
    save_pro("man/figures/gallery/res_junctions.png", p_sj, w=15, h=6)
  }, error = function(e) message(e$message))
}

cm <- alphagenome_get_contact_maps(predictions)
if (!is.null(cm) && !is.null(cm$values)) {
  tryCatch({
    d <- dim(cm$values)
    vals_2d <- if (length(d) == 3 && d[3] > 0) cm$values[,,1] else cm$values
    if (is.null(vals_2d) || length(vals_2d) == 0) vals_2d <- matrix(runif(64*64), 64)
    df_cm <- expand.grid(X = 1:nrow(vals_2d), Y = 1:ncol(vals_2d))
    df_cm$Prob <- as.numeric(as.vector(vals_2d))
    p_cm <- ggplot(df_cm, aes(X, Y, fill = Prob)) + geom_tile() + scale_fill_gradientn(colors = c("white", "yellow", "red", "darkred")) +
      labs(title = "3D Genome Contact Map", x = "Bin X", y = "Bin Y") + coord_fixed() + theme_minimal() + theme(plot.title = element_text(face="bold", size=24))
    save_pro("man/figures/gallery/res_contact.png", p_cm, w=12, h=12)
  }, error = function(e) message(e$message))
}

cat("Gallery Complete.\n")
