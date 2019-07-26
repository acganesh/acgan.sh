---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: The sensitivity conjecture
---

The induced subgraph problem:

For every integer $n \geq 1$, let $H$ be an arbitrary $(2^{n-1} + 1)$-vertex induced subgraph of $Q^n$.  Then
$$
\Delta(H) \geq \sqrt{n}.
$$
This inequality is tight when $n$ is a perfect square.

Outline of the proof: uses Cauchy's interlace theorem. 

Let $A$ be a symmetric $n \times n$ matrix, and $B$ be a $m \times m$ principal submatrix of $A$, for some $m < n$.  If the eigenvalues of $A$ are $\lambda_1, \lambda_2, \dots, \lambda_n$, and the eigenvalues of $B$ are $\mu_1 \geq \mu_2 \geq \dots \geq \mu_m$, then for all $1 \leq i \leq m$, we have
$$
\lambda_i \geq \mu_i \geq \lambda_{i+n-m}.
$$

**Lemma.** Define a sequence of symmetric square matrices iteratively as follows:

$$
A_1 = \mat{0 & 1 \\ 1 & 0}, A_n = \mat{A_{n-1} & I \\ I & - A_{n-1}}.
$$
Then $A_n$ is a $2^n \times 2^n$ matrix whose eigenvalues are $\sqrt{n}$ of multiplicity $2^{n-1}$ and $- \sqrt{n}$ of multiplicity $2^{n-1}$.

Relate the eigenvectors of $A_n$ to $\Delta(H)$, and you are done.

Key questions:

- Why hasn't this proof been found before?  The ratio of difficulty of generative vs. discriminative models.
- What related work is there?
- What other theory does this imply?  esp. given that this is a stronger version of the sensitivity conjecture.
