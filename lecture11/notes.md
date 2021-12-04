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

# Recap

Over the last few lectures, we studied TD(0) with linear function approximation under the stochastic approximation framework. 
We saw that TD(0):
\begin{align*}
w^{(t+1)} = w^{(t)} + \eta_t \left(r_t + \gamma \phi_{t+1}^\top w^{(t)} - \phi^\top_t w^{(t)} \right)\phi_t\enspace .
\end{align*}

can be seen as an form root-finding stochastic approximation:
\begin{align*}
x^{(t+1)} = x^{(t)} + \eta_t \left( \bar{c} - y_t\right)\enspace ,
\end{align*}
corresponding to the root-finding problem: 
\begin{align*}
\bar{c} - f(x) = 0 \enspace ,
\end{align*}
in which we have only noisy observations of $f(x)$.


# Recap: Mean iterates

We then analyzed TD(0) using the ODE method and found that the mean iterates can be written as:

\begin{align*}
\bar{w}^{(k+1)} &=  \bar{w}^{(k)} + \eta_k \mathbb{E}\left[  \left(R_t + \phi_t^\top \bar{w}^{(k)} - \gamma \phi_{t+1}^\top \bar{w}^{(k)}\right) \phi_t \right]\\
&=\bar{w}^{(k)} + \eta_k \left(\Phi^\top X r_d - \Phi^\top X \left(I - \gamma P_d\right) \Phi \bar{w}^{(k)} \right) \enspace .
\end{align*}
This lead us to study the corresponding linear ODE:
\begin{align*}
\dot{w}(t) = \Phi^\top X r_d - \Phi^\top X \left(I - \gamma P_d\right) \Phi w(t)\enspace .
\end{align*}

# Recap: Asymptotic stability for linear ODEs

Consider an ODE of the form:
\begin{align*}
\dot{x}(t) = Ax(t) \enspace . 
\end{align*}

An equilibrium solution in this case is asymptotically stable if the real part of the **eigenvalues** of $A$ are **negative**.

Another equivalent characterization (used by Sutton in the analysis of TD), is that for some positive definite matrix $M$: 
\begin{align*}
A^\top M + M A \enspace ,
\end{align*}
is negative definite. 

# Recap: Operator-theoretic viewpoint

Instead of going through the above route, we showed instead that the mean iterates coincide with that of a **projected** operator. That is, we have shown that $w^\star$ is the unique fixed point of the composed operator $T L_d$, ie:

\begin{align*}
\Phi w^\star = T L_d (\Phi w^\star) \triangleq T \left( r_d + \gamma P_d \Phi w^\star \right) \enspace ,
\end{align*}

where $T$ computes the projection of $L_d \Phi w$ for any $w$ onto the representable subspace.

# Recap: Convergence

The main ingredient of our analysis was to establish what I call the "on-policy inequality", the fact that \begin{align*}
\|Pz\|_x \leq \|z\|_x, \enspace \forall z \in \mathbb{R}^n
\end{align*}

if $x$ is the stationary distribution of the Markov chain under $P$. 

# Error bound

We can show (prop 6.3.1) that the error can be bounded by: 

\begin{align*}
\|\underbrace{v_d}_{\mathclap{\text{true value function}}} - \Phi \overbrace{w^\star}^{\mathclap{\text{TD(0) solution}}}\|_x \leq \frac{1}{\sqrt{1 - \gamma^2}} \|v_d - \underbrace{T v_d}_{\mathclap{\text{projection of the true value function}}} \|_x \enspace .
\end{align*}


# Reducing the bias

We can control the bias using a variant of TD called TD($\lambda$). The idea is to use a multi-step policy evaluation operator: 
\begin{align*}
L^{(\lambda)}_d \triangleq (1 - \lambda) \sum_{k=0}^\infty \lambda^k L_d^{k+1} \enspace ,
\end{align*} 
with $\lambda \in [0, 1]$. Note that $L_d^k$ denotes the $k$-application of the *single*-step operator $L_d$, ie: $L^1 = L, L^2 = L L, ...$.
We can then consider the fixed-point problem $L^{(\lambda)}_d v = v$ where:
\begin{align*}
L^{(\lambda)}_d v &= r^{(\lambda)}_d + \gamma P^{(\lambda)}_d v\\
r^{(\lambda)}_d &\triangleq \sum_{k=0}^\infty  \left( \gamma \lambda P_d \right)^{k} r_d = (I - \gamma \lambda P_d)^{-1} r_d \\
P^{(\lambda)}_d &\triangleq (1 - \lambda) \sum_{k=0}^\infty \left(\gamma\lambda \right)^k P^{k+1} = (I - \gamma \lambda P_d)^{-1} (1 - \lambda )P_d 
\end{align*}

# Matrix splitting interpretation

