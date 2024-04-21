set.seed(42)
install.packages("ggplot2")
library(ggplot2)
install.packages("ellipse")
library(ellipse)
install.packages("patchwork")
library(patchwork)
library(knitr)

parent_data <- read.table("List 1/ParentsWeightLength.txt", header=TRUE)
parent_data <- parent_data[,c(3,4,1,2)]

means <- colMeans(parent_data)
kable(round(means, 3))

covariance <- cov(parent_data)
kable(round(covariance, 3))

kable(round(cor(parent_data), 3))

png("List 1/parents_weight_qqplot.png")
qqnorm(parent_data[["Weight"]])
dev.off()

png("List 1/parents_length_qqplot.png")
qqnorm(parent_data[["Length"]])
dev.off()

png("List 1/father_height_qqplot.png")
qqnorm(parent_data[["FatherHeight"]])
dev.off()

png("List 1/mother_height_qqplot.png")
qqnorm(parent_data[["MotherHeight"]])
dev.off()

png("List 1/parents_data.png")
pairs(as.data.frame(parent_data))
dev.off()


# \Sigma_{12} \Sigma{22}^{-1}
kable(round(covariance[c(1, 2), c(3,4)] %*% solve(covariance[c(3, 4), c(3,4)]), 3))

# \Sigma_{11}-\Sigma_{12}\Sigma_{22}^{-1}\Sigma_{21}
conditional_covariance <- covariance[c(1, 2), c(1, 2)] - covariance[c(1, 2), c(3,4)] %*% solve(covariance[c(3, 4), c(3,4)]) %*% covariance[c(3, 4), c(1, 2)]
conditional_covariance

(conditional_covariance - covariance[c(1, 2), c(1, 2)])/covariance[c(1, 2), c(1, 2)]
kable(round(conditional_covariance/covariance[c(1, 2), c(1, 2)], 3))


center_means <- means[c(1, 2)]

generate_ellipse_data <- function(covariance, means, level) {  
  # sigma: covariance matrix, mu: mean vector, level: probability 
  ellipse_data = ellipse(x = covariance, centre = means, level = level)
  ellipse_data = as.data.frame(ellipse_data)
  return(ellipse_data)
}
# plot the elipsoids alone
color_mapping <- c("Score_0" = "red", "Score_1" = "blue", "Score_2" = "green")
ggplot() +
  geom_path(data = generate_ellipse_data(covariance[c(1,2), c(1, 2)], center_means, 0.95), aes(x = Weight, y = Length), color='orange') +
  geom_path(data = generate_ellipse_data(covariance[c(1,2), c(1, 2)], center_means, 0.75), aes(x = Weight, y = Length), color='green') +
  geom_path(data = generate_ellipse_data(conditional_covariance, center_means, 0.95), aes(x = Weight, y = Length), color='red') +
  geom_path(data = generate_ellipse_data(conditional_covariance, center_means, 0.75), aes(x = Weight, y = Length), color='darkgreen') +
  scale_color_manual(values = color_mapping) +
  theme_bw() +
  labs(x = "Weight [g]", y = "Length [cm]")
ggsave("List 1/ellipsoids_comparison.png", width = 6, height = 4, units = "in")

# Classification

centralized_parent_data <- sweep(parent_data[,c(3, 4)], MARGIN=2, means[c(3, 4)], FUN="-")
centralized_parent_data <- as.matrix(centralized_parent_data) %*% t(covariance[c(1, 2), c(3, 4)] %*% solve(covariance[c(3, 4), c(3, 4)]))
centralized_parent_data <- sweep(centralized_parent_data, MARGIN=2, means[c(1, 2)], FUN="+")
centralized_parent_data <- parent_data[,c(1,2)] - centralized_parent_data

parent_c2 <- rowSums((as.matrix(centralized_parent_data) %*% solve(conditional_covariance)) * (centralized_parent_data))

parent_c2_in_outer_ellipse <- parent_c2 <= qchisq(0.95, df=2)
parent_c2_in_inner_ellipse <- parent_c2 <= qchisq(0.75, df=2)
parent_labels <- as.integer(parent_c2_in_outer_ellipse & !parent_c2_in_inner_ellipse) + 2 * as.integer(parent_c2_in_inner_ellipse) +1
labels <- c("Score_0", "Score_1", "Score_2")
parent_labels <- labels[parent_labels]

table(parent_labels)
kable(table(parent_labels))

color_mapping <- c("Score_0" = "red", "Score_1" = "blue", "Score_2" = "green")
ggplot() +
  geom_path(data = generate_ellipse_data(conditional_covariance, center_means, 0.95), aes(x = Weight, y = Length), color='red') +
  geom_path(data = generate_ellipse_data(conditional_covariance, center_means, 0.75), aes(x = Weight, y = Length), color='darkgreen') +
  geom_point(data = parent_data[,c(1, 2)], aes(x = Weight, y = Length, color=parent_labels), size = 1, shape = 21) +
  scale_color_manual(values = color_mapping) +
  theme_bw() +
  labs(x = "Weight [g]", y = "Length [cm]")
ggsave("List 1/parents_classified.png", width = 6, height = 4, units = "in")

# elipsoids for given parent heights
elipsoids_plot <- ggplot() +
  theme_bw() +
  labs(x = "Weight [g]", y = "Length [cm]")
for (i in 0:20) {
  elipsoids_plot <- elipsoids_plot + geom_path(data = generate_ellipse_data(conditional_covariance, center_means, 0.05*i), aes(x = Weight, y = Length), color='black') 
}
ggsave("List 1/ellipsoids_conditional.png", width = 6, height = 4, units = "in")


# Spectral decomposition

decomposition <- eigen(covariance)
decomposition
kable(decomposition$values)
kable(decomposition$vectors)

reconstructed_matrix <- matrix(0, nrow=4, ncol=4)
for (i in 1:4) {
  partial_matrix <- decomposition$values[i] * decomposition$vectors[,i] %*% t(decomposition$vectors[,i])
  print(kable(partial_matrix))
  reconstructed_matrix <- reconstructed_matrix + partial_matrix
}

print(kable(reconstructed_matrix))
print(covariance - reconstructed_matrix)
print(round(covariance - reconstructed_matrix, 9))

# Transform to the eigenvector space

parent_data_ptransformed <- as.data.frame(as.matrix(parent_data) %*% decomposition$vectors)
parent_data_ptransformed

ggplot() +
  geom_point(data = parent_data_ptransformed, aes(x = V1, y = V2, color=parent_labels), size = 1, shape = 21) +
  scale_color_manual(values = color_mapping) +
  theme_bw()
ggsave("List 1/deentanlged_parent.png", width = 6, height = 4, units = "in")
