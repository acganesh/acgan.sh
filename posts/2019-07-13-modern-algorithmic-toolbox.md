
---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: The modern algorithmic toolbox
---

# The modern algorithmic toolbox

These notes are based on an influential course I took at Stanford, [CS168: The Modern Algorithmic Toolbox](https://web.stanford.edu/class/cs168/index.html), taught by [Greg Valiant](https://theory.stanford.edu/~valiant/) in Spring 2018.

I found it to be my favorite class at Stanford, as I think it's a versatile grab-bag of ideas that can be applied to many different domains.

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
f_{\mbf{r}} (\mbf{x}) = \langle \mbf{x}, \mbf{r} \rangel = \sum_{j=1}^{k} x_j r_j.
$$

If we want to use this idea to approximately preserve Euclidean distances between points, the key question is how we pick the $r_j$'s.

One idea is to pick $d$ vectors $\mbf{r}_1, \dots, \mbf{r}_d$, where each component of each vector is drawn i.i.d. from a standard Gaussian.

Then in expectation, the random variable $(f_\mbf{r}(\mbf{x}) - f_{\mbf{r}}(\mbf{y}))^2$ is an unbiased estimate of the $\ell_2$ distance between $\mbf{x}$ and $\mbf{y}$.

The Johnson-Lindenstrauss transform (JL transform) for domain and range dimensions $k$ and $d$, is defined using a matrix $\mbf{A} \in \mathbb{R}^{d \times k}$ where we define a mapping 

$$
\mbf{x} \mapsto \frac{1}{\sqrt{d}} \mbf{A x}.
$$

For a fixed pair of vectors $\mbf{x, y} \in \mathbb{R}^k$, we have
$$
  ||f_{\mbf{A}}(\mbf{x}) - f_{\mbf{A}}(\mbf{y})||_2^2 &= || \frac{1}{\sqrt{d}} \mbf{Ax} - \frac{1}{\sqrt{d}} \mbf{Ay} ||_{2}^{2} \\
  &= \frac{1}{d} || \mbf{A(x-y)}||_2^2 \\
  &= \frac{1}{d} \sum_{i=1}^{d} (a_i^T(\mbf{x} - \mbf{y}))^2,
$$
where $a_i^T$ denotes the $i$-th row of $\mbf{A}$.  Since each row $a_i^T$ is a $k$-vector with entries chosen i.i.d. from a standard Guassian, each term
$$
  (a_i^T (\mbf{x} - \mbf{y}))^2 = \left( \sum_{j=1}^{k} a_{ij} (x_j - y_j) \right)^2 
$$
is an unbiased estimator of $||\mbf{x} - \mbf{y}||_2^2$.

## Generalization and regularization

There are many forms of generalization, e.g. $L_2, L_1, dropout$.  An important theorem is the following:

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

## Spectral graph theory

Given a graph $G = (V, E)$ with $|V| = n$ vertices, we can define the Laplacian matrix as an $n \times n$ matrix $L_G =D - A4, where $D$ is the degree matrix and $A$ is the adjacency matrix.

## Sampling and estimation

- Reservoir sampling

## The Fourier perspective

Recall that the Fourier transform of a function $f$ is defined as follows:

$$
\hat{f} = \int_{-\infty}^{\infty} f(x) \exp( - 2 \pi i x \xi) \, dx.
$$

This allows us to transition between the time domain and the frequency domain.

## Sparse vector / matrix recovery

(compressed sensing, Candes, Tao)

## Privacy-preserving computation

(differential privacy)

## References

- STOC paper

- W. B. Johnson and J. Lindenstrauss.

