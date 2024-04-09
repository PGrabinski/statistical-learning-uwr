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
plot(parent_data["Weight"], parent_data["Length"])
dev.off()