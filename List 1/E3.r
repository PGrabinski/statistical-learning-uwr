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