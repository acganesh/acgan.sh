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
\DeclareMathOperator{\Stab}{Stab}
\DeclareMathOperator{\Fix}{Fix}
\DeclareMathOperator{\Orb}{Orb}
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

We will first apply 's method without explaining how it works.  We first discuss *cycle notation.*

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

Similarly, we can use the multinomial theorem as before to find specific coefficients.  The key point here is that the number of cases to consider increase quickly, but there are only 3 different permutation structures that exist, making 's theory easy to apply.

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
- The example most relevant to this post: the *dihedral group,* $D_n$, the group of all symmetries (rotational and reflectional) of a regular $n$-sided polygon, with $2n$ elements.

There are two main cases to consider.  If $n$ is odd$, reflections are through a vertex and a midpoint of the opposite side.  When $n$ is even, reflections are through midpoints of opposite sides.

## Group action and Burnside's lemma

### Group action on sets

A group $(G, *)$ acts on the set $X$ if there is a function that takes pairs of elements in $G$ and elements in $X$, $(g, x)$ to new elements in $X$.  In our case, $X$ will be the set of objects *without accounting for symmetry.*

More formally, we say that a group $G(, *)$ acts on a set $X$ if there is a function $f: G \times X \to X$ such that when we denote $f(g, x)$ as $g(x)$, we have

- $(g_1 g_2)(x) = g_1(g_2(x))$ for all $g_1, g_2 \in G, x\in X$.
- $e(x) = x$ if $e$ is the identify of the group and $x \in X$.

## The orbit and stabilizer

If $G$ acts on a set $X$ and $x \in X$, then the stabilizer of $x$ is defined as the set

$$
\Stab x = \{ g \in G | g(x) = x \},
$$

that is, the set of elements in the group that take the element $x$ to itself.

Similarly, let $\Fix g$ denote the elements of $X$ fixed by $g$, that is the set $\{ x \in X | g(x) = x \}$.

The set of all outputs of an element $x \in X$ under group action is called the orbit, defined as the set

$$
\Orb x = \{ g(x) | g \in G \}.
$$

## The orbit-stabilizer theorem

If a finite group $G$ acts on a set $X$, for each $x \in X$, we have
$$
|G| = |\Stab x | | \Orb x|,
$$
where $|G|$ denotes the number of elements in the group.

*Intuition.* We don't formally prove this result, but provide some intuition with the example of a cube's symmetries.  First, recall that there are 24 rotational symmetries of a cube.  There are 8 places one vertex can go, and 3 places you can put one of its neighbors, yielding $8 \cdot 3 = 24$ symmetries.  Now,

- Fix one face.  You can move the cube 4 ways (you can only rotate it).  These are the stabilizers.
- There are 6 faces you can pick.  This is the orbit of the face.

Thus, $4 \cdot 6 = 24$, the order of the group of cube symmetries, as expected.

## Burnside's Lemma

If $G$ is a finite group that acts on the elements of a finite set $X$, and $N$ is the number of orbits of $X$ under $G$, then

$$
N = \frac{1}{|G|} \sum_{g \in G} | \Fix g |.
$$

The orbit of an element $x \in X$ refers to all possible colorings you can obtain by some rotation or reflection on some coloring.  If we count the *number of orbits,* $N$, we are counting the number of oclorings that are distinct under rotation or reflection, which solves our problem.

*Proof.* Consider the quantity $\sum_{g \in G} | \Fix g |$.  But this is also 
$$
|S| = \sum_{g \in G} | \Fix g | = \sum_{x \in X} | \Stab x|.
$$

Let $x_1, x_2, \dots, x_N$ be representive elements from each orbit of $X$ under $G$.  If an element $x$ is in the same orbit as $x_i$, then $\Orb x = \Orb x_i$, and by the orbit-stabilizer theorem, we have $|\Stab x| = |\Stab x_i|$.  Thus, we have

