set.seed(42)

install.packages("ggplot2")
library(ggplot2)
install.packages("ellipse")
library(ellipse)
install.packages("patchwork")
library(patchwork)

children_data <- read.table("List 1/WeightLength.txt", header=TRUE)
means <- colMeans(children_data)
means

covariance <- cov(children_data)
covariance

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