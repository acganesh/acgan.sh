---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: Pólya-Burnside enumeration in combinatorics
---

(in progress)

$$
\newcommand{\mat}[1]{\begin{pmatrix}#1\end{pmatrix}}
$$

# Pólya-Burnside enumeration in combinatorics

## A class of problems

The following problem in chemistry is historically significant, as G. Pólya originally popularized his theory through applications in chemical enumeration.  How many different chemical compounds can be made by attaching $H$, $CH_3$, or $OH$ radicals to each of the carbon atoms in the benzene ring pictured below?

Here are other problems that can be approached using Pólya-Burnside.

- In how many ways can an $n \times n$ tablecloth be colored with $k$ colors?

- How many different necklaces can be made with $n$ beads and $k$ colors?

- How many ways can the faces of a polyhedrons be colored using at most $n$ colors?

- Find the number of simple graphs with $n$ vertices, up to isomorphism.

These problems share a common theme of enumerating the number of objects with some equivalence under *symmetry.*

## An example: coloring a flag

*Problem.* How many ways are there to color a flag with $n$ stripes lined side by side with $k$ colors? 

(IMAGE)

Do not count as different flags with colors "flipped."  The following two flags would be considered the same.

### Solving it with standard methods.

Let's take the simple case when $n = 4$ and $k = 2$.

Assume we count the number of patterns normally, without accounting for reflection.  Then $N = 2^4$.  Let $N_r$ denote the number of distinct colorings under reflection.  $N_r \neq \frac{2^4}{2}$, as one might think!  We need to separately handle symmetric patterns and asymmetric patterns.

An asymmetric pattern like (...) yields a new pattern that we don't want to double count, (...), when it is reflected.  To count these, we must divide by 2.

A symmetric pattern like (...) when reflected does not create a new pattern.  We don't need to divide by 2 here.

Let $A$ denote the number of asymmetric patterns not accounting for reflection, and $S$ be the number of symmetric patterns.  First, note that $A + S = 2^4$.

Now, the number of patterns accounting for reflection, $N_r$ is given by

$$
N_r = \frac{A}{2} + S = \frac{2^4 - S}{2} + S.
$$

Now, $S = 2^2$, since picking the first two squares uniquely defines the last two.  Thus $N_r = \frac{2^4 - 2^2}{2} + 2^2 = 10$.

*Exercise.* Show that in the general case, $N_r = \frac{k^n + k^{\lfloor (n+1)/2 \rfloor}}{2}$.

# Applying Pólya's theory

We will first apply Polya's method without explaining how it works.  We first discuss *cycle notation.*

Any permutation can be expressed as the product of cycles.  For instance,

$$
\mat{1 & 2 & 3 & 4 & 5 \\ 5 & 1 & 4 & 3 & 2} = \mat{1 & 5 & 2}\mat{3 & 4}.
$$

Denote the flag patterning as a 4-letter string of colors *abcd.*

There are two symmetries:

- The identity permutation that maps $abcd \to abcd$, specifically $(a)(b)(c)(d)$.

- The reflection permutation that maps $abcd \to dcba$, that is $\mat{a & b & c & d \\ d & c & b & a}$, or the cycle product $\mat{a & d}\mat{b & c}$.

We say that a cycle of length $n$ is an $n$-cycle.  The first symmetry is a product of four 1-cycles, and the second is the product of two 2-cycles 

## Cycle index polynomial

We can compute the cycle index polynomial as follows:

$$
P = \frac{1 \cdot f_1^4 + 1 \cdot f_2^2}{2}.
$$

We make the substitution $f_n = x^n + y^n$, and use two terms since we are considering two colors.  Then $P$ becomes

$$
P(x, y) = \frac{(x+y)^4 + (x^2 + y^2)^2}{2}.
$$

To find the answer from before, we add the coefficients of this polynomial.  This is equivalent to taking $P(1, 1)$, which gives $\frac{2^4 + 2^2}{2} = 10$, as from before.  Importantly, not only is the sumal equal, but the constituents of the sum are similar as well: this is a hint at some sort of combinatorial equivalence between the two processes. 

## $P$ is a generating function for colorings

Remarkably, $P$ is a generating function for each coloring.  Expanding, we obtain

$$
P = x^4 + 2x^3 y + 4x^2 y^2 + 2x y^3 + y^4.
$$

Here, the coefficient of $x^j y^k$ gives the number of patterns with $j$ squares of color 1 and $k$ squares of color 2.

(table)

## Counting necklaces: PuMAC 2009

*2009 PUMaC Combinatorics A10.*

