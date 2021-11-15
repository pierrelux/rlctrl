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

# Deterministic Discrete-time Trajectory Optimization 

Mayer problem:
\begin{align*}
&\text{minimize}\enspace c_T(x_T) \\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t),\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1
\end{align*}

:::warning 

In this formulation, the optimization variables are $x_1, \hdots, x_{T}$ and $u_1, \hdots, u_{T-1}$. We solve for both the controls **and the states** that minimize the terminal cost function.

:::

# 

Lagrange problem:
\begin{align*}
&\text{minimize}\enspace \sum_{t=1}^T c(x_T, u_t) \\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t),\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1
\end{align*}

Bolza problem:
\begin{align*}
&\text{minimize}\enspace c_T(x_T) + \sum_{t=1}^{T-1} c(x_T, u_t) \\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t),\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1
\end{align*}


# Transformation as unconstrained problem

Idea: we can reconstruct the state at any point in time by simulating the deterministic system forward in time. More precisely, let $\phi_t(u)$ be a function such that $\phi_t(u) = x_t$, and where 
$u = (u_1, \hdots, u_T-1)$.
\begin{align*}
&\text{minimize} \enspace c_T(\phi_T(u)) \enspace .
\end{align*}
By the chain rule, we have $D_{i} J(u) = D c_T(x_T) D_i \phi_T (u)$ with the recursion: 
\begin{align*}
D_i \phi_{t+1} (u) &= D_1 f_{t}(x_{t}, u_{t}) D_i \phi_{t}(u) , \forall t=i+1, \hdots, T\\
D_i \phi_{i+1} &= D_2 f_{i}(x_i, u_i) \enspace .
\end{align*}

# Adjoint/Costate vector
We can choose to accumulate the derivatives from left to right, in which case:

\begin{align*}
D_i J(u) = \underbrace{\underbrace{\underbrace{D c_T(x_T)}_{\lambda_T} D_1 f_{T-1}(x_{t-1}, u_{T-1})}_{\lambda_{T-1}} \hdots D_1 f_{i+1}(x_{i+1}, u_{i+1})}_{\lambda_{i+1}} D_2 f_{i}(x_i, u_i)
\end{align*}

Therefore, $D_i J(u) = \lambda_i D_2 f_i(x_i, u_i)$. The $\{\lambda_i\}_{i+1}^T$ are called **adjoint** or **co-state** vectors.

# Adjoint Equation 

The accumulation of derivative backwards in time can therefore be described by: 
\begin{align*}
\lambda_T &= D c_T(x_T) \\
\lambda_t &= \lambda_{t+1} D_1 f_t(x_t, u_t),\enspace t=T-1, ..., i+1\,
\end{align*}
which we call the **adjoint equation**. In order to solve this equation we need to first run the system forward in time: 
\begin{align*}
x_{t+1} = f_t(x_t, u_t), \enspace t=1, \hdots, T \enspace .
\end{align*}
We can then finally get:
\begin{align*}
D_i J(u) = \lambda_{i+1} D_2 f_i(x_i, u_i)\enspace .
\end{align*}

# Constrained Optimization 

Consider the following nonlinear program with equality constraints: 
\begin{align*}
&\text{minimize}\enspace f(x) \\
&\text{subject to} \enspace h(x) = 0 \enspace . 
\end{align*}
where $x \in \mathbb{R}^n$ and $h: \mathbb{R}^n \to \mathbb{R}^m$. 

We know that in the unconstrained case that if $x^\star$ is a local minimum then, $Df(x^\star) = 0$. But what if we have constraints? 

# Lagrange Multiplier Theorem
In the following, we assume that $f$ and $h$ are continuously differentiable functions. 

Theorem
  : Let $x^\star$ be a local minimum of $f$ and feasible solution for which the constraint gradients $D h_1(x^\star), ..., D h_m(x^\star)$ are linearly independent. There exists a unique *Lagrange multiplier* row vector $\lambda^\star \in \mathbb{R}^{1 \times m}$ such that: 
  \begin{align*}
  &D_1 L(x^\star, \lambda^\star) = 0 \enspace \text{and} \enspace D_2 L(x^\star, \lambda^\star) = 0 \\
  &\text{where} \enspace L(x, \lambda) \triangleq f(x) + \lambda h(x) \enspace .
  \end{align*}

# Interpretation 

\begin{align*}
  D_1 L(x^\star, \lambda^\star) = D f(x^\star) + \lambda^\star D h(x^\star)  = 0
  \end{align*}

Therefore $Df(x^\star) = -\sum_{i=1}^m \lambda^\star_i D h_i (x^\star)$. This means that $D f(x^\star)$ can be expressed a linear combination of constraint gradients. The objective gradient is in the span of the constraint gradients at $x^\star$.

# Intuition for Proof 

We can try to ``reparameterize'' our problem such that the constraints are pushed inside the main objective (similar to what we did in the optimal control case). This time however, we proceed to this transformation using the implicit function theorem. 


Consider partition of the variables such that $x = (y, z)$. We will view $y$ as an dependent variable and $z$ as an independent one. 
\begin{align*}
&\text{minimize}\enspace f(y, z) \\
&\text{subject to} \enspace h(y, z) = 0 \enspace . 
\end{align*}

# Implicit Function 

