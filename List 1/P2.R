set.seed(42)
install.packages("ggplot2")
library(ggplot2)
install.packages("ellipse")
library(ellipse)
install.packages("patchwork")
library(patchwork)

parent_data <- read.table("List 1/ParentsWeightLength.txt", header=TRUE)
parent_data

means <- colMeans(parent_data)
means

covariance <- cov(parent_data)
covariance

cor(parent_data)

png("List 1/parents_weight_qqplot.png")
qqnorm(parent_data[["Weight"]])
dev.off()

png("List 1/parents_length_qqplot.png")
qqnorm(parent_data[["Length"]])
dev.off()

png("List 1/father_height_qqplot.png")
qqnorm(parent_data[["FatherHeight"]])
dev.off()

png("List 1/mother_weight_qqplot.png")
qqnorm(parent_data[["MotherHeight"]])
dev.off()

png("List 1/parents_data.png")
pairs(as.data.frame(parent_data))
dev.off()






decomposition <- eigen(covariance)
decomposition

reconstructed_matrix <- matrix(0, nrow=4, ncol=4)
for (i in 1:4) {
  partial_matrix <- decomposition$values[i] * decomposition$vectors[,i] %*% t(decomposition$vectors[,i])
  print(partial_matrix)
  reconstructed_matrix <- reconstructed_matrix + partial_matrix
}

print(covariance - reconstructed_matrix)
print(round(covariance - reconstructed_matrix, 9))


parent_data_ptransformed <- as.data.frame(as.matrix(parent_data) %*% decomposition$vectors)
parent_data_ptransformed

ggplot() +
  geom_point(data = parent_data_ptransformed, aes(x = V1, y = V2, color=parent_labels), size = 1, shape = 21) +
  scale_color_manual(values = color_mapping) +
  theme_bw()
ggsave("List 1/deentanlged_parent.png", width = 6, height = 4, units = "in")
