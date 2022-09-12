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
J(x, T) = c(x) \enspace \text{and} \enspace 
0 = \min_{u \in \mathcal{U}}  \left\{ c(x, u) + \underbrace{D_2 J(x, t)}_{\mathclap{\text{time derivative}}} + \overbrace{D_1 J(x, t)}^{\mathclap{\text{space derivative}}} f(x,u) \right\} \enspace 
\end{align*}

This is a partial differential equation (PDE), with both time and space partial derivatives. 


# HJB as a PDE 

Theorem (Sufficiency).

:     Let $V(x,t)$ be a solution to the PDE: 
\begin{align*}
0 = \min_{u \in \mathcal{U}}\left\{c(x,u) + D_2 V(x,t) + D_1 V(x,t) f(x,u) \right\} \text{for all } x,t \enspace ,
\end{align*}
and boundary condition $V(x, t_f) = c(x)$ for all $x$. Then $V$ is the cost-to-go function $J$ and an optimal policy $\mu(x,t)$ can be obtained by minimizing the expression above given $V(x,t)$. 

# HJB in the Infinite-Horizon Case 

\begin{align*}
&\int_{t_0}^{\infty}\enspace c(x(t), u(t)) dt \\
&\text{subject to}\enspace \dot{x}(t) = f(x(t),u(t))  \\
&\text{given }\enspace x(t_0) = x_0 \enspace .
\end{align*}

The time derivative now disappears from the cost-to-go function:
\begin{align*}
0 = \min_{u \in \mathcal{U}}  \left\{ c(x, u) + D J(x) f(x,u) \right\} \enspace  \text{for all}\enspace x
\end{align*}

A ``v-improving'' policy can then be obtained as: 
\begin{align*}
\mu^\star(x) \in \arg\min_{u \in \mathcal{U}} \left\{ c(x, u) + D J(x) f(x,u) \right\} 
\end{align*}

# Control Affine Dynamics 
In the general case, the minimizer in the HJB equation cannot be computed in closed-form. However, this is possible for the class of control affine systems of the form: 
\begin{align*}
f(x, u) \triangleq g(x) + h(x)u \enspace .
\end{align*}

for some given functions $g$ and $h$. Furthermore, we can further restrict our attention to immediate cost functions of the form: 
\begin{align*}
c(x, u) \triangleq l(x) + u^\top R u \enspace .
\end{align*}

Note that the the above setting is more general the the plain LQR one. 

# Infinite-Horizon HJB under Control Affine Assumptions

\begin{align*}
0 = \min_{u \in \mathcal{U}}\left\{l(x) + u^\top R u + D J(x) \left( g(x) + h(x) u \right) \right\} \text{for all } x,t \enspace ,
\end{align*}

If we set the derivative with respect to $u$ of the quantity inside the min operator to zero, we get: 
\begin{align*}
2u^\top R + D J(x) h(x) = 0 \enspace ,
\end{align*}

which means that: 
\begin{align*}
u^\star = - \frac{1}{2}R^{-1} h(x)^\top D J(x)^\top
\end{align*}

# LQR in Continuous-Time 

Consider the following finite-horizon continuous-time LQR problem:

\begin{align*}
&\text{minimize} \enspace x(t_f)^\top Q_{t_f} x(t_f)  + \int_{t_0}^\infty \left( x(t)^\top Q x(t) + u(t)^\top R u(t)\right)\\
&\text{such that}\enspace \dot{x}(t) = A x(t) + B u(t) \\
&\text{given } \enspace x(t_0) = x_0 \enspace .
\end{align*}

# Solving the HJB for LQR

The HJB equation is then: 
\begin{align*}
J(x, t_f) &= x^\top Q_{t_f} x \\
0 &= \min_{u \in \mathcal{U}}\left\{ x^\top Q x + u^\top R u + D_2 J(x,t) + D_1 J(x,t)\left(Ax + Bu \right) \right\}
\end{align*}

Remember that in the discrete-time case, we had that the cost-to-go function was a quadratic. We can attempt to solve the above in the same way and start with $J(x, t) = x^\top K(t) x$ where $K(t)$ is a symmetric matrix. Note that: 
\begin{align*}
D_1 J(x,t) = 2x^\top K(t) \hspace{2em} \text{and} \hspace{2em} D_2 J(x,t) = x^\top \dot{K} (t) x
\end{align*}

# Substitution 


If we substitute our guess into the HJB, we get:
\begin{align*}
0 &= \min_{u \in \mathcal{U}}\left\{ x^\top Q x + u^\top R u + x^\top \dot{K}(t) x + 2x^\top K(t) \left(Ax + Bu \right) \right\}
\end{align*}

Setting the partial derivative of the inside quantity with respect to $u$ to zero, we get: 
\begin{align*}
2 u^\top R + 2x^\top K(t) B = 0 
\end{align*}

Solving for $u$, we get: 
\begin{align*}
u^\star = - R^{-1} B^\top K(t) x \enspace .
\end{align*}

# Substituting $u^\star$

Plugging 
\begin{align*}
u^\star = - R^{-1} B^\top K(t) x \enspace ,
\end{align*}
into the HJB: 
\begin{align*}
0 &= \min_{u \in \mathcal{U}}\left\{ x^\top Q x + u^\top R u + D_2 J(x,t) + D_1 J(x,t)\left(Ax + Bu \right) \right\}\\
&=  x^\top Q x + u^{\star\top} R u^\star + D_2 J(x,t) + D_1 J(x,t)\left(Ax + Bu^{\star\top} \right) \\
&= x^\top\left(\dot{K}(t) + K(t) A + A^\top K(t) - K(t) B R^{-1} B^\top K(t) + Q \right)x \enspace ,
\end{align*}
for all $x$ and $t$.

# Continuous-Time Ricatti Equation 

Matrix differential equation:
\begin{align*}
\dot{K}(t) = - K(t) QA - A^\top K(t) + K(t) B R^{-1} B^\top K(t) - Q \enspace ,
\end{align*}
with terminal condition $K(t) = Q_{t_f}$. 


Solving this equation then allows us to find the cost-to-go function as $J(x,t) = x^\top K(t) x$. With this $K(t)$ in hand, we can also compute the optimal controls with: 
\begin{align*}
\mu^\star(x,t) = -R^{-1} B^\top K(t) x \enspace.
\end{align*}

# From HJB to PMP 

Proposition 3.3.1

:    Let $\{u^\star(t) | t \in [0, t_f]\}$ be a an optimal control trajectory and let $\{x^\star | t \in [0,T]\}$ be the corresponding state trajectory. That is: 
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

Let's start by inserting the optimal policy $\mu^\star$ into the HJB. We get: 

\begin{align*}
c(x, \mu^\star(x, t)) + D_2 J(x, t) + D_1 J(x, t) f(x,\mu^\star(x, t))  = 0 \enspace .
\end{align*}

Differenting on both sides: