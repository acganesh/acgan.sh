---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: The mathematics of music
---

Notes based on David Benson's *Music: A Mathematical Offering."

*Why do rhythms and melodies, which are composed of
sound, resemble the feelings, while this is not the case for
tastes, colours or smells? Can it be because they are motions,
as actions are also motions? Energy itself belongs to
feeling and creates feeling. But tastes and colours do not
act in the same way.*

(Aristotle)

## Equal temperament

In equal temperament, a half-step is the same as a frequency ratio of $\sqrt[12]{2}$.  They key idea is that $\log_2 3 \approx \frac{19}{12}$ is a good rational approximation.

## Fourier theory

If $f(t)$ is a real or complex valued function of a real variable $t$, then its Fourier transform $F(s)$ is defined as

$$
F(s) = \int_{- \infty}^{\infty} f(t) e^{- 2 \pi i s t} dt.
$$

The energy density at a particular value of $s$ is defined to be the square of the amplitude $|F(s)|$.

We can express a periodic function $f(x)$ with period $2L$ as
$$
  f(x) = \frac{a_0}{2} + \sum_{n=1}^{\infty} a_n \cos \left( \frac{n \pi x}{L} \right) + b_n \sin \left( \frac{n \pi x}{L} \right).
$$
We can compute the coefficients as ...


## Systems of tuning

*Pythagorean tuning.* In this setting, the interval between a perfect fifth is $3:2$.

*Just intonation.* Just intonation refers to any tuning system that uses small, whole numbered ratios between the frequencies in a scale.


## Nyquist's theorem

Nyquist's theorem states that the maximum frequency that can be represented when digitizing an analogue signal is exactly half the sampling rate.

## Burnside's lemma for enumeration of $T_n$

See pp. 330 of Benson.



