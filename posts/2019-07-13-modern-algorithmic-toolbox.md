
---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: The modern algorithmic toolbox
---

$$
\newcommand{\mbf}{\mathbf}
\newcommand{\RR}{\mathbb{R}}
\newcommand{\CC}{\mathbb{C}}
\newcommand{\la}{\langle}
\newcommand{\ra}{\rangle}
\DeclareMathOperator{\rank}{rank}
$$

# The modern algorithmic toolbox

These notes are based on an influential course I took at Stanford, [CS168: The Modern Algorithmic Toolbox](https://web.stanford.edu/class/cs168/index.html), taught by [Greg Valiant](https://theory.stanford.edu/~valiant/) in Spring 2018.

I found it to be my favorite technical class at Stanford, as I think it's a versatile grab-bag of ideas that can be applied to many different domains.

## Modern hashing

*Motivating problem.* Suppose you are a student at Stanford on a shared network, and that you send a request to `amazon.com`.  The network has a shared cache that is spread over $n = 100$ machines.  Where should you look for a cached copy of the Web page?

This doesn't seem too hard.  A first pass might be to apply a standard hash function $h(x)$ (e.g., Rivest's [MD5](https://en.wikipedia.org/wiki/MD5)), and compute
$$
h(x) \pmod{n}.
$$

But this system breaks down if the number $N$ of caches is not static, but changes all the time.  $N$ might increase if the network administrator purchases additional infracture, or it might decrease if a cache disconnects from the network.  Unfortunately, $h(x) \pmod{n}$ and $h(x) \pmod{n+1}$ will in general be very different.

The standard solution to this problem is known as *consistent hashing*.

- Visualize a large array indexed by all possible hash values.
- In addition to hashing the names of all objects (URLs) $x$, also hash the names of all the cache servers $s$.
- Given an object $x$ that hashes to the bucket $h(x)$, we scan buckets to the right of $h(x)$ until we find a bucket $h(s)$.
- Designate $s$ as the cache responsible for the object $x$.

Importantly, assuming that our hash function is well-behaved, the expected load on each of the $n$ cache servers is exactly $\frac{1}{n}$ of the number of the objects.

To implement the `Lookup` and `Insert` operations for this setup, we use a balanced binary search tree (e.g. a red-black tree), since the `Successor` operation is fast.  Finding the cache responsable for storing a given object $x$ will then take $O(\log n)$ time.

This implementation was first described in Karger et al. 1997, STOC.  While consistent hashing is widely in use today, this paper was initially rejected because a reviewer felt that there were no practical applications for this technique.

## Data and distance

Suppose you have a large dataset and want to identify similar items quickly.  This is an important problem in many domains, such as clustering (find subregions of a dataset that are "similar" by some metric), and classification (if two datapoints are similar, they may have the same label).

We start by defining a few different notions of similarity.

*Jaccard similarity.* A simple approach is to use the Jaccard similarity between two sets, which is defined as

$$
J(S, T) = \frac{|S \cap T|}{|S \cup T|}
$$

This metric is useful for sparse data.  For instance, we might represent documents in terms of multisets of words they contain; in this setting the Jaccard similarity is often a good measure.

*$\ell_p$ distance.  Given datapoints in $\mathbb{R}^d$, the Euclidean $(\ell_2)$ distance metric is defined as 

$$
||x - y||_{2} = \sqrt{\sum_{i=1}^{d} (x(i) - y(i))^2}.
$$

More generally, we can define the $\ell_p$ distance as

$$
||x - y||_{p} = \left ( \sum_{i=1}^{d} | x(i) - y(i) |^{p} \right )^{1/p}.
$$

If $p = 1$ we obtain the "Manhattan" distance, and for large $p$, $||x - y||_p$ grows more dependent on the coordinate with maximal difference.  The $l_{\infty}$ distance is defined as $\max_i | x(i) - y(i) |$.

*Johnson-Lindenstrauss transform.* Suppose now, that we want to reduce the dimensionality of a large dataset, where we want to approximately preserve the distances between object pairs (for example, the $\ell_2$ distance between points in $\RR^k$).

Suppose that our $n$ points of interest are $\mbf{x}_1, \dots, \mbf{x}_k \in \mathbb{R}^k$, where $k$ might be large.  Suppose we choose a random vector $\mbf{r} \in \RR^k$, and define a real-valued function $f_{\mbf{r}} : \mathbb{R}^k \to \mathbb{R}$ by taking an inner product for the datapoint with the random vector: 

$$
f_{\mbf{r}} (\mbf{x}) = \langle \mbf{x}, \mbf{r} \rangle = \sum_{j=1}^{k} x_j r_j.
$$

If we want to use this idea to approximately preserve Euclidean distances between points, the key question is how we pick the $r_j$'s.

One idea is to pick $d$ vectors $\mbf{r}_1, \dots, \mbf{r}_d$, where each component of each vector is drawn i.i.d. from a standard Gaussian.

Then in expectation, the random variable $(f_\mbf{r}(\mbf{x}) - f_{\mbf{r}}(\mbf{y}))^2$ is an unbiased estimate of the $\ell_2$ distance between $\mbf{x}$ and $\mbf{y}$.

The Johnson-Lindenstrauss transform (JL transform) for domain and range dimensions $k$ and $d$, is defined using a matrix $\mbf{A} \in \mathbb{R}^{d \times k}$ where we define a mapping 

$$
\mbf{x} \mapsto \frac{1}{\sqrt{d}} \mbf{A x}.
$$

For a fixed pair of vectors $\mbf{x, y} \in \mathbb{R}^k$, we have
\begin{align*}
  ||f_{\mbf{A}}(\mbf{x}) - f_{\mbf{A}}(\mbf{y})||_2^2 &= || \frac{1}{\sqrt{d}} \mbf{Ax} - \frac{1}{\sqrt{d}} \mbf{Ay} ||_{2}^{2} \\
  &= \frac{1}{d} || \mbf{A(x-y)}||_2^2 \\
  &= \frac{1}{d} \sum_{i=1}^{d} (a_i^T(\mbf{x} - \mbf{y}))^2,
\end{align*}

where $a_i^T$ denotes the $i$-th row of $\mbf{A}$.  Since each row $a_i^T$ is a $k$-vector with entries chosen i.i.d. from a standard Guassian, each term
$$
  (a_i^T (\mbf{x} - \mbf{y}))^2 = \left( \sum_{j=1}^{k} a_{ij} (x_j - y_j) \right)^2 
$$
is an unbiased estimator of $||\mbf{x} - \mbf{y}||_2^2$.

## Generalization and regularization

There are many forms of generalization, e.g. $L_2, L_1$, dropout.  An important theorem is the following:

If the number of data points $n$ satisfies $n > \frac{1}{\epsilon} \left ( \log h + \log \frac{1}{\delta} \right )$.

*Theorem (Uniform Convergence)*.  Assume that
$$
n \geq \frac{c}{\varepsilon^2} \left( d + \ln \frac{1}{\delta} \right),
$$

where $c$ is a sufficiently large constant.  Then with probability at least $1 - \delta$ over the samples $\mbf{x}_1, \dots, \mbf{x}_n \sim D$, for every linear classifier $\hat{f}$, we have
\begin{align*}
  \text{generalization error of } \hat{f} \in \text{training error of } \hat{f} \pm \varepsilon.
\end{align*}

*Proposition.* Given $n$ independent Gaussian vectors $x_1, \dots, x_n \in \mathbb{R}^d$, and consider labels $y_i = \la a, x_i \ra$ for some vector $a$ with $||a||_0 = s$.  Then the minimizer of the $\ell_1$ regularized objective function will be the vector $a$, with high probability, provided that $n > c \cdot s \log d$, for some absolute constant $c$.

## Linear-algebraic techniques

Principal component analysis projects the dataset onto the eigenvectors of the covariance matrix.  In other words, the principal components are the $k$ orthonormal vectors $\mbf{v}_1, \dots, \mbf{v}_k$ that maximize the objective function
$$
  \frac{1}{n} \sum_{i=1}^{n} \sum_{j=1}^{k} \la \mbf{x}_i, \mbf{v}_j \ra^2.
$$

A singular value decomposition (SVD) of an $m \times n$ matrix $\mbf{A}$ expresses the matrix as the product of three "simple" matrices:

$$
\mbf{A} = \mbf{U S V^{T}},
$$

where:

- $\mbf{U}$ is an $m \times m$ orthogonal matrix.
- $\mbf{V}$ is an $n \times n$ orthogonal matrix.
- $\mbf{S}$ is an $m \times n$ diagonal matrix with nonnegative entries, and with the diagonal entries sorted from high to low.

In other terms, the factorization $\mbf{A} = \mbf{U S V^T}$ is equivalent to the expression

$$
\mbf{A} = \sum_{i=1}^{\min\{ m, n \}} s_i \cdot \mbf{u}_i \mbf{v}_i^T,
$$
where $s_i$ is the $i$th singular value and $\mbf{u}_i, \mbf{v}_i$ are the corresponding left and right singular vectors.  Importantly, every matrix $\mbf{A}$ has an SVD.  Intuitively, this means that every matrix $\mbf{A}$, no matter how strange, is only:

- Performing a rotation in the domain (multiplication by $\mbf{V}^T$)
- Followed by scaling plus adding or deleting dimensions (multiplication by $\mbf{S}$)
- Followed by a rotation in the range (multiplication by $\mbf{U}$).

## Tensors and low-rank tensor recovery

*Definition.* A $n_1 \times n_2 \times \dots \times n_k$ $k$-tensor is a set of $n_1 \cdot n_2 \cdots n_k$ numbers, which one interprets as being arranged in a $k$-dimensional hypercube.  Given such a $k$-tensor, $A$, we can refer to a specific element via $A_{i_1, i_2, \dots, i_k}$.

We can define the rank of a tensor analogously to the rank of a matrix.  Recall that a matrix $M$ has rank $r$ if it can be written as $M = UV^T$, where $U$ has $r$ columns and $V$ has $r$ columns.  Let $u_1, \dots, u_r$ and $v_1, \dots, v_r$ denote these columns, note that
$$
M = \sum_{i=1}^{r} u_i v_i^T.
$$
That is, $M$ is the sum of $r$ rank one matrices, where the $i$th matrix is the *outer product* $u_i v_i^T$.  We can define an outer product for tensors:

*Definition.* Given vectors $u, v, w$ or lengths $n, m,$ and $l$, respectively, their *tensor product* (or *outer product*) is the $n \times m \times l$ rank one 3-tensor dented $A = u \otimes v \otimes w$ with entries $A_{i, j, k} = u_i v_j w_k$.

We can extend this definition to higher dimensions:

*Definition.* Given vectors $v_1, \dots, v_k$ of lengths $n_1, n_2, \dots, n_k$, the *tensor product* denoted $v_1 \otimes v_2 \dots \otimes v_k$ is the $n_1 \times n_2 \times \dots \times n_k$ $k$-tensor $A$ with entry $A_{i_1, i_2, \dots, i_k} = v_1(i_1) \cdot v_2(i_2) \cdots v_k(i_k)$.

This allows us to define the rank of a tensor, which we state for 3-tensors.

*Definition.* A 3-tensor $A$ has rank $r$ if there exists 3 sets of $r$ vectors, $u_1, \dots, u_r$, $v_1, \dots, v_r$ and $w_1, \dots, w_r$ such that

$$
A = \sum_{i=1}^{r} u_i \otimes v_i \otimes w_i.
$$

Interestingly, most ideas from linear algebra for matrices do not apply to $k$-tensors for $k \geq 3$.  Here are some important differences between tensors and matrices.

- Computing the rank of matrices is easy (e.g. use the singular-value decomposition).  Computing the rank of 3-tensors is NP-hard.
- The rank $1$ approximation of a matrix $M$ is the same as the best rank 1 approximation of the matrix $M_2$ defined as the best rank 2 approximation of $M$.  This means that the best rank-$k$ approximation can be found by iteratively finding the best rank-1 approximation, and then subtracting it off.

For $k$-tensors with $k \geq 3$, this is not always true.  If $u \times v \times w$ is the best rank 1 approximation of 3-tensor $A$, then it is possible that $\rank(A - u \times v \times w) > \rank (A)$.

- For real-valued matrices, we have that the rank over $\RR$ and the rank over $\CC$ is the same, that is $\rank_{\mathbb{R}} (M) = \rank_{\mathbb{C}} (M)$.  For real-valued $k$-tensors, it is possible that the rank over complex vectors is smaller than the rank over real vectors.

Surprisingly, low-rank decompositions for tensors are essentially unique (which is not true for matrices):

*Theorem.* Given a 3-tensor $A$ of rank $k$, suppose there exists three sets of linearly independent vectors, $(u_1, \dots, u_k), (v_1, \dots, v_k), (w_1, \dots, w_k)$ such that

$$
A = \sum_{i=1}^{k} u_i \times v_i \times w_i.
$$

Then this rank $k$ decomposition is unique (up to scalar multiplication of the vectors), and these factors can be efficiently recovered, using Jenrich's algorithm.


## Spectral graph theory

Given a graph $G = (V, E)$ with $|V| = n$ vertices, we can define the Laplacian matrix as an $n \times n$ matrix $L_G =D - A$, where $D$ is the degree matrix and $A$ is the adjacency matrix.  The eigenvalues of $L_G$ inform the structure of the graph.  We can show the following important result:

**Theorem.** The number of zero eigenvalues of the Laplacian $L_G$ equals the number of connected components of the graph $G$.

Small eigenvalues correspond to unit vectors $v$ that try to minimize the quantity $v^T L v = \frac{1}{2} \sum_{(i, j) \in E} (v(i) - v(j)$. A natural way to visualize a graph is to embedd a graph onto the eigenvectors corresponding to small eigenvalues.

**Definition.** The *isoperimetric ratio* of a set $S$, denoted $\theta(S)$, is defined as

$$
\theta(S) = \frac{|\delta(S)|}{\min(|S|, |V \setminus S|)}.
$$

The following theorem shows the importance of the second eigenvalue of a graph's Laplacian.

**Theorem.** Given any graph $G = (V, E)$ and any set $S \subset V$, the isoperimetric number of the graph satisfies

$$
\theta_G \geq \lambda_2 \left ( 1 - \frac{|S|}{|V|} \right ).
$$

For more on machine learning on graphs, see Matthew Das Sarma's [article in *The Gradient*](https://thegradient.pub/structure-learning/).

## Sampling and estimation

We discuss *reservoir sampling,* originally due to Vitter in 1985.  Given a number $k$, and a datastream $x_1, x_2, \dots, $ of length greater than $k$:

- Put the first $k$ elements of the stream into a "reservoir" $R = (x_1, \dots, x_k)$.
- For $i \geq k+1$:
  - With probability $\frac{k}{i}$ replace a random entry of $R$ with $x_i$.
- At the end of the stream, return the resource $R$.

Importantly, the reservoir $R$ consists of a uniformly random subset of $k$ of the entries of $x_1, x_2, \dots, x_t$.

## The Fourier perspective

Recall that the Fourier transform of a function $f$ is defined as follows:

$$
\hat{f}(s) = \int_{-\infty}^{\infty} e^{- 2 \pi i s t} f(t) \, dt.
$$

This allows us to transition between the time domain and the frequency domain.

Let $\mathcal{F}$ denote the Fourier transform operator. The *convolution theorem* states that 

$$
\mathcal{F} \{ f * g \} = \mathcal{F} \{ f \} \cdot \mathcal{F} \{ g \}.
$$

## Sparse vector / matrix recovery

Often, we can reconstruct sparse signals with a few linear measurements.

**Theorem.** Fix a signal length $n$ and a sparsity level $k$.  Let $\mbf{A}$ be an $m \times n$ matrix with $m = \Theta (k \log \frac{n}{k} )$ rows, with each of its $mn$ entries chosen independently from the standard Gaussian distribution.  With high probability over the choice of $\mbf{A}$, every $k$-sparse signal $\mbf{z}$ can be efficiently recovered from $\mbf{b} = \mbf{Az}$.

## Privacy-preserving computation

It's possible to define randomized algorithms that are privacy preserving.  The key concept is that of *differential privacy*.  Intuitively, an algorithm is differentially private if an observer seeing its output cannot tell whether a particular individual's information was used in the computation.

**Definition.** A randomized algorithm $\mathcal{M}$ with domain $\mathbb{N}^{|\mathcal{X}|}$ is $(\epsilon, \delta)$-differentially private if for all $\mathcal{S} \subseteq \text{Range}(\mathcal{M})$ and for all $x, y \in \mathbb{N}^{|\mathcal{X}|}$ such that $||x - y ||_1 \leq 1$, we have

$$
\text{Pr}[\mathcal{M}(x) \in \mathcal{S} ] \leq \exp (\epsilon) \Pr [ \mathcal{M}(y) \in \mathcal{S} ] + \delta,
$$

where the probability space is over the coin flips of the mechanism $\mathcal{M}$.


## References

- STOC paper
- W. B. Johnson and J. Lindenstrauss.
- Vitter
- FT book
- Gradient article
- Compressed sensing (Tao, Candes)
