---
title: "Reinforcement Learning and Optimal Control"
author: [Pierre-Luc Bacon]
date: "2017-02-20"
subject: "Reinforcement learning, optimal control"
keywords: [reinforcement learning, optimal control]
subtitle: "IFT6760C, Fall 2021"
lang: "en"
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]
---

# Stochastic Optimization

General problem of the form: 

\begin{align*}
\text{minimize}\enspace J(\theta) = \mathbb{E}_{X \sim P_{\mathcolor{cyan}{\theta}}}\left[ h(X, \mathcolor{magenta}{\theta}) \right] \enspace .
\end{align*}

This is an unconstrained optimization problem, which we want to solve by gradient descent. 

The dependency on $\theta$ can be: 

1. Distributional if $X \sim P_\theta$
2. Structural if $\theta$ appears inside the expectation
3. Structural and distributional (as in the above)

# Structural Dependency

Let $X\sim P$ and the distribution of $X$ doesn't depend on $\theta$, we have:
\begin{align*}
D J(\theta) = \mathbb{E}_{X \sim P}\left[ D_2 h(X, \theta) \right] \enspace ,
\end{align*}
where $D_2$ denotes the partial derivative of $h$ with respect to the argument $\theta$. 

We then get a derivative estimator, call it $\hat{D} J(\theta)$ by taking a sample average over $N$ samples $\{x_1, \hdots, x_N\}$: 
\begin{align*}
\hat{D} J(\theta) \triangleq \frac{1}{N} \sum_{i=1}^N D_2 h(x_i, \theta) \enspace .
\end{align*}

# 

:::warning

The fact that we can push the derivative inside the expectation relies on the fact that we can interchange the order of integration and differentiation. We rely on Leibniz integral rule
for that. 

Generally speaking, you want to make sure that the **derivative exists at all points** and that all the values are **bounded** inside the expectation.

:::

# Empirical Risk Minimization


Let $\theta$ denote the parameters of a predictive model (hypothesis) $f$, we define the *risk* $R$ as:
\begin{align*}
R(\theta) \triangleq \mathbb{E}_{X, Y \sim P}\left[ L(f(X; \theta), Y) \right] \enspace .
\end{align*}
Vapnik's Empirical Risk Minimization Principle (ERM) says that instead we ought to work with the *empirical risk*: 
\begin{align*}
\hat{R}(\theta) \triangleq \frac{1}{N} \sum_{i=1}^N L(f(x_i; \theta), y_i) \enspace .
\end{align*}
where $\{(x_1, y_1), \hdots, (x_N, y_N)\}$ is a dataset of input-output pairs drawn from the joint over $X$ and $Y$.

- Changing $\theta$ won't affect the distribution of examples in the world: the dependency is structural only

# ERM and Stochastic Counterpart

$\hat{R}(\theta)$ is an *empirical* loss, and because the depency is structural: 
\begin{align*}
D \hat{R}(\theta) = \hat{D} R(\theta) \enspace .
\end{align*}
The notation above is subtle, but highlights an important point: the hat symbol is first over $R$, then over $D$. On the left-hand-side, we are taking the exact derivative of an approximate loss; the right-hand-side, the approximate derivative of an exact loss.

The ERM can be viewed as an instance of Rubinstein's (1968) *Stochastic Counterpart*. 

# Sample Average Approximation (SAA)

In the SAA (or stochastic counterpart), the idea is to transform a stochastic optimization problem into a deterministic one via the Monte Carlo method: ie. to approximate the objective by a sample average estimate.

- This is in contrast to Stochastic Approximation, in which we spend very little time approximating the objective

# SAA and SA

Let's highlight the dependency on the number of samples used in the two kinds of estimates: 

1. Derivative estimation: $\hat{D}^{(N)} J(\theta) \triangleq \frac{1}{N}\sum_{i=1}^N D_2 h(x_i, \theta)$ 
2. Objective estimation: $D \hat{J}^{(N)}(\theta) = \frac{1}{N} \sum_{i=1}^N D_2 h(x_i, \theta)$. 

