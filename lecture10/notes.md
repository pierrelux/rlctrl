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

# Recap: stochastic approximation
In root-finding SA were we want to find a solution to:
\begin{align*}
\bar{c} - f(x) = 0 \enspace ,
\end{align*}
but only via noisy observations of $f(x)$. This leads to the SA iterates: 
\begin{align*}
x^{(k+1)} = x^{(k)} + \eta_k \left( \bar{c} - y_k\right)\enspace ,
\end{align*}
Under some assumptions on the type of noise, we saw that we can approximate the above by the ODE: 
\begin{align*}
\dot{x}(t) = \left(\bar{c} - f(x(t))\right) \enspace.
\end{align*}
If $x^\star$ is an asymptotically stable equilibrium of the ODE, then $x^{(k)} \to x^\star$ with probability one. 


# TD(0) witih linear function approximation
\begin{align*}
w^{(t+1)} = w^{(t)} + \eta_t \underbrace{\underbrace{\left(r_t + \gamma v\left(s_{t+1}; w^{(t)}\right) - v\left(s_t; w^{(t)}\right) \right)}_{\delta_t} \phi_t}_{y_t}\enspace .
\end{align*}
How can we think of this as a stochastic root-finding problem? Noisy observations of which function? 
Conceptually, we want to find a $w$ such that $f(w) = 0$, but instead of observing $f(w)$, we only get to observe $y_t = \delta_t \phi_t$ and have a SA recursion of the form $w^{(t+1)} = w^{(t)} + \eta_t\delta_t \phi_t = w^{(t)} + \eta_t y_t$.

::: warning
We don't know what that $f$ is just yet! This is what we are about to find out in the next slides.
:::

# Mean iterates

Let's average out the iterates under the stationary distribution of $d^\infty$:
\begin{align*}
\bar{w}^{(k+1)} = \bar{w}^{(k)} + \eta_k \mathbb{E}\left[  \left(R_t + \phi_t^\top \bar{w}^{(k)} - \gamma \phi_{t+1}^\top \bar{w}^{(k)}\right) \phi_t \right] \enspace .
\end{align*}
Here $\phi_t \triangleq \phi(S_t)$, $\phi_{t+1} \triangleq \phi(S_{t+1})$, $R_t \triangleq r(S_t, A_t)$ are random variables.

The above expectation is linear function of $\bar{w}^{(k)}$, therefore, we can also write it in matrix form as: 
\begin{align*}
\bar{w}^{(k)} &=  \bar{w}^{(k)} + \eta_k \mathbb{E}\left[  \left(R_t + \phi_t^\top \bar{w}^{(k)} - \gamma \phi_{t+1}^\top \bar{w}^{(k)}\right) \phi_t \right]\\
&=\bar{w}^{(k)} + \eta_k \left(\Phi^\top X r_d - \Phi^\top X \left(I - \gamma P_d\right) \Phi \bar{w}^{(k)} \right) \enspace .
\end{align*}

# TD(0) ODE

We therefore have a linear ODE of the form: 
\begin{align*}
\dot{w}(t) = f(w(t)) \triangleq \Phi^\top X r_d - \Phi^\top X \left(I - \gamma P_d\right) \Phi w(t)\enspace .
\end{align*}

and if $w^\star$ is an asymptotically stable equilibrium of $f$, then $w^{(k)} \to w^\star$ with probability one.

# Asymptotic stability for linear ODEs

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

# Operator-theoretic viewpoint

Instead of the above two analysis methods, we are instead going to leverage an operator theoretic perspective on our problem. 
Consider again the deterministic iterates: 
\begin{align*}
\bar{w}^{(k)} &=\bar{w}^{(k)} + \eta_k \left(\Phi^\top X r_d - \Phi^\top X \left(I - \gamma P_d\right) \Phi \bar{w}^{(k)} \right) \enspace .
\end{align*}

This can be seen as an instance of Richardson iteration for solving the linear system of equations: 
\begin{align*}
\Phi^\top X \left(I - \gamma P_d\right) \Phi w = \Phi^\top X r_d \enspace .
\end{align*}

Or equivalently: 
\begin{align*}
\Phi^\top X \left( r_d - \left(I - \gamma P_d\right) \Phi w\right) = 0\enspace .
\end{align*}

# Weighted Euclidean norm

