---
layout: post
title: Contradictory Conclusions and Time-Intervals
description: Meta-Science, experience sampling data, unequal lags, Structural Equation Modeling (SEM), dynamic models, Continuous-Time
---

In what exact circumstances will the use of a different time-interval in data collection lead to totally different substantive conclusions in a cross-lagged design? This is the question Rebecca Kuiper and myself try to tackle in our [latest paper](https://ryanoisin.github.io/files/KuiperRyan_2018_DrawingConclusions_SEM.pdf), recently accepted to the teacher's corner section of *Structural Equation Modeling*.

Many authors writing about continuous-time modeling have been at pains to point out that the estimates of *cross-lagged* and *autoregressive* effects resulting from discrete-time VAR(1) models **can** differ greatly depending on the time-interval between observations (e.g. Gollob & Reichardt, 1987; Voelkle & Oud, 2013).  As such, if two researchers are studying the same phenomenon, but one uses , for example, an interval of 2 hours between measurements, and the other uses say 4 hours, they **may** come to totally different substantive conclusions. However, the literature is so far lacking an accessible account of **when** this problem rears it's head? Rebecca and me set out to make this issue clearer; in fact we show that it is only in very specific circumstances that this is guaranteed not to occur.

# Types of conclusions
In this paper we consider three common types of conclusions researchers are interested in making in designs with many repeated measurement waves, and which are typically based on the estimates of discrete-time VAR(1) models.[^1]

1. Is process A **more stable** than process B?
   Typically based on the comparison of two autoregressive parameters
2. Does process A have a **bigger effect** on process B, than process B has on process A?
   Typically based on comparing the absolute values of two cross-lagged parameters
3. Does process A have a **positive or negative** effect on process B?
   That is, the sign of the cross-lagged parameter

Assuming that the data-generating process is a continuous-time VAR(1) model, then these parameters will take on different values depending on the time-interval. Let's further focus on the case where researchers take equal time-intervals between measurements - if this isn't the case, then the parameter estimates will be a mixture of different true parameters anyway.

# When do contradictions (not) occur?

It turns out that there is only one very specific circumstance in which we are guaranteed **not** to make contradictory conclusions based on the choice of time interval; when there is a truly bivariate system (so also no unobserved third process!), which behaves in a stable, non-oscillating manner; the eigenvalues of the drift matrix are negative and real (and so the eigenvalues of the DT-VAR(1) model are real and between 0 and 1)[^2]. Below we have taken an example of such a system and plotted how the lagged-effects matrix changes over different time intervals.

![Stable Non-Oscillating Bivariate Example](/images/Effects-lag-plot_Bivar.jpg "Non-Oscillating Bivariate Example")
 

## Contradictions: The general case
In general however, contradictions can occur in all other (multivariate) cases. For example, if we have three variables, but still a stable, non-oscillating (real eigenvalues only) system, all three conclusions can differ at different choices of time interval.

![Stable Non-Oscillating Trivariate Example](/images/Example-TrivaReal.jpg "Non-Oscillating Trivariate Example")

Furthermore, if we have a bivariate system which is oscillating (with complex eigenvalues for the drift matrix), we can also come to contradictory conclusions using different time-intervals. 

![Stable Oscillating Bivariate Example](/images/Example-BivarComplex.jpg "Oscillating Bivariate Example")

Here, different conclusions are made based on the *period* of the process. In the figure above, the system has a period of 2: thus, no contradictory conclusions are made for different time intervals between 0 and 2, **or** between 2 and 4; however the conclusions made based on a time-interval between 0 and 2 differ markedly from those made given a time interval between 2 and 4. More details on periodic-equivalence is given in the full paper.

# Final Remarks

In the full paper we provide a didactical walkthrough on the issue of time-interval dependency of parameter estimates, more technical proofs regarding this issue in appendices for those interested, and a number of tools by which researchers can transform estimated effects matrices to make easier comparisons. 

We have shown that the problem of time-interval dependent effect estimates cannot be dismissed in general: in fact, it is only in very special circumstances that we can be sure that we are not making possibly misleading conclusions based on the (often somewhat arbitrary) choice of time-intervals. The extent to which, in psychology, we are ever observing a truly bivariate system is highly questionable; indeed in recent times much of the focus of psychology research has shifted towards highly multi-variate systems, as evidenced by the (dynamic) network approach. In such contexts it seems that continuous-time modelling is even more desirable - the more dimensions the system has, the greater the risk that we would make entirely different conclusions about specific effects given a different interval of measurement. 

## References

Gollob, H. F., & Reichardt, C. S. (1987). Taking account of time lags in causal models.
*Child development, 58* (1), 80-92. doi: 10.2307/1130293

Kuiper, R.M., & Ryan, O. (accepted)  Drawing Conclusions from Cross-Lagged Relationships: Re-considering the role of the time-interval. *Structural Equation Modeling*.[[PDF]](https://ryanoisin.github.io/files/KuiperRyan_2018_DrawingConclusions_SEM.pdf)

Voelkle, M. C., & Oud, J. H. L. (2013). Continuous time modelling with individually
varying time intervals for oscillating and non-oscillating processes. *British Journal of
Mathematical and Statistical Psychology, 66* , 103-126.

## Footnotes

[^1]: Throughout we frame conclusions based on the true parameters; that is, we do not take into account uncertainty or formal hypotheses tests (e.g., is the parameter significantly different from zero)? This is to show that misleading conclusions may be made even in **ideal** circumstances - that is, when we can estimate the discrete-time model parameters with a very high precision.

[^2]: For a more detailed description of eigenvalues and how they relate to the *behaviour* of systems,  I recommend reading our book chapter which discusses CT models and ESM data, [pre-print available here](https://ryanoisin.github.io/files/RyanKuiperHamaker_2018_chapter_preprint.pdf).




