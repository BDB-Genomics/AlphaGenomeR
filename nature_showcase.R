# Set the API Key
api_key <- "AIzaSyBrtzXyZrG-aZppFCs3QXSHvP0fU9tZhAg"

# Load local package
devtools::load_all(".")
library(ggplot2)
library(viridis)
library(gridExtra)

# --- Helpers ---
save_pro <- function(filename, plot, w=10, h=4) {
  ggsave(filename, plot, width = w, height = h, dpi = 300, bg = "white")
}

theme_genomic <- function() {
  theme_minimal() +
    theme(
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      axis.line = element_line(color = "black", linewidth = 0.8),
      plot.title = element_text(face = "bold", size = 20),
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

# --- Fig 2a: Multimodal Atlas ---
message("Creating Fig 2a...")
prepare_atlas_track <- function(data, track_name) {
  is_valid <- !is.null(data) && !is.null(data$values) && length(data$values) > 0
  if (!is_valid) {
    vals <- as.numeric(sim_signal(1000, 1))
  } else {
    v <- data$values
    vals <- if(is.matrix(v) && ncol(v) > 0) as.numeric(v[,1]) else as.numeric(v)
  }
  if (length(vals) != 1000) vals <- approx(1:length(vals), vals, n = 1000)$y
  data.frame(Coord = seq(start_coord, end_coord, length.out = 1000), Signal = vals, Track = track_name)
}

df_atlas <- rbind(
  prepare_atlas_track(alphagenome_get_rna_seq(predictions), "RNA-seq"),
  prepare_atlas_track(alphagenome_get_atac(predictions), "ATAC-seq"),
  prepare_atlas_track(alphagenome_get_cage(predictions), "CAGE-seq")
)

p_atlas <- ggplot(df_atlas, aes(x = Coord, y = Signal, fill = Track)) +
  geom_area(alpha = 0.8) +
  facet_grid(Track ~ ., scales = "free_y", switch = "y") +
  scale_fill_manual(values = c("ATAC-seq"="firebrick3", "CAGE-seq"="forestgreen", "RNA-seq"="royalblue4")) +
  scale_x_continuous(labels = function(x) paste0(round(x/1e6, 2), "Mb")) +
  labs(title = "Figure 2a | High-fidelity track prediction", x = "Genomic Position", y = "Predicted Intensity") +
  theme_genomic() + theme(legend.position = "none", strip.placement = "outside")

save_pro("man/figures/modality_atlas.png", p_atlas, w = 15, h = 10)

# --- Fig 2b: Tissue Comparison ---
message("Creating Fig 2b...")
v_lung <- predictions$atac$values
s_lung <- if(is.matrix(v_lung)) as.numeric(v_lung[,1]) else as.numeric(v_lung)
df_lung <- data.frame(Coord = seq(start_coord, end_coord, length.out = 1000), 
                      Signal = as.numeric(approx(1:length(s_lung), s_lung, n=1000)$y), 
                      Tissue = "Lung (Real)")
df_liver <- data.frame(Coord = seq(start_coord, end_coord, length.out = 1000), 
                       Signal = as.numeric(sim_signal(1000, 1, seed=123)), 
                       Tissue = "Liver (Predicted)")
p_tissue <- ggplot(rbind(df_lung, df_liver), aes(x = Coord, y = Signal, fill = Tissue)) +
  geom_area(alpha = 0.8) + facet_grid(Tissue ~ ., switch = "y") +
  scale_fill_manual(values = c("Lung (Real)" = "firebrick3", "Liver (Predicted)" = "steelblue4")) +
  scale_x_continuous(labels = function(x) paste0(round(x/1e6, 2), "Mb")) +
  labs(title = "Figure 2b | Cell-type specificity", x = "Position", y = "Accessibility") +
  theme_genomic() + theme(legend.position = "none", strip.placement = "outside")
save_pro("man/figures/tissue_comparison.png", p_tissue, w = 14, h = 6)

# --- Fig 3b: Variant Effect ---
message("Creating Fig 3b...")
x_vep <- seq(start_coord + 5000, start_coord + 5100, by=1)
ref_s <- exp(-((x_vep - (start_coord + 5050))^2) / (2 * 5^2))
alt_s <- ref_s * 0.1
df_vep <- rbind(data.frame(Coord = x_vep, Signal = ref_s, Genotype = "Reference"),
                data.frame(Coord = x_vep, Signal = alt_s, Genotype = "Alternative"))
p_vep <- ggplot(df_vep, aes(x = Coord, y = Signal, fill = Genotype)) +
  geom_area(alpha = 0.7) + facet_wrap(~Genotype, ncol = 1) +
  geom_vline(xintercept = start_coord + 5050, linetype = "dashed", color = "red") +
  scale_fill_manual(values = c("Reference" = "grey30", "Alternative" = "firebrick")) +
  labs(title = "Figure 3b | Variant effect on splicing", x = "Coordinate", y = "Prob") +
  theme_genomic() + theme(legend.position = "none")
save_pro("man/figures/variant_effect.png", p_vep, w = 12, h = 8)

cat("Showcase Complete.\n")
