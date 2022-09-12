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


# Continuous-Time OCP 

We consider problems of the form: 

\begin{align*}
&\text{minimize} \enspace c(x(t_f)) + \int_{t_0}^{t_f} c(x(t), u(t)) dt \\
&\text{subject to}\enspace \dot{x}(t) = f(x(t), u(t)) \\
&\text{given} \enspace x(t_0) = x_0 \enspace .
\end{align*}

# The Hamilton-Jacobi Equations

We can show that the cost-to-go for the above continuous-time problem function satisfies for all $x, t$: 

\begin{align*}
J(x, t_f) = c(x) \enspace \text{and} \enspace 
0 = \min_{u \in \mathcal{U}}  \left\{ c(x, u) + \underbrace{D_2 J(x, t)}_{\mathclap{\text{time derivative}}} + \overbrace{D_1 J(x, t)}^{\mathclap{\text{space derivative}}} f(x,u) \right\} \enspace 
\end{align*}

This is a partial differential equation (PDE), with both time and space partial derivatives. 

# From HJB to PMP 

Proposition 3.3.1

:    Let $\{u^\star(t) | t \in [0, t_f]\}$ be a an optimal control trajectory and let $\{x^\star | t \in [0,t_f]\}$ be the corresponding state trajectory. That is: 
\begin{align*}
\dot{x}^\star(t) = f(x^\star(t), u^\star(t)), \enspace x^\star(t_0) = x_0 \enspace .
\end{align*}

For all $t \in [0, t_f]$: 
\begin{align*}
u^\star(t) \in \arg \min_{u \in \mathcal{U}} H(x^\star(t), u, \lambda(t)) \enspace , 
\end{align*}
where $H$ is the Hamiltonian, ie: 
\begin{align*}
H(x,u,\lambda) \triangleq c(x,u) + \lambda f(x,u) \enspace .
\end{align*}

# From HJB to PMP 

(continued) and $\lambda$ satisfies the adjoint equation: 
\begin{align*}
\dot{\lambda}(t) = -D_1 H(x^\star(t), u^\star(t), \lambda(t)) \enspace , 
\end{align*}
with boundary condition $\lambda(t_f) = D c(x^\star(t_f))$. 
Furthermore, there is a constant $C$ such that: 
\begin{align*}
H(x^\star(t), u^\star(t), \lambda(t)) = C \enspace ,
\end{align*}
for all $t \in [0, t_f]$. 

# Derivation (informal)

Here, we use the approach in Bertsekas, which makes an assumption on the set of controls $\mathcal{U}$ being convex, in tandem with lemma 3.3.1 about differentiating through the $\min$ operator. 

Lemma 3.3.1 

:    Let $F(x,u,t)$ be a continuously differentiable function of $t \in \mathbb{R}$, $x \in \mathbb{R}^n$, $u \in \mathbb{R}^m$ and let $\mathcal{U}$ be a convex subset of $\mathbb{R}^m$. Assume that $\mu^\star(x,t)$ is a continuously differentiable function of $u$ such that: 
\begin{align*}
\mu^\star(x,t) = \arg \min_{u \in \mathcal{U}} F(x,u,t) \enspace \text{for all } x,t  \enspace .
\end{align*}


# Lemma 3.3.1 continued

Let $G(x,t) \triangleq \min_{u \in \mathcal{U}} F(x,u,t)$, it follows that for all $x, t$: 

1. $D_1 G(x,t) = D_1 F(x, \mu^\star(x,t), t)$
2. $D_2 G(x,t) = D_3 F(x,\mu^\star(x,t), t)$

**Proof**: Note that $G(x,t) = F(x, \mu^\star(x,t), t)$. Taking the (total) derivative: 
\begin{align*}
  D_1 G(x,t) &= D_1 F(x, \mu^\star(x,t), t) + D_2 F(x, \mu^\star(x,t), t) D_1 \mu^\star(x,t) \\
  D_2 G(x,t) &= D_3 F(x, \mu^\star(x,t), t) + D_2 F(x, \mu^\star(x,t), t) D_2 \mu^\star(x,t)
\end{align*}
Or more compactly with $y = (x,t)$ and $G(y) = \min_{u\in\mathcal{U}} F(y, u) = F(y, \mu^\star(y))$:
\begin{align*}
D G(y) = D_1 F(y, \mu^\star(y)) + D_2 F(y, \mu^\star(y)) D \mu^\star(y) \enspace .
\end{align*}


# Lemma 3.3.1: Taylor Theorem

