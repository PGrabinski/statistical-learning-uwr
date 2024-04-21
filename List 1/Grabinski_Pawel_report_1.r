#-----------------------------------------
# Problem 3
#-----------------------------------------
install.packages("ggplot2")
library(ggplot2)
install.packages("ellipse")
library(ellipse)

covariance <- matrix(c(278784, 990, 990, 6.25), nrow = 2, ncol = 2)

means <- c(3343, 49.8)

# Calculate the eigenvalues and eigenvectors
result <- eigen(covariance)

# Extract the eigenvalues
eigenvalues <- result$values

# Extract the eigenvectors
eigenvectors <- result$vectors

# Print the results
cat("Eigenvalues:\n")
print(eigenvalues)

cat("\nEigenvectors:\n")
print(eigenvectors)

cat("\nEigenvectors multiplied by -1:\n")
print(-1*eigenvectors)

cat("\nEigenvectors multiplied by -1 and round:\n")
print(round(-1*eigenvectors, 5))

generate_ellipse_data <- function(covariance, means, level) {  
  # sigma: covariance matrix, mu: mean vector, level: probability 
  ellipse_data = ellipse(x = covariance, centre = means, level = level)
  ellipse_data = as.data.frame(ellipse_data)
  return(ellipse_data)
}

vectors_to_plot <- data.frame(
  x_center = c(means[1], means[1]),
  y_center = c(means[2], means[2]),
  x_end = c(means[1] + (-1)*sqrt(eigenvalues[1])*eigenvectors[1, 1], means[1] + (-1)*sqrt(eigenvalues[2])*eigenvectors[1, 2]),
  y_end = c(means[2] + (-1)*sqrt(eigenvalues[1])*eigenvectors[2, 1], means[2] + (-1)*sqrt(eigenvalues[2])*eigenvectors[2, 2])
)

ggplot() +
  geom_segment(
    data = vectors_to_plot, 
    aes(x = x_center, y = y_center, xend = x_end, yend = y_end),
    arrow = arrow(length = unit(0.5, "cm")))+
  geom_path(data = generate_ellipse_data(covariance, means, 0.95), aes(x = x, y = y), color='red') +
  geom_path(data = generate_ellipse_data(covariance, means, 0.9), aes(x = x, y = y), color='green') +
  geom_path(data = generate_ellipse_data(covariance, means, 0.8), aes(x = x, y = y), color='blue') +
  geom_path(data = generate_ellipse_data(covariance, means, 0.75), aes(x = x, y = y), color='yellow') +
  geom_path(data = generate_ellipse_data(covariance, means, 0.4), aes(x = x, y = y), color='black') +
  theme_bw() +
  labs(x = "Weight [g]", y = "Length [cm]")
ggsave("List 1/E3P3.png", width = 6, height = 4, units = "in")

#--------------------------
# Project Part 1
#--------------------------

set.seed(42)

install.packages("ggplot2")
library(ggplot2)
install.packages("ellipse")
library(ellipse)
install.packages("patchwork")
library(patchwork)

children_data <- read.table("List 1/WeightLength.txt", header=TRUE)
means <- colMeans(children_data)
round(means, 2)

covariance <- cov(children_data)
round(covariance, 2)

cor(children_data)

png("List 1/weight_qqplot.png")
qqnorm(children_data[["Weight"]])
dev.off()

png("List 1/length_qqplot.png")
qqnorm(children_data[["Length"]])
dev.off()

png("List 1/children_data.png")
plot(children_data)
dev.off()

generate_ellipse_data <- function(covariance, means, level) {  
  # sigma: covariance matrix, mu: mean vector, level: probability 
  ellipse_data = ellipse(x = covariance, centre = means, level = level)
  ellipse_data = as.data.frame(ellipse_data)
  return(ellipse_data)
}

centralized_children_data <- sweep(children_data, MARGIN=2, means, FUN="-")

children_c2 <- rowSums((as.matrix(centralized_children_data) %*% solve(covariance)) * (centralized_children_data))

children_c2_in_outer_ellipse <- children_c2 <= qchisq(0.95, df=2)
children_c2_in_inner_ellipse <- children_c2 <= qchisq(0.75, df=2)
children_labels <- as.integer(children_c2_in_outer_ellipse & !children_c2_in_inner_ellipse) + 2 * as.integer(children_c2_in_inner_ellipse) +1
labels <- c("Score_0", "Score_1", "Score_2")
children_labels <- labels[children_labels]

table(children_labels)

color_mapping <- c("Score_0" = "red", "Score_1" = "blue", "Score_2" = "green")
ggplot() +
  geom_path(data = generate_ellipse_data(covariance, means, 0.95), aes(x = Weight, y = Length), color='red') +
  geom_path(data = generate_ellipse_data(covariance, means, 0.75), aes(x = Weight, y = Length), color='green') +
  geom_point(data = children_data, aes(x = Weight, y = Length, color=children_labels), size = 1, shape = 21) +
  scale_color_manual(values = color_mapping) +
  theme_bw() +
  labs(x = "Weight [g]", y = "Length [cm]")
ggsave("List 1/children_classified.png", width = 6, height = 4, units = "in")

decomposition <- eigen(covariance)
decomposition

decomposition$vectors <- decomposition$vectors * (-1)
decomposition

decomposition$values[1] * decomposition$vectors[,1] %*% t(decomposition$vectors[,1]) 

decomposition$values[2] * decomposition$vectors[,2] %*% t(decomposition$vectors[,2]) 

decomposition$values[1] * decomposition$vectors[,1] %*% t(decomposition$vectors[,1]) + decomposition$values[2] * decomposition$vectors[,2] %*% t(decomposition$vectors[,2]) - covariance

children_data_ptransformed <- as.data.frame(as.matrix(children_data) %*% decomposition$vectors)
children_data_ptransformed

ggplot() +
  geom_point(data = children_data_ptransformed, aes(x = V1, y = V2, color=children_labels), size = 1, shape = 21) +
  scale_color_manual(values = color_mapping) +
  theme_bw()
ggsave("List 1/deentanlged_children.png", width = 6, height = 4, units = "in")

#--------------------------
# Project Part 2
#--------------------------
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
