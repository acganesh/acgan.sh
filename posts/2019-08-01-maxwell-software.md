---
author:
- '[Adithya C. Ganesh]{.smallcaps}'
bibliography:
- 'refs.bib'
nocite: '[@*]'
title: The axioms of software
---

We can define a Lisp interpreter in just 7 primitive operators:

- `(quote x)`
- `(atom x)`
- `(eq x y)`
- `(car x)`
- `(cdr x)`
- `(cons x y)`
- `(cond (p1 e1) ... (pn en))`

Next, we define a notation for functions: a function is expressed as (lambda (p1 ... pn) e), where p1...pn are atoms and e is an expression.

This is all we need to define `eval`!  This is pretty striking (see Sussman's article); expand on this.

- Source: Roots of Lisp