$$
\sum_{g \in G} |\Fix g| = \sum_{i=1}^{N} \sum_{x \in \Orb x_i} |\Stab x| = \sum_{i = 1}^{N} |\Orb x_i| |\Stab x_i|,
$$
which implies
$$
\sum_{g \in G} |\Fix g| = \sum_{i=1}^{N} |\Orb x_i| |\Stab x_i|.
$$
By the orbit-stabilizer theorem, each of the summands equals $|G|$.  And therefore,
$$
\sum_{g \in G} |\Fix g| = \sum_{i=1}^{N} |\Orb x_i| |\Stab x_i| = N \cdot |G|.
$$

Burnside lemmas follows from dividing out by $|G|$.

## Intuition: why does Pólya-Burnside enumeration work?

The key idea is that plugging in 1 into the generating function yields Burnside's Lemma.

Recall the generating functions from the previous examples.

*Problem 1.* (Number of different flag colorings).
$$
f(x, y) = \frac{(x+y)^4 + (x^2+y^2)^2}{2},
$$
where:

- $2^4$: number of elements fixed by the identity
- $2^2$: number of elements fixed by reflection across middle.
- $2$: order of dihedral group $D_2$.

*Problem 2.* Number of different bracelets:

$$
g(x, y, z) = \frac{7 (x+y+z)(x^2 + y^2 + z^2)^3 + 6 (x^7 + y^7 + z^7) + (x+y+z)^7}{14},
$$
where:

- $7 \cdot 3^4$: number of elements fixed by reflections
- $6 \cdot 3$: number of elements fixed by the six nonidentity rotations
- $3^7$: number of elements fixed by the identity.
- $14$: order of $D_7$.

The key point is that summing the coefficients gives you $N = \frac{1}{|G|} \sum_{g \in G} |\Fix g|$.

That is,
$$
f(1, 1) = \frac{2^4 + 2^2}{2}; \qquad g(1, 1) = \frac{7 \cdot 3^4 + 6 \cdot 3 + 3^7}{14}.
$$

## Intuition: why the generating function substitution works

Recall that an object that can be colored with $k$ colors has a symmetry as follows: a permutation with $p_1$ cycles of length 1, $p_2$ cycles of length 2, $\dots$, $p_n$ cycles of length $n$ contributes

$$
f_1^{p_1} f_2^{p_2} \dots f_n^{p_n},
$$
to the cycle index polynomial.  As before, if we have $k$ colors, we substitute $f_i = (c_1^i + c_2^i + \dots + c_k^i)$.

The key idea is that to count fixed elements, $|\Fix g|$, all entities in the respective cycles must be the same color.  

In the generating function $c_1^i c_2^j c_3^k$ represents $i, j, k$ instances of $c_1, c_2, c_3$ respectively.  To be the same, we can substitute $c_n^{p_n}$ for any color, since it doesn't matter what color we pick; thus, we substitute $f_i = c_1^i + c_2^i + \dots + c_k^i$.

## Additional problems

These additional problems were obtained from the Art of Problem Solving forum.

With the exception of #1, these are an assortment of problems in which it may not be immediately clear that Burnside's lemma can be applied.

1. Two of the squares of a $7 \times 7$ checkerboard are painted yellow, and the rest are painted green.  Two color schemes are equivalent if one can be obtained from the other by applying a rotation in the plane of the board.  How many inequivalent color schemes are possible? (AIME 1996, #7).
2. Find the number of second-degree polynomials $f(x)$ with integer coefficients and integer zeros for which $f(0) = 2010$. (AIME 2010, #10).
3. Two quadrilaterals are consider the same if one can be obtained from the other by a rotation and a translation.  How many different convex cyclic quadrilaterals are there with integer sides and perimeter equal to 32?  (AMC 12A 2010, #25).
4. How many subsets $\{ x, y, z, t, \} \subset \mathbb{N}$ are there that satisfy the following conditions?
$$
12 \leq x < y < z < t,
$$
$$
x+y+z+t = 2011.
$$
5. Prove that, for all positive integers $n$ and $k$, we have
$$
n | \sum_{i=0}^{n-1} k^{\gcd(i, n)},
$$
where $a|b$ means that $a$ divides $b$.



