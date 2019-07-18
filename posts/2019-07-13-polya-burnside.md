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

*2009 PUMaC Combinatorics A10.*  Taotao wants to buy a bracelet.  The bracelets have 7 different beads on them arranged in a circle.  Two bracelets are the same if one can be rotated or flipped to get the other.  If she can choose the colors and placements of the beads, and the beads come in orange, white, and black, how many possible bracelets can she buy?

*Solution.* Imagine the 7 beads at the vertices of a regular hexagon.  See Figure 1.

We will analyze the symmetries of the 7-gon.  We have 7 reflections through a vertex and a midpoint of the opposite side, and 7 rotations of $n (\frac{360}{7})^{\circ}$, with $n \in \{ 1, 2, \dots, 7 \}$.

*Permutation cycle structure: reflections.*

All the 7 reflections have the same cycle structure, by symmetry.  This corresponds to the permutation structure $(1)(7 2)(6 3)(5 4)$; see Figure 2.

In the cycle index polynomial, this corresponds to $7 f_1 f_2^3$, since we have one 1-cycle and three 2-cycle, and 7 such reflection, since we can take a reflection through any vertex.

*Permutation cycle structure: rotations.*

All the 6 nonidentity rotations are 7-cycles, since 7 in a prime number.  This contributes $ 6 \cdot f_7$ to the cycle index polynomial.

By contrast, consider the case where $n = 6$ is composite.  Int his case, a rotation of $(\frac{360}{3})^{\circ}$ yields $(1 3 5)(2 4 6)$, which would correspond to $f_3^2$ in the cycle index polynomial.

*The identity.* The identity is trivially a product of seven 1-cycles, so it contributes $1 \cdot f_1^7$ to the polynomial.

## Cycle index polynomials

The cycle index polynomial is thus
$$
\frac{7 \cdot f_1 f_2^3 + 6 \cdot f_7 + 1 \cdot f_1^7}{14}.
$$

Substituting $f_n = x^n + y^n + z^n$ (since we have three colors), the polynomial is
$$
f(x, y, z) = \frac{7 (x+y+z)(x^2 + y^2 + z^2)^3 + 6 (x^7 + y^7 + z^7) + (x+y+z)^7}{14}.
$$

The sum of the coefficients gives us the desired count.  Plugging in 1, we find that
$$
f(1, 1, 1) = \frac{7 \cdot 3^4 + 6 \cdot 3 + 3^7}{14} = 198.
$$

## Calculating the number of necklackes of a subtype

Let's say we wanted to find the number of necklaces with 2 red beads, 2 orange beads, and 3 yellow beads: this is the coefficient of $x^2 y^2 z^3$.

Recalling that
$$
f(x, y, z) = \frac{7 (x+y+z)(x^2 + y^2 + z^2)^3 + 6 (x^7 + y^7 + z^7) + (x+y+z)^7}{14},
$$

we can obtain the required coefficient without expanding this out.  From the first term, $7 \cdot (x+y+z)(x^2+y^2+z^2)^3$, we note that we must take a factor of $z$ from $(x+y+z)$, and then factors of $x^2, y^2, z^2$ from the $(x^2 + y^2+z^2)$ terms, in any possible ordering.

There are $3! = 6$ to pick the ordering of $x^2, y^2, z^2$, so the number of terms from here $7 \cdot 3! = 42$.

In the middle term, $6(x^7 + y^7 + z^7)$, we will not obtain any terms of the required form.

In the last term, $(x + y + z)^7$, we can just apply the multinomial theorem to find that the coefficient is $\binom{72}{2, 3} = \frac{7!}{2! 2! 3!} = 210$.

Thus the coefficient we want is
$$
\frac{7 \cdot 3! + \binom{7}{2,2,3}}{14} = 18,
$$

implying that there are 18 necklaces with 2 red beads, 2 orange beads, and 3 yellow beads.

Now, notably, if we expand the generating function, we obtain a symmetric polynomial.  This is because the mapping of the colors to the variables $x,y,z$ doesn't matter.

(...)

## Computational utility

Just like we did in problem 1, it is certainly possible to use casework to solve this counting problem.  But we see the efficiency of this when we increase the number of beads or colors even modestly.

Suppose we have a necklace with 17 beads and 4 colors.  Then the cycle index polynomial is

$$
P = \frac{f_1^{17} + 16 f_{17} + 17 f_1 f_2^8}{34}.
$$

Substituting, we obtain
$$
P = \frac{(w+x+y+z)^{17} + 16 (w^{17} + x^{17} + y^{17} + z^{17}) + 17(w+x+y+z)(w^2 + x^2 + y^2 + z^2)^8}{34},
$$

so that
$$
P(1,1,1,1) = 5054421344.
$$

Similarly, we can use the multinomial theorem as before to find specific coefficients.  The key point here is that the number of cases to consider increase quickly, but there are only 3 different permutation structures that exist, making Polya's theory easy to apply.

## Introduction to group theory

To explain why this process works, we will briefly introduce group theory.  There are several applications of this area of mathematics, a few of which are listed below:

- Matrix groups to study the symmetries of 3-D solids, various problems in physics, and crystallographic groups.

- Extension fields for geometric constructions, including showing that duplicating the cube, trisecting an angle, and squaring a circle is impossible.

(In fact, we can show that if $n$ is a positive integer such that the regular $n$-gon is constructible with rule and compass, then $n = 2^k \prod_{i=1}^{k} p_i$, where $k \geq 0$ and the $p_i$ are distinct Fermat primes, that is, primes of the form $2^{2^m} +1$.

- Combinatorial enumeration via group action on sets and Burnside's lemma (the subject of this post).

### The definition of a group

We note that a group $(G, *)$ contains a set $G$ of elements and a binary operation $*$.  Importantly,

- $*$ is closed on $G$.  That is, if $g, h \in G$, then $g * h \in G$.

- $*$ is associative.  If $a, b, c \in G$, then $a * (b * c) = (a * b) * c$.

- There exists a unique identity element $e \in G$ such that for all $g \in G$, we have $g * e = e*g = g$.

- For all $g \in G$, there exists an inverse, denoted $g^{-1}$ such that $g * g^{-1} = g^{-1} * g = e$.
  
There are many examples of groups, including:

- $(\mathbb{C}, +), (\mathbb{R}, +), (\mathbb{Q}, +), (\mathbb{Z}, +)$.

- The set of symmetries of a rectangle, the Klein 4-group.

- The group of all permutations on three elements, $S_3$.

- The example most relevant to this post: the *dihedral group,* $D_n$, the group of all symmetries (rotational and reflectional) of a regular $n$-side polygon, with $2n$ elements.

There are two main cases to consider.  If $n$ is odd$, reflections are through a vertex and a midpoint of the opposite side.  When $n$ is even, reflections are through midpoints of opposite sides.

## Group action and Burnside's lemma

### Group action on sets