By the implicit function theorem, if we have  $h(y^\star, z^\star) = 0$ for some pair $x^\star, y^\star$ and that $[D_1 h(y^\star, z^\star)]^{-1}$ exists then there exists a function $\phi$ such that $h(\phi(z^\star), z^\star) = 0$ and $D\phi(z^\star) = [D_1 h(\phi(z^\star), z^\star)]^{-1} D_2 h(\phi(z^\star), z^\star)$.

We can then re-write our constrained optimization problem as: 
\begin{align*}
\text{minimize}\enspace f(\phi(z^\star), z^\star) \enspace, 
\end{align*}
and we know that the constraint will be satisfied (since $\phi$ maps to $y^\star$)

# First-order Condition

Now that are dealing with a constrained problem, we know that 
\begin{align*}
D J(z^\star) = 0 \enspace \text{where} \enspace J(z^\star) = f(\phi(z^\star), z^\star) \enspace .
\end{align*}
By the chain rule: 
\begin{align*}
D J(z^\star) &= D_1 f(\phi(z^\star), z^\star) D \phi(z^\star) + D_2 f(\phi(z^\star), z^\star) \\
&=D_1 f(\phi(z^\star), z^\star)  [D_1 h(\phi(z^\star), z^\star)]^{-1} D_2 h(\phi(z^\star), z^\star) + D_2 f(\phi(z^\star), z^\star)\\
&= \lambda^\star D_2 h(\phi(z^\star), z^\star) + D_2 f(\phi(z^\star), z^\star) \enspace .
\end{align*}

Therefore there exists a unique vector $\lambda^\star$ such that the above holds.

# Generalized Reduced Gradient Methods

:::note 
This idea is the basis for the so-called **Generalized Reduced Gradient Method** (GRG) for solving nonlinear programs. Pick a subset of the variables, satisfy the corresponding constraints (by Newton's method for example), take a gradient step using implicit differentiation

:::

# From Lagrange Multipliers to Adjoint Equation

Let's tackle our OCP using the Lagrange multiplier theorem.

\begin{align*}
&\text{minimize}\enspace c_T(x_T) + \sum_{t=1}^{T-1} c_t(x_t, u_t)\\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t),\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1
\end{align*}

We then know that if there exists feasible $x_1, \hdots, x_T, u_1, \hdots, u_{T-1}$, then it must be that there exists a unique set $\{\lambda_{t}^\star\}_1^{T-1}$ such that $D L(x^\star, u^\star, \lambda^\star) = 0$ in:
\begin{align*}
 L(x, u, \lambda) \triangleq c_T(x_T) + \sum_{t=1}^{T-1} c_t(x_t, u_t) + \sum_{t=1}^{T-1} \lambda_{t}(f_t(x_t, u_t) - x_{t+1}) \enspace .
\end{align*}

# First-Order Optimality 

For mathematical convenience, we can write the Lagrangian as: 

\begin{align*}
L(x,u,\lambda) &\triangleq c_T(x_T) + \sum_{t=1}^{T-1} \left( c_t(x_t, u_t) + \lambda_{t+1}\left( f_t(x_t, u_t) - x_{t+1}\right) \right) \\
&= c_T(x_T) + \lambda_T x_T - \lambda_1 x_1 \sum_{t=1}^{T-1} \left( c_t(x_t, u_t) + \lambda_{t+1}f_t(x_t, u_t) - \lambda_t x_t \right)
\end{align*}

By noting that: 
\begin{align*}
\sum_{t=1}^{T-1} \lambda_{t+1} x_{t+1} = \lambda_T x_T - x_1 \lambda_1 + \sum_{t=1}^{T-1} \lambda_{t} x_{t}
\end{align*}

The advantage being that $x_t$ appears only once in the summation.

# Adjoint Equation

If there exists a feasible local minimum $(x^\star, u^\star)$ then there exists a Lagrange multiplier $\lambda^\star$ such that $DL(x^\star, u^\star, \lambda^\star) = 0$. 
\begin{align*}
D_{x_i} L(x^\star, u^\star, \lambda^\star) = \begin{cases}
D c_T (x_T^\star) + \lambda_T^\star & i = T\\
D_1 c_t(x_t^\star, u_t^\star) + \lambda_{t+1} D_1 f_t(x_t^\star, u_t^\star) - \lambda_t^\star & i \in \{i, \hdots, T-1\}
\end{cases} 
\end{align*}
In other words: 
\begin{align*}
\lambda_T^\star &= D c_T(x_T^\star) \\
\lambda_t^\star &= D_1 c_t(x_t^\star, u_t^\star) + \lambda_{t+1} D_1 f_t(x_t^\star, u^\star) \enspace .
\end{align*}

# 

Optimality of the controls:

\begin{align*}
D_{u_t} L(x^\star, u^\star, \lambda^\star) = D_2 c_t(x_t^\star, u_t^\star) + \lambda_{t+1} D_2 f_t(x_t^\star, u_t^\star) \enspace .
\end{align*}

Forward dynamics:
\begin{align*}
D_{\lambda_{t+1}} L(x^\star, u^\star, \lambda^\star) = f_t(x_t, u_t) - x_{t+1} = 0 \enspace .
\end{align*}

The three partial derivatives form the basis for the discrete-time Pontryagin maximum principle (PMP)

# Algorithms for constrained optimization 

(Shown on the board. More in next lecture)
