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

# Bolza Problems

\begin{align*}
&\text{minimize}\enspace c_T(x_T) + \sum_{t=1}^{T-1} c_t(x_t, u_t)\\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t),\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1
\end{align*}

We then know that if there exists feasible $x_1, \hdots, x_T, u_1, \hdots, u_{T-1}$, then it must be that there exists a unique set $\{\lambda_{t}^\star\}_1^{T-1}$ such that $D L(x^\star, u^\star, \lambda^\star) = 0$ in:
\begin{align*}
 L(x, u, \lambda) \triangleq c_T(x_T) + \sum_{t=1}^{T-1} c_t(x_t, u_t) + \sum_{t=1}^{T-1} \lambda_{t}(f_t(x_t, u_t) - x_{t+1}) \enspace .
\end{align*}

# Equality-Constrained Problem (ECP)

Let $f: \mathbb{R}^n \to \mathbb{R}$ and $h: \mathbb{R}^n \to \mathbb{R}^m$ in:
\begin{align*}
&\text{minimize} \enspace f(x)  \\
&\text{subject to} \enspace h(x) = 0 \enspace .
\end{align*}

First-order optimality condition tells us that if $x^\star$ is a regular feasible local minimum then there must be a $\lambda^\star$ such that $D L(x^\star, \lambda^\star) = 0$ (for both partial derivatives).

**Idea**: Let's view this problem as a root-finding problem, ie solve the nonlinear equations: $DL(x,\lambda) = 0$ in the variables $x$ and $\lambda$.

# Newton's Method for solving ECP
Let $y \triangleq (x, \lambda)$, so that $\varphi(y) \triangleq DL(x,\lambda)$. The iterates of Newton's method would look like:
\begin{align*}
y_{t+1} = y_t - [D \varphi(y_t)]^{-1} \varphi(y_t)\enspace .
\end{align*}
Note that $L: \mathbb{R}^n \times \mathbb{R}^m \to \mathbb{R}$, therefore $\varphi(y): \mathbb{R}^{n+m} \to \mathbb{R}^{n+m}$ and $[D\varphi(y)] \in \mathbb{R}^{(n+m) + (n+m)}$:
\begin{align*}
\begin{pmatrix} x_{t+1} \\ \lambda_{t+1} \end{pmatrix} &= \begin{pmatrix} x_{t} \\ \lambda_{t} \end{pmatrix}  - \begin{pmatrix} D_1^2 L(x_t, \lambda_t) & D_2 D_1 L(x_t, \lambda_t) \\ D_1 D_2 L(x_t, \lambda_t) & D_2^2 L(x_t, \lambda_t) \end{pmatrix}^{-1} \begin{pmatrix} D_1 L(x_t, \lambda_t) \\ D_2 L(x_t, \lambda_t) \end{pmatrix} \\
&=\begin{pmatrix} x_{t} \\ \lambda_{t} \end{pmatrix}  - \begin{pmatrix}D^2f(x_t) + \lambda D^2 h(x_t) & [D h(x_t)]^\top \\ D h(x_t) & 0 \end{pmatrix}^{-1}\begin{pmatrix} Df(x_t) + \lambda_t D h(x_t) \\ h(x_t) \end{pmatrix}
\end{align*}

# Solving for Delta 

As usual, we don't want to take an explicit inverse and we write:
\begin{align*}
[D\varphi(y_t)]\Delta_t = \varphi(y_t) \enspace \text{and} \enspace y_{t+1} &= y_t - \Delta_t \enspace .
\end{align*}
In our setting, we must solve for $\Delta_t$ in:
\begin{align*}
\begin{pmatrix}D^2f(x_t) + \lambda D^2 h(x_t) & [D h(x_t)]^\top \\ D h(x_t) & 0 \end{pmatrix} \Delta_t = \begin{pmatrix}
D f(x_t) + \lambda_t D h(x_t) \\
h(x_t)
\end{pmatrix}
\end{align*}

We refer to that matrix (that we want to avoid inverting explicitely) the **KKT matrix**.

# Assumptions

The KKT matrix is nonsingular under the following assumptions (see Nocedal 18.1):

1. The Jacobian $Dh(x)$ has full row rank
2. The Hessian $D_1^2 L(x, \lambda)$ is positive definite on the tangent space of the constraints. That is given any $z \not = 0$ such that $D h(x) z = 0$, then $z^\top D_1^2 L(x, \lambda) z > 0$.

(these were the assumptions of the Lagrange multiplier theorem in the Bertsekas book)

Under those assumptions, this method converges quadratically if the primal-dual pair is chosen close enough to the optimum.

# Approximation by a QP

The idea behind this method is to approximate the ECP by a simplier one. If $f$ is twice continuously differentiable, then function can be approximated locally by a quadratic model:
\begin{align*}
\tilde{f}_k(x) \triangleq f(x_t) + D f(x_t) (x - x_t) + \frac{1}{2} (x - x_t)^\top D^2 f(x_t) (x - x_t) \enspace.
\end{align*}

Similarly, we can approximate the constraint by a linear model: 
\begin{align*}
\tilde{h}_k(x) \triangleq h(x_t) + D h(x_t) (x - x_t) \enspace .
\end{align*}

# Approximation by a QP

We now have a Quadratic Program (QP):
\begin{align*}
&\text{minimize} \enspace f(x_t) + D f(x_t)p + \frac{1}{2} p^\top D^2 f(x_t) p\\
&\text{subject to}\enspace h(x_t) + D h(x_t)p  = 0 \enspace ,
\end{align*}
where the optimization variable is the vector $p$. Note that the quadratic term acts as a *regularizer*, penalizing for values that are too far from where our approximation is taken. Instead of using the hessian of $f$, we choose instead to take $D^2_1 L(x_t, \lambda_t)$.

# Sequential Quadratic Program (SQP)

The idea behind SQP is to keep on solving a QP instead of the original ECP. The final form is:
\begin{align*}
&\text{minimize} \enspace f(x_t) + D f(x_t)p + \frac{1}{2} p^\top D^2_1 L(x_t, \lambda_t) p\\
&\text{subject to}\enspace h(x_t) + D h(x_t)p  = 0 \enspace ,
\end{align*}

# Quadratic Programs in General

An equality-constrained QP is a problem of the form:
\begin{align*}
&\text{minimize}\enspace c^\top x + \frac{1}{2} x^\top Q x \\
&\text{subject to} \enspace A x = b \enspace .
\end{align*}
The Lagrangian is:
\begin{align*}
L(x, \lambda) = c^\top x + \frac{1}{2} x^\top Q x + \lambda (Ax - b) \enspace .
\end{align*}
The first-order optimality condition tell us that $D L(x^\star, \lambda^\star) = 0$, hence: 
\begin{align*}
D_1 L(x, \lambda) = c^\top + x^\top Q + \lambda A x \\
D_2 L(x, \lambda) = Ax - b \enspace .
\end{align*}

# Matrix Form

The first-order condition then coincide with the linear system: 
\begin{align*}
\begin{pmatrix} 
Q & A^\top \\
A & 0
\end{pmatrix} \begin{pmatrix}
x^\star\\
\lambda^\star
\end{pmatrix} = \begin{pmatrix}-c \\ b\end{pmatrix}
\end{align*}