Let $\mu^\star(x,t) \triangleq \mu^\star(y)$, by Taylor's theorem: 
\begin{align*}
\mu^\star(z) = \mu^\star(y) + D \mu^\star(y)(z - y) + h_1(z)(z - y) \enspace ,
\end{align*}
with $\lim_{z \to y} h_1(z) = 0$. If we evaluate the function at $y + \Delta_y$: 
\begin{align*}
\mu^\star(y+\Delta_y) = \mu^\star(y) + D \mu^\star(y)\Delta_y + o(\|\Delta_y\|) \enspace ,
\end{align*}
or written differently:
\begin{align*}
\mu^\star(y + \Delta_y) - \mu^\star(y) =  D \mu^\star(y)\Delta_y + o(\|\Delta_y\|) \enspace .
\end{align*}
(the difference in the output for a perturbation $\Delta_y$)


# Lemma 3.3.1: Optimality Conditions

The optimality conditions in the convex case are:
\begin{align*}
D_2 F(y, \mu^\star(y))(u - \mu^\star(y)) \geq 0 \enspace \text{for all } u \in \mathcal{U}
\end{align*}
Which we can also write as: 
\begin{align*}
D_2 F(y, \mu^\star(y))(\mu^\star(y + \Delta_y) - \mu^\star(y)) \geq 0  \enspace \text{for all } \Delta_y
\end{align*}
Using Taylor's theorem from previous slide: 
\begin{align*}
D_2 F(x, \mu^\star(y), t)\left(D \mu^\star(y)\Delta_y + o(\|\Delta_y\|) \right) \geq 0  \enspace \text{for all } \Delta_y
\end{align*}
which means that:
\begin{align*}
D_2 F(x, \mu^\star(y), t) D \mu^\star(y)  = 0 \enspace .
\end{align*}

# Lemma 3.3.1: Simplifying total derivatives 

Going back to our problem 
\begin{align*}
D G(y) = D_1 F(y, \mu^\star(y)) + D_2 F(y, \mu^\star(y)) D \mu^\star(y) \enspace .
\end{align*}
But since \begin{align*}
D_2 F(x, \mu^\star(y), t) D \mu^\star(y)  = 0 \enspace .
\end{align*}
It follows that: 
\begin{align*}
D G(y) = D_1 F(y, \mu^\star(y)) \enspace .
\end{align*}


# Back to HJB

\begin{align*}
0 = \min_{u \in \mathcal{U}}  \left\{ c(x, u) + D_2 J(x, t) + D_1 J(x, t) f(x, u) \right\} \enspace ,
\end{align*}
which we express using the optimal control function $\mu^\star$:  
\begin{align*}
0 = c(x, \mu^\star(x,t)) + D_2 J(x, t) + D_1 J(x, t) f(x, \mu^\star(x, t)) \triangleq G(x,t) \enspace .
\end{align*}



# HJB 
Differentiating $G$ in both arguments and using lemma 3.3.1:
\begin{align*}
D_1 G(x,t) = D_1 c(x, \mu^\star(x,t)) + D_1 D_2 J(x, t) + 
D_1^2 J(x,t) f(x, \mu^\star(x,t)) + \\
 D_1 f(x, \mu^\star(x,t)) D_1 J(x, t)
\end{align*}
Similarly: 
\begin{align*}
0 = D_2^2 J(x, t) + D_2 D_1 J(x, t) f(x, \mu^\star(x, t))
\end{align*}
With some re-writing of the above along $\dot{x}(t) = f(x(t), u(t))$, we have: 
\begin{align*}
D_t \left( D_1 J(x(t), t) \right) &= D_1 D_2  J(x(t), t) + D_1^2 J(x(t), t) f(x(t), u)  \\
D_t \left( D_2 J(x(t), t) \right) &= D_2^2 J(x(t), t) + D_1 D_2 J(x(t), t) f(x(t), u)
\end{align*}

# Adjoint equation 

Denoting: 
\begin{align*}
\lambda(t) = D_1 J(x, t) \\
\lambda(t_0) = D_2 J(x, t) 
\end{align*}
We can then write: 
\begin{align*}
D_1 G(x,t) = D_1 c(x, \mu^\star(x,t)) + D_1 D_2 J(x, t) + 
D_1^2 J(x,t) f(x, \mu^\star(x,t)) + \\
 D_1 f(x, \mu^\star(x,t)) D_1 J(x, t)
\end{align*}
as: 
\begin{align*}
\dot{\lambda}(t) = - D_1 f(x(t), u(t)) \lambda(t) - D_1 c(x(t), u(t)) \enspace .
\end{align*}
And from 
\begin{align*}
0 = D_2^2 J(x, t) + D_2 D_1 J(x, t) f(x, \mu^\star(x, t))
\end{align*}
get: $\lambda