Let $M^{(\lambda)}_d \triangleq I - \gamma \lambda P_d$ and $N^{(\lambda)}_d \triangleq \gamma (1 - \lambda) P_d$, we have that: 
\begin{align*}
I - \gamma P_d = M^{(\lambda)}_d - N^{(\lambda)}_d \enspace .
\end{align*}

The pair $M^{(\lambda)}_d, N^{(\lambda)}_d$ is said to be a *matrix splitting* (Varga, 1961) of $I - \gamma P_d$. Therefore: 
\begin{align*}
L^{(\lambda)}_d v &= r^{(\lambda)}_d + \gamma P^{(\lambda)} v \\
&= \left(M^{(\lambda)}_d\right)^{-1}\left(r_d + N^{(\lambda)}_d v\right) \enspace .
\end{align*}

# Two extremes

If $\lambda = 0$, we get the usual single-step policy evaluation operator: 
\begin{align*}
L^{(0)} v =L_d v=  r_d + \gamma P_d v\enspace .
\end{align*}
If $\lambda = 1$, we solve for the value of $d^\infty$ in one application of $L_d^{(1)}$: 
\begin{align*}
L^{(1)} v = (I - \gamma P_d)^{-1} r_d = v_d\enspace .
\end{align*}
Matrix splitting methods are **consistent**, ie:
\begin{align*}
v &= M^{-1} r_d + M^{-1} N v \\
\Leftrightarrow (I - M^{-1}N)v &= M^{-1} r_d\\
\Leftrightarrow (M - N) &= r_d \enspace .
\end{align*}
(I dropped the sub/superscripts for clarity)

# Combination with function approximation

Compositing the projection operator $T$ with $L_d^{(\lambda)}$ gives us a linear system of equations of the form: 
\begin{align*}
\Phi^\top X \left( I - \gamma P^{(\lambda)}_d\right) \Phi w = \Phi^\top X r^{(\lambda)}_d \enspace .
\end{align*}

In this case, we get an error bound of the form: 
\begin{align*}
\| v_d - \Phi w^\star \|_x \leq \frac{1}{\sqrt{1 - \beta^2}} \|v_d - T v_d \|_x \enspace .
\end{align*}
where the only thing that has now changed is the coefficient: 
\begin{align*}
\beta = \frac{\gamma(1 - \lambda)}{1 - \gamma \lambda} \enspace .
\end{align*}

# Geometry

Consequence: the contraction factor decreases with $\lambda$ increasing and the error/bias decreases.

With $\lambda = 1$, we get the best achievable error: ie. the projection of $v_d$ onto the representable subspace.

(Picture to be drawn on the board)

# Stochastic approximation counterpart 

What we talked about so-far can be thought as the linear ODE corresponding to the the SA counterpart that we call TD($\lambda$), whose iterates are of the form: 
\begin{align*}
w^{(t+1)} &=w^{(t)} + \eta_t z_t \delta_t \\
\delta_t &= r_t + \gamma \phi_{t+1} w_t - \phi_t w_t \\
z_t &= \sum_{k=0}^t (\gamma \lambda)^{t-k} \phi_k \enspace ,
\end{align*}
or equivalently $z_t = \gamma \lambda z_{t-1} + \phi_t$ \enspace .

# Fitted Value Methods

Remember that when writting: 
\begin{align*}
\Phi w = T L_d \Phi w \enspace ,
\end{align*}
$T$ can be conceptualized as an optimization procedure which solves an $L_2$ minimization problem.
For example, imagine that we're at the $k$ iterate with $v^{(k)} = \Phi w^{(k)}$, $T$ is the operator which returns the unique minimizer $v^{(k+1)}$ of:
\begin{align*}
\text{minimize} \enspace J(v; v^{(k)}) \triangleq \| v - L_d v^{(k)}\|_x^2 = \mathbb{E}\left[\left(v(S_t) - \left(L_dv^{(k)}\right)(S_t)\right)^2 \right] \enspace ,
\end{align*}
where the expectation is taken under the stationary distribution $x$. 

# Fitted Value Methods

\begin{align*}
\text{minimize} \enspace &\mathbb{E}\left[\left(v(S_t; w) - \left(L_dv^{(k)}\right)(S_t)\right)^2 \right]  \\
&= \mathbb{E}\left[\left(v(S_t; w) - \mathbb{E}\left[r(S_t, A_t) + \gamma v^{(k+1)}(S_{t+1}) \,\middle|\, S_t \right]\right)^2 \right]  \enspace .
\end{align*}
where $w$ is the optimization variable. 

::: tip 
Key idea: **given** $v^{(k)}$, we can approximately compute $TL_d$ as a supervised learning problem.
:::
::: warning
There is a supervised learning problem for each step of successive approximation; not a single static objective.
:::
