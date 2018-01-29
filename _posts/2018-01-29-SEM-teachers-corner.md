---
layout: post
title: Contradictory Conclusions and Time-Intervals
---

Many authors writing about continuous-time modeling have been at pains to point out that the estimates of *cross-lagged* and *autoregressive* effects resulting from discrete-time VAR(1) models can differ greatly depending on the time-interval between observations (e.g. Gollob & Reichardt, 1987; Voelkle & Oud, 2013).  As such, if two researchers are studying the same phenomenon, but one uses an interval of 2 hours between measurements, and the other uses 4 hours, they **may** come to totally different substantive conclusions. However, what the literature has so far failed to address is, in what exact circumstance **will** different time-intervals lead to contradictory conclusions? This is the question Rebecca Kuiper and myself try to tackle in our [latest paper](https://ryanoisin.github.io/files/KuiperRyan_2018_DrawingConclusions_SEM.pdf), recently accepted to the teacher's corner section of *Structural Equation Modeling*.

In this paper we consider three common types of conclusions researchers are interested in making in designs with many repeated measurement waves, and which are typically based on the estimates of discrete-time VAR(1) models.

1. Is process A **more stable** than process B?
   Typically based on the comparison of two autoregressive parameters
2. Does process A have a **bigger effect** on process B, than process B has on process A?
   Typically based on comparing the absolute values of two cross-lagged parameters
3. Does process A have a **positive or negative** effect on process B?
   That is, the sign of the cross-lagged parameter

Assuming that the data-generating process is continuous-time, then these parameters will take on different values depending on the time-interval. Let's further focus on the case where researchers take equal time-intervals between measurements - if this isn't the case, then the parameter estimates will be a mixture of different true parameters anyway.

It turns out that there is only one very specific circumstance in which we are *guaranteed* not to make contradictory conclusions based on the choice of time interval; when there is a truly bivariate system (so also no unobserved third process!), which behaves in a stable, non-oscillating manner; the eigenvalues of the drift matrix are negative and real (and so the eigenvalues of the DT-VAR(1) model are real and between 0 and 1). Below we have taken an example of such a system and plotted how the lagged-effects matrix changes over different time intervals.

![Example 1](/images/Effects-lag-plot_Bivar.jpg =250x250 "Example 1")




