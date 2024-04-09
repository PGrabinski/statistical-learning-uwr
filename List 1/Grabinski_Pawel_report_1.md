# Report 1 by Paweł Grabiński
## Vector and Matrix Algebra, Multivariate Normal Distribution


## Exercises
### Exercise 1
Consider the matrix
$$A = \begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}$$

#### Is $A$ symmetric?
For a matrix to be symmetric, it must be equal to its transpose.
$$A^T = \begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}$$
Thus, $A=A^T$ and $A$ is symmetric.

#### Perform the spectral decomposition of $A$.
To obtain the spectral decomposition we have to find the eigenvalues and eigenvectors of $A$. To do so, we have to solve the following equation:
$$\det(A-\lambda I) = 0$$
In this case:
$$\det\begin{bmatrix} 3-\lambda & -1 \\ -1 & 3-\lambda \end{bmatrix} = 0$$
That is:
$$\det\begin{bmatrix} 3-\lambda & -1 \\ -1 & 3-\lambda \end{bmatrix} =(3-\lambda)^2 - 1 = 8 - 6\lambda + \lambda^2=(\lambda-4)(\lambda-2)=0$$
The eigenvalues are $\lambda_1=4$ and $\lambda_2=2$. To find the eigenvectors, we have to solve the following equations:
$$A\mathbf{v}_i = \lambda_i\mathbf{v}_i$$
For $\lambda_1=4$:
$$\begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}\begin{bmatrix} v_{11} \\ v_{12} \end{bmatrix} = \begin{bmatrix} 3v_{11} - v_{12}\\ -v_{11} + 3v_{12} \end{bmatrix} = 4\begin{bmatrix} v_{11} \\ v_{12} \end{bmatrix}$$
We get the following equations:
$$3v_{11} - v_{12} = 4v_{11}\\-v_{11} + 3 v_{12} =4v_{12}$$
That gets us:
$$v_{11} = -v_{12}\\ -v_{11}=v_{12}$$
As these equations are equivalent, we can choose $v_{11}=1$ and $v_{12}=-1$ for simplicity. Thus, the eigenvector corresponding to $\lambda_1=4$ is $\mathbf{v}_1 = \begin{bmatrix} 1 \\ -1 \end{bmatrix}$.

For $\lambda_2=2$:
$$\begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}\begin{bmatrix} v_{21} \\ v_{22} \end{bmatrix} = \begin{bmatrix} 3v_{21} - v_{22}\\ -v_{21} + 3v_{22} \end{bmatrix} = 2\begin{bmatrix} v_{21} \\ v_{22} \end{bmatrix}$$
We get the following equations:
$$3v_{21} - v_{22} = 2v_{21}\\-v_{21} + 3 v_{22} =2v_{22}$$
Simplifying, we get:
$$v_{21} = v_{22}\\ v_{21}=v_{22}$$
Analogically, for simplicity we pick $v_{21}=1$ and $v_{22}=1$. Thus, the eigenvector corresponding to $\lambda_2=2$ is $\mathbf{v}_2 = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$.
$$A=4\begin{bmatrix} 1 \\ -1 \end{bmatrix}\begin{bmatrix} 1 & -1 \end{bmatrix} + 2\begin{bmatrix} 1 \\ 1 \end{bmatrix}\begin{bmatrix} 1 & 1 \end{bmatrix}=4\begin{bmatrix} 1 & -1 \\ -1 & 1 \end{bmatrix} + 2 $$