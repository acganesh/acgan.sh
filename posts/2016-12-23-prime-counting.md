---
layout: post
title: Efficient Prime Counting with the Meissel-Lehmer Algorithm 
date: 2019-08-25
---

# Efficient prime counting with the Meissel-Lehmer algorithm

Computing $\pi(x)$, the number of primes $p \leq x$ is a classic problem in algorithmic number theory.  The prime number theorem describes the asymptotic growth of this function, and states that

$$
\lim_{x \to \infty} \left. \pi(x) \middle/ \frac{x}{\ln x} \right. = 1.
$$

The theorem was independently conjectured by Legendre and Gauss, and proved by Hadamard and de la Vallée Poussin's around 100 years later in 1896.  The theorem can also be written as follows, which provides a refined numerical approximation:

$$
\pi(x) \approx \text{Li}(x) = \int_{2}^{x} \frac{dy}{\ln y},
$$

where $\text{Li}(x)$ denotes the logarithmic integral.


While robust numerical approximations are available, it is particularly tedious to calculate $\pi(x)$ exactly.  I was working on [Project Euler's Problem 543](https://projecteuler.net/problem=543), and found that an efficient solution requires a fast algorithm to compute $\pi(x)$.  I originally just generated the primes using a sieve and counted them, which is perhaps the most straightforward way to approach the problem.  To my surprise, I found that implementing the Meissel-Lehmer algorithm resulted in a ~120x speedup in runtime.

In this article, I will discuss the mathematical basis of the Meissel-Lehmer algorithm and provide an implementation in Python.

## Algorithm Overview

In the 1870s, the German astronomer Ernst Meissel discovered a combinatorial method to compute $\pi(x)$, which was extended and simplified by Derrick H. Lehmer in 1959<label class="margin-toggle sidenote-number"></label><span class="sidenote">
D. H. Lehmer, [“On the exact number of primes less than a given limit”](http://projecteuclid.org/euclid.ijm/1255455259), *Illinois Journal of Mathematics*, vol. 3, pp. 381–388, 1959.
</span>.



The Meissel-Lehmer algorithm allows us to compute $\pi(x)$ in $O\left (\frac{x}{(\ln x)^4} \right )$ time using $O\left (\frac{x^{1/3}}{\ln x} \right )$ space.  Let $p_1, p_2, \dots$ denote the prime numbers.  The algorithm allows us to compute $\pi(x)$ as follows: 


$$ \pi(x) = \left \lfloor x \right \rfloor - \sum_{i=1}^{a} \left \lfloor \frac{x}{p_i} \right \rfloor + \sum_{1 \leq i \leq j \leq a} \left \lfloor \frac{x}{p_i p_j} \right \rfloor - \cdots + $$

$$ \frac{(b+a-2)(b-a+1)}{2} - \sum_{a < i \leq b} \pi \left ( \frac{x}{p_i} \right ) - \sum_{i=a+1}^c \sum_{j=1}^{b_i} \left ( \pi \left ( \frac{x}{p_i p_j} \right ) - (j-1) \right ),$$

where

$$ a = \pi(x^{1/4}); \qquad b = \pi(x^{1/2}) $$

$$ b_i = \pi(\sqrt{x/p_i}); \qquad c = \pi(x^{1/3}) $$

Before diving into the mathematics, I will first discuss other simpler approaches to compute $\pi(x)$, due to Eratosthenes and Legendre.

## Sieve of Eratosthenes -- A Naive Algorithm

The simplest way to go about computing $\pi(x)$ is to just generate the primes and count them.  A well-known and ancient algorithm for doing so is the sieve due to the Greek mathematician Eratosthenes.  The algorithm works by filtering out multiples of each prime, which must be composite.  This algorithm has a time complexity of $O (x \log \log x)$ and generally requires $O(x)$ space.  

Here is a basic implementation in Python:

```python
def sieve(n):
    """
    Generate the primes less than or equal to n using the sieve of
    Eratosthenes.
    """
    primes, sieve = [], [True] * (n + 1)
    for p in range(2, n + 1):
        if sieve[p]:
            primes.append(p)
            for i in range(p * p, n + 1, p):
                sieve[i] = False
    return primes


def pi(x):
    """Calculates the number of primes less than or equal to x."""
    return len(sieve(x))
```

The [primesieve](https://github.com/kimwalisch/primesieve) software package provides an optimized C++ implementation of the Eratosthenes sieve.

[^1]: This is a consequence of the fact that the [prime harmonic series](http://mathworld.wolfram.com/HarmonicSeriesofPrimes.html) approaches $\log \log x$ asymptotically.  

## Legendre's Formula 

Legendre's formula to compute $\pi(x)$ is as follows:

$$ \pi(x) + 1 = \pi(\sqrt{x}) + \lfloor x \rfloor - \sum_{p_i \leq \sqrt{x}} \left \lfloor \frac{x}{p_i} \right \rfloor + \sum_{p_i < p_j \leq \sqrt{x}} \left \lfloor \frac{x}{p_i p_j} \right \rfloor - \sum_{p_i < p_j < p_k \leq \sqrt{x}} \left \lfloor \frac{x}{p_i p_j p_k} \right \rfloor + \dots.$$

It is an improvement over sieving, as it does not require the calculation of all of the primes $\leq x$.  Still, it is not very computationally efficient, as using it involves the calculation of approximately $\frac{6x(1-\log 2)}{\pi^2}$ terms <label class="margin-toggle sidenote-number"></label><span class="sidenote">
Lagarias, J. C., V. S. Miller, and A. M. Odlyzko. ["Computing $\pi(x)$: The Meissel-Lehmer Method."](http://www.ams.org/journals/mcom/1985-44-170/S0025-5718-1985-0777285-5/S0025-5718-1985-0777285-5.pdf) *Mathematics of Computation.* 44.170 (1985): 537. Web.
</span>.  It is nevertheless useful to examine, as it is similar to the Meissel-Lehmer algorithm we will discuss next.


This formula is a direct consequence of the [inclusion-exclusion principle](https://en.wikipedia.org/wiki/Inclusion%E2%80%93exclusion_principle).  It uses the observation that the number of primes in $[1, x]$ plus 1 (the quantity on the left of the equation) is equal to the number of integers minus the number of composite numbers in the interval.

Let's take a closer look.  Over the interval $[1, x]$, the quantity $\left \lfloor \frac{x}{p} \right \rfloor$ counts the integers divisible by $p.$  Noting that every composite number in the interval must have some prime factor $\leq \sqrt{x}$, we start by subtracting $\sum_{p_i \leq \sqrt{x}} \left \lfloor \frac{x}{p_i} \right \rfloor$ multipes of primes $\leq \sqrt{x}$ in the interval.  But this will subtract the multiples $1 \cdot p_i$, which are actually prime, so we must compensate by adding the term $\pi(\sqrt{x})$.

To account for the rest of the terms, observe that some of the composite numbers are divisible by two primes $\leq \sqrt{x}$, call them $p_i$ and $p_j$.  These numbers will be double counted as multiples of both $p_i$ and $p_j$.  Hence, we must adjust the total by adding the number of integers of this type, which is $\sum \left \lfloor \frac{x}{p_i p_j} \right \rfloor$.  But adding this term will now remove the count of integers that are divisible by three different primes, which explains the next term.  Continuing this reasoning, Legendre's result follows. 

## Meissel-Lehmer Algorithm

We will now turn to the main subject of the article, the Meissel-Lehmer algorithm.  For convenience, we will first introduce some notation.  Let $\phi(x, a)$ denote the *partial sieve function*, defined as the number of integers $\leq x$, with no prime factor less than or equal to $p_a$.  In set notation, we can expression this as

$$ 
\phi(x, a) =  \left \vert{\{ n \leq x: p \mid n \Rightarrow p > p_a \}} \right \vert.
$$

The name comes from the fact that $\phi(x, a)$ counts the numbers $\leq x$ that are not struck off when sieving with the first $a$ primes.  Note that this allows us to rewrite Legendre's formula as

$$ 
\pi(x) = \phi(x, a) + a - 1,
$$

where $a = \pi(\sqrt{x})$.


Now, let $P_k(x, a)$ denote the *$k$th partial sieve function*, which is defined as the number of integers $\leq x$ with exactly $k$ prime factors, with none less than or equal to $p_a$.  For convenience, we define $P_0(x, a) = 1$.  It then follows that

$$
\phi(x, a) = P_0(a, x) + P_1(x, a) + P_2(x, a) + \dots
$$

Note that the right hand side's sum will contain a finite number of nonzero terms.  Observing that

$$
P_1(x, a) = \pi(x) - a,
$$

it follows that if we can compute $\phi(x, a)$, $P_2(x, a)$, $P_3(x, a)$, and so on, we can obtain the value of $\pi(x)$.  We will now consider the two subproblems of computing $P_i(x, a)$ and $\phi(x, a)$.

### Computing $P_i(x, a)$

We will begin by considering $P_2(x, a)$, defined as the number of integers in the interval $[1, x]$ which are products of two primes $p_i, p_j > p_a$.  It follows that

$$
P_2(x, a) = \underbrace{\pi \left ( \frac{x}{p_{a+1}} \right ) - a}_{\text{number of integers } p_{a+1}p_j \leq x \text{ with } a+1 \leq j} + \underbrace{\pi \left ( \frac{x}{p_{a+2}} \right ) - (a+1)}_{\text{number of integers } p_{a+2} p_j \leq x \text{ with } a+2 \leq j} + \dots
$$

$$
= \sum_{p_a < p_i \leq \sqrt{x}} \left [ \pi \left ( \frac{x}{p_i} \right ) - (i - 1) \right ].
$$

Let $b = \pi(\sqrt{x})$.  If we choose $a < b$, the above sum is equivalent to

$$
P_2(x, a) = \sum_{i=a+1}^{b} \left [ \pi \left ( \frac{x}{p_i} \right ) - (i-1) \right ] = \sum_{i=a+1}^{b} \pi\left ( \frac{x}{p_i} \right ) - \frac{(b-a)(b+a-1)}{2},$$

where we have applied the arithmetic series formula.  In a similar fashion, we can compute $P_3(x, a)$ as follows:

$$
P_3(x, a) = P_2 \left ( \frac{x}{p_{a+1}}, a \right ) + P_2 \left ( \frac{x}{p_{a+2}}, a \right ) + \dots = \sum_{i > a} P_2 \left ( \frac{x}{p_i}, a \right ).
$$ 

Let $b_i = \pi \left ( \sqrt{\frac{x}{p_i}} \right )$, and let $c = \pi(x^{1/3})$.  Assuming that $a < c$ (so that $P_3$ is nonzero), it follows that:

$$
P_3(x, a) = \sum_{i=a+1}^{c} \sum_{j=1}^{b_i} \left [ \pi \left ( \frac{x}{p_i p_j} \right ) - (j-1) \right ].
$$

Finally, if we choose $a = \pi(x^{1/4})$, $P_i(x, a) = 0$ for $i > 3$.  Now, we need only compute $\phi(x, a)$ to obtain the Meissel-Lehmer formula in its full form. 

### Computing $\phi(x, a)$ 

The key to computing $\phi$ is the observation that 

$$
\phi(x, a) = \phi(x, a-1) - \phi \left ( \frac{x}{p_a}, a-1 \right ),
$$

which follows from the definition of $\phi$: the integers not divisible by any of the primes $p_1, \dots, p_a$ are exactly those integers which are not divisible by any of $p_1, p_2, \dots, p_{a-1}$, excluding those that are not divisible by $p_a$.  Repeatedly applying this identity will eventually lead to $\phi(x, 1)$, which is just the number of odd numbers $\leq x$. 

In the implementation below, $\phi$ is computed using a memoized recursive procedure.  It turns out that one can make this computation more efficient by applying a truncation rule during the recursive chain.  The details of how to do this are somewhat involved, but the interested reader can refer to [^2] and <label class="margin-toggle" "sidenote-number"></label> <span class="sidenote">Riesel, Hans.  [*Prime Numbers and Computer Methods for Factorization.*](http://www.amazon.com/Numbers-Computer-Factorization-Progress-Mathematics/dp/0817637435) Boston: Birkhäuser, 1985.</span>

```python
from bisect import bisect

def prime_sieve(n):
    """
    Efficient prime sieve, due to Robert William Hanks.
    Source: http://stackoverflow.com/a/2068548
    """
    sieve = [True] * (n/2)
    for i in xrange(3,int(n**0.5)+1,2):
        if sieve[i/2]:
            sieve[i*i/2::i] = [False] * ((n-i*i-1)/(2*i)+1)
    return [2] + [2*i+1 for i in xrange(1,n/2) if sieve[i]]

"""
Limit controls the number of primes that are sieved
to cache small values of pi(x).  Without caching,
runtime will be exponential.
When computing pi(x), limit should be
at least sqrt(x).  A higher value of limit
that caches more values can sometimes improve performance.
"""

limit = 10**6
primes = prime_sieve(limit)
print 'done with primes'

phi_cache = {}
def phi(x, a):
    """
    Implementation of the partial sieve function, which
    counts the number of integers <= x with no prime factor less
    than or equal to the ath prime.
    """
    # If value is cached, just return it
    if (x, a) in phi_cache: return phi_cache[(x, a)]

    # Base case: phi(x, a) is the number of odd integers <= x
    if a == 1: return (x + 1) / 2

    result = phi(x, a-1) - phi(x / primes[a-1], a-1)
    phi_cache[(x, a)] = result # Memoize
    return result


pi_cache = {}
def pi(x):
    """
    Computes pi(x), the number of primes <= x, using
    the Meissel-Lehmer algorithm.
    """
    # If value is cached, return it
    if x in pi_cache: return pi_cache[x]

    # If x < limit, calculate pi(x) using a bisection
    # algorithm over the sieved primes.
    if x < limit:
        result = bisect(primes, x)
        pi_cache[x] = result
        return result

    a = pi(int(x ** (1./4)))
    b = pi(int(x ** (1./2)))
    c = pi(int(x ** (1./3)))

    # This quantity must be integral,
    # so we can just use integer division.
    result = phi(x,a) + (b+a-2) * (b-a+1) / 2

    for i in xrange(a+1, b+1):
        w = x / primes[i-1]
        b_i = pi(w ** (1./2))
        result = result - pi(w)
        if i <= c:
            for j in xrange(i, b_i+1):
                result = result - pi(w / primes[j-1]) + j - 1
    pi_cache[x] = result
    return result

# Example
# result = pi(10**8)
#print result
```

## Further Reading

While the Meissel-Lehmer algorithm is quite fast for most practical purposes, there are algorithms that are known to be more efficient.  Based on the work on Meissel and Lehmer, in 1985 Lagarias, Miller and Odlyzko found an algorithm requiring $O( \frac{x^{2/3}}{\log x} )$ time and $O(x^{1/3} \log^2 x)$ space.  Lagarias and Odlyzko have also published a method describing how to compute $\pi(x)$ using an analytic approach.

In 1996, Deléglise and Rivat<label class="margin-toggle sidenote-number"></label><span class="sidenote">Deleglise, M., and J. Rivat. ["Computing $\pi(x)$: The Meissel, Lehmer, Lagarias, Miller, Odlyzko Method."](http://www.ams.org/journals/mcom/1996-65-213/S0025-5718-96-00674-6/S0025-5718-96-00674-6.pdf) *Mathematics of Computation.* 65.213 (1996): 235-46. Web.<br>Silva, T. ["Computing $\pi(x)$: the combinatorial method."](http://sweet.ua.pt/tos/bib/5.4.pdf) *Revista do Detua.* 4.6 (2006): 759.</span> refined the Lagarias-Miller-Odlyzko method allowing one to save a factor of $\log x$ in the time complexity, at the cost of an increase by a factor of $\log x \log \log x$ in space.  In 2001, Gourdon<label class="margin-toggle sidenote-number"></label><span class="sidenote">X. Gourdon, "Computation of $\pi(x)$: Improvements to the Meissel, Lehmer, Lagarias, Miller, Odlyzko, Deléglise and Rivat method."  Available from [numbers.computation.free.fr/Constants/Primes/Pix/piNalgorithm.ps](numbers.computation.free.fr/Constants/Primes/Pix/piNalgorithm.ps)</span> published refinements to the Deléglise-Rivat method that saves constant factors in time and space complexity.

Kim Walisch's excellent [`primecount`](https://github.com/kimwalisch/primecount) software package provides highly optimized C++ implementations of many of these algorithms, with support for OpenMP parallelization.  In September of 2015, this software was used to produce a [record-breaking computation of $\pi(10^{27})$](http://www.mersenneforum.org/showthread.php?t=20473), using 16-core EC2 r3.8xlarge instances and a 36-core Xeon server.  Using the Deléglise-Rivat method, the computation took 23.03 CPU core years, and the peak memory usage was 235 gigabytes!

### Acknowledgments

Thank you to Yuval Widgerson for providing feedback on this draft.