Definition
:   We write $\|\cdot \|_x$ to denote the weithed Euclidean norm on $\mathbb{R}^n$. That is, if $v \in \mathbb{R}^n$, then: 
\begin{align*}
\| v\|_x \triangleq \sqrt{\sum_{i=1}^n x_i v_i^2}
\end{align*}

# Normal equation

The key observation is that:
\begin{align*}
\Phi^\top X \left( r_d - \left(I - \gamma P_d\right) \Phi w\right) = 0\enspace ,
\end{align*}
is a normal equation corresponding to a projection. More precisely, if we find a $\hat{w}$ that satisfies the above, then it must also be that:
\begin{align*}
\hat{w} = \arg\min_{w \in \mathbb{R}^{m}} \| \Phi w - (r_d + \gamma P_d \Phi \bar{w}) \|^2_x
\end{align*}

::: note
We made the assumption that $\Phi$ is full rank, which means that the set of minimizer is a singleton.
:::

# Variational problem

Let $T$ be an operator projecting onto the space $\mathcal{B}$ spanned by the columns of $\Phi$ (ie. any vector in that space can be written as a unique linear combination of the vectors in the basis). 

The meaning of $T$ being a projection is that that is given any $v\in \mathbb{R}^{|\mathcal{S}|}$, $Tv$ returns the unique vector from $\mathcal{B}$ that minimizes $\|v - \hat{v}\|^2_x$ for any $\hat{v} \in \mathcal{B}$.
That is: 
\begin{align*}
Tv = \Phi \hat{w} \enspace \text{where}\enspace \hat{w} = \arg\min_{w \in \mathbb{R}^m} \| v - \Phi w\|^2_x
\end{align*}


# Composition of operators

In our case, we want to project $L_d (\Phi w) \in \mathbb{R}^{|\mathcal{S}|}$. This means that we want to find a $\hat{w} \in \mathbb{R}^{m}$ such that:
\begin{align*}
\hat{w} = \arg\min_{w\in\mathbb{R}^m} \| \Phi w - (r_d + \gamma P \Phi \hat{w})\|^2_x
\end{align*}

The **projected policy evaluation operator** is the composition of the projection operator $T$ with the policy evaluation operator $L_d$. The corresponding fixed-point problem is then to find a $w \in \mathbb{R}^k$ such that: 
\begin{align*}
T L_d (\Phi w) = \Phi w \enspace .
\end{align*}

# But do we have a contraction?

Wouldn't be nice if $T L_d$ were to be a contraction? We could then leverage Banach's fixed-point theorem to prove the existence of a unique solution + get an algorithm to find it for free. 
(Spoiler: yes, it can be). 

Two notions to see before we get there:
1. Projections are nonexpansives
2. On-policy inequality

1+2 + contractivity of $L_d$ will allows to build our proof. 

# Nonexpanive mapping

Projections are nonexpansive, this means that: 

\begin{align*}
\|Tv - Tu \|_x \leq \|v - u\|_x, \forall v \in \mathbb{R}^{|\mathcal{S}|}, u \in \mathbb{R}^{|\mathcal{S}|} \enspace .
\end{align*}

Also, by the Pythagorean theorem:

\begin{align*}
\| Tv - Tu \|^2_x = \|T(v - u)\|^2_x \leq \|T(v -u)\|^2 + \| (I - T)(v - u) \|_x^2 = \|v - u\|^2_x
\end{align*}

# 

Therefore $T L_d$ is a contraction with respect to the norm $\|\cdot\|_x$ if $T$ is a contraction with respect to $\|\cdot\|_x$ because:
\begin{align*}
\|TL_d v - TL_d u\|_x \leq \|Tv - Tu\|_x \leq \gamma \|v - u\|_x \enspace .
\end{align*}

::: warning
We saw that $L_d$ is $\gamma$-contraction with respect to the sup-norm, but it doesn't have to be the case for any weighted norm $\|\cdot\|_x$. 
Because of that, we need to impose conditions on $x$ to ensure that it's the case. 
:::

# On-policy inequality

Therorem 

: Let $P$ be the transition matrix of some Markov chain with stationary distribution $x$, then: 
\begin{align*}
\|Pz\|_x \leq \|z\|_x, \enspace \forall z \in \mathbb{R}^n
\end{align*}