The SAA approach for unconstrained optimization by gradient descent is of the form: 
\begin{align*}
\theta^{(k+1)} = \theta^{(k)} - \eta D \hat{J}^{(N)}(\theta^{(k)}) \enspace ,
\end{align*}

whereas the SA counterpart is: 
\begin{align*}
\theta^{(k+1)} = \theta^{(k)} - \eta D \hat{J}^{(1)}(\theta^{(k)}) = \theta^{(k)} - \eta \hat{D}^{(1)} J(\theta^{(k)}) \enspace .
\end{align*}

# Distributional Dependency

\begin{align*}
J(\theta) = \mathbb{E}_{X \sim P_\theta}\left[ h(X, \theta)\right]
\end{align*}

Assuming that we can change the order of differentiation and integration: 
\begin{align*}
D J(\theta) &= \int \left(D_2 h(x, \theta) P(x;\theta) + h(x,\theta) D_2 P(x;\theta) \right)dx \\
&= \mathbb{E}_{X \sim P_\theta}\left[ D_2 h(X, \theta) \right] + \int  h(x,\theta) D_2 P(x;\theta)dx \enspace .
\end{align*}

There is nothing wrong with the above expression. But we are now facing a computational challenge. How to deal with the second term? 

# Change of measure 

Let $\rho(x,\theta,q) \triangleq p(x;\theta)/q(x)$, then: 

\begin{align*}
J(\theta) = \mathbb{E}_{X \sim p_\theta}\left[ h(X, \theta) \right] = \mathbb{E}_{X \sim q}\left[ h(X, \theta)\rho(X, \theta, q)\right] \enspace .
\end{align*}

The derivative of $J$ becomes:
\begin{align*}
D J(\theta) = \mathbb{E}_{X \sim q}\left[ D_2 h(X, \theta) \rho(X,\theta, q) + h(X, \theta) D_2 \rho(X, \theta, q) \right] \enspace .
\end{align*}

# Likelihood ratio (LR) estimator

The LR estimator is given by: 
\begin{align*}
\hat{D}^{\text{LR}} J(\theta) \triangleq \frac{1}{N} \sum_{i=1}^N D_2 h(x_i, \theta) \rho(x_i,\theta, q) + h(x_i, \theta) D_2 \rho(x_i, \theta, q) \enspace .
\end{align*}
Note that the same dataset $\{x_1, \hdots, x_N\}$ can be used throughout optimization. That is: 
\begin{align*}
\theta^{(k+1)} = \theta^{(k)} - \eta \hat{D}^{\text{LR}} J(\theta^{(k)})  \enspace .
\end{align*}

and the only thing that changes is where we evaluate our derivative.

# LR as SAA 

From the SAA perspective, LR amounts to using the following ``surrogate'' objective: 
\begin{align*}
\hat{J}^\text{LR}(\theta) \triangleq \frac{1}{N} \sum_{i=1}^N h(x_i, \theta) \rho(x_i, \theta, q)
\end{align*}
and form the sequence:
\begin{align*}
\theta^{(k+1)} = \theta^{(k)} - \eta D \hat{J}^\text{LR}(\theta^{(k)})  \enspace .
\end{align*}

Once again, the dataset $\{x_1, \hdots, x_N\}$ gets ``bound'' inside the function $\hat{J}^\text{LR}$, and we can evaluate the surrogate objective everywhere.

# Score Function Estimator

The score function is obtained for the choice $q = p_\theta$. We then get: 
\begin{align*}
D J(\theta) = \mathbb{E}_{X \sim p_\theta}\left[ D_2 h(X, \theta) \rho(X,\theta, p_\theta) + h(X, \theta) D_2 \rho(X, \theta, p_\theta) \right] \enspace .
\end{align*}