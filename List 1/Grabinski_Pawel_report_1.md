# Report 1 by Paweł Grabiński
## Vector and Matrix Algebra, Multivariate Normal Distribution


## Exercises
### Exercise 1
Consider the matrix
$$A = \begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}$$

#### 1. Is $A$ symmetric?
For a matrix to be symmetric, it must be equal to its transpose.
$$A^T = \begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}$$
Thus, $A=A^T$ and $A$ is symmetric.

#### 2. and 3. Perform the spectral decomposition of $A$.
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
As these equations are equivalent, we can choose $v_{11}=2^{-\frac{1}{2}}$ and $v_{12}=-2^{-\frac{1}{2}}$ for normalization purpose. Thus, the eigenvector corresponding to $\lambda_1=4$ is $\mathbf{v}_1 = \begin{bmatrix} 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} \end{bmatrix}$.

For $\lambda_2=2$:
$$\begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}\begin{bmatrix} v_{21} \\ v_{22} \end{bmatrix} = \begin{bmatrix} 3v_{21} - v_{22}\\ -v_{21} + 3v_{22} \end{bmatrix} = 2\begin{bmatrix} v_{21} \\ v_{22} \end{bmatrix}$$
We get the following equations:
$$3v_{21} - v_{22} = 2v_{21}\\-v_{21} + 3 v_{22} =2v_{22}$$
Simplifying, we get:
$$v_{21} = v_{22}\\ v_{21}=v_{22}$$
Analogically, for normalization we pick $v_{21}=2^{-\frac{1}{2}}$ and $v_{22}=2^{-\frac{1}{2}}$. Thus, the eigenvector corresponding to $\lambda_2=2$ is $\mathbf{v}_2 = \begin{bmatrix} 2^{-\frac{1}{2}} \\ 2^{-\frac{1}{2}} \end{bmatrix}$.

The spectral decomposition of $A$ is:
$$\lambda_1v_1v_1^T+\lambda_2v_2v_2^T=4\begin{bmatrix} 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} \end{bmatrix}\begin{bmatrix} 2^{-\frac{1}{2}} & -2^{-\frac{1}{2}} \end{bmatrix} + 2\begin{bmatrix} 2^{-\frac{1}{2}} \\ 2^{-\frac{1}{2}} \end{bmatrix}\begin{bmatrix} 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix}\\
=4\begin{bmatrix} 2^{-1} & -2^{-1} \\ -2^{-1} & 2^{-1} \end{bmatrix} + 2 \begin{bmatrix} 2^{-1} & 2^{-1} \\ 2^{-1} & 2^{-1}\end{bmatrix}\\
=\begin{bmatrix} 2 & -2 \\ -2 & 2 \end{bmatrix} +  \begin{bmatrix} 1 & 1 \\ 1 & 1\end{bmatrix}=\begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}=A$$

#### 4. Use the spectral decomposition of A given above and find $\sqrt{A}$. Check that the matrix you found satisfies: $\sqrt{A}\sqrt{A}=A$.

To find $\sqrt{A}$, we can use the diagonal decomposition of $A$:
$$A = \left[v_1, v_2\right] \begin{bmatrix} \lambda_1 & 0 \\ 0 & \lambda_2 \end{bmatrix} \left[v_1, v_2\right]^{-1}$$
The square root of $A$ will be:
$$\sqrt{A} = \left[v_1, v_2\right] \begin{bmatrix} \sqrt{\lambda_1} & 0 \\ 0 & \sqrt{\lambda_2} \end{bmatrix} \left[v_1, v_2\right]^{-1}$$
In our case it is:
$$\sqrt{A} = \begin{bmatrix} 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix} \begin{bmatrix} 2 & 0 \\ 0 & \sqrt{2} \end{bmatrix} \begin{bmatrix} 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix}^{-1}\\
=\begin{bmatrix} 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix} \begin{bmatrix} 2 & 0 \\ 0 & \sqrt{2} \end{bmatrix} \begin{bmatrix} 2^{-\frac{1}{2}} & -2^{-\frac{1}{2}} \\ 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix}\\
=\begin{bmatrix} 2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \\ -2^{-\frac{1}{2}} & 2^{-\frac{1}{2}} \end{bmatrix}  \begin{bmatrix} 2^{\frac{1}{2}} & -2^{\frac{1}{2}} \\ 1 & 1 \end{bmatrix}\\
=\begin{bmatrix} 1+2^{-\frac{1}{2}} & -1 + 2^{-\frac{1}{2}} \\ -1+2^{-\frac{1}{2}} & 1 + 2^{-\frac{1}{2}} \end{bmatrix}$$

We can check if $\sqrt{A}\sqrt{A}=A$:
$$\sqrt{A}\sqrt{A} = \begin{bmatrix} 1+2^{-\frac{1}{2}} & -1 + 2^{-\frac{1}{2}} \\ -1+2^{-\frac{1}{2}} & 1 + 2^{-\frac{1}{2}} \end{bmatrix}\begin{bmatrix} 1+2^{-\frac{1}{2}} & -1 + 2^{-\frac{1}{2}} \\ -1+2^{-\frac{1}{2}} & 1 + 2^{-\frac{1}{2}} \end{bmatrix}\\
=\begin{bmatrix} (1+2^{-\frac{1}{2}})^2 + (-1+2^{-\frac{1}{2}})^2 & 2(-1 + 2^{-\frac{1}{2}})(1+2^{-\frac{1}{2}}) \\ 2(-1 + 2^{-\frac{1}{2}})(1+2^{-\frac{1}{2}}) & (-1+2^{-\frac{1}{2}})^2 + (1+2^{-\frac{1}{2}})^2 \end{bmatrix}\\
=\begin{bmatrix} 1+2\cdot 2^{-\frac{1}{2}} + 2^{-1} + 1 - 2\cdot 2^{-\frac{1}{2}} + 2^{-1} & 2(2^{-1}-1) \\ 2(2^{-1}-1) & 1+2\cdot 2^{-\frac{1}{2}} + 2^{-1} + 1 - 2\cdot 2^{-\frac{1}{2}} + 2^{-1} \end{bmatrix}\\
=\begin{bmatrix} 3 & -1 \\ -1 & 3 \end{bmatrix}=A$$

### Exercsise 2

Consider the spectral decomposition of a positive definite matrix as given in
Lecture 1:
$$A = P\Lambda P^T.$$
The columns of $P$ are made of eigenvectors $e_i$, $i = 1, . . . , n$ and they are orthonormalized, i.e. their lengths are one and they are orthogonal (peripendicular) one to another. The diagonal matrix $\Lambda$ has the corresponding (positive) eigenvalues on the diagonal. Provide argument for the following