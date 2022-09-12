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

# Linear Quadratic Regulation

Assumption: cost function is quadratic and the dynamics are linear. 
\begin{align*}
&\text{minimize}\enspace x_T Q_T x_T + \sum_{t=1}^{T} \left(x_t^\top Q x_t + u_t^\top R u_t\right)\\
&\text{subject to} \enspace x_{t+1} = Ax_t + Bu_t,\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1 \enspace .
\end{align*}

This is a finite-horizon **deterministic** MDP over continuous sets of states and actions.
<!-- 
# Bellman Optimality Equation 

Terminology: instead of *value function*, we now talk about *cost to go function* and use the notation $J_t$ rather than $v_t$:
\begin{align*}
J_t(x_t) = \min_{u} \left\{ x_t^\top Q x_t + u^\top R u + J_{t+1}(Ax_t + Bu) \right\}\enspace .
\end{align*}

We get the above directly from the optimality equations in finite-horizons MDPs, but can express the expected next value directly because we have deterministic dynamics. 
\begin{align*}
v_{t}(s_t) = \min_{a \in \mathcal{A}{s_t}} \left\{r(s_t,a) + \gamma \sum_{j \in \mathcal{S}} p(j|s_t,a) v_{t+1}(j) \right\} \enspace .
\end{align*} -->

# Backward Induction 

The backward induction algorithm (value iteration in finite-horizon mdps) starts at the end, setting $v_{T}^\star(s_t) = r(s_T)$.  Here, we have:
\begin{align*}
J_T(x_T) = x_T Q_T x_T \enspace .
\end{align*}
By induction, we also have that:
\begin{align*}
J_t(x_t) = \min_{u} \left\{ x_t^\top Q x_t + u^\top R u + J_{t+1}(Ax_t + Bu) \right\}\enspace ,
\end{align*}
which must be quadratic. We solve the minimization problem in closed-form: take the gradient, set to zero.
\begin{align*}
 f_t(u) &\triangleq \left\{ x_t^\top Q x_t + u^\top R u + (Ax_t + Bu)^\top P_{t+1} (Ax_t + Bu) \right\} \\
 Df_t(u) &= 2u^\top R + 2(Ax_t + Bu)^\top P_{t+1} B = 0 \\
 \Rightarrow u^\star_t &=-(R + B^\top P_{t+1} B)^{-1} B^\top P_{t+1} Ax_t
\end{align*}

# Exact optimal cost-to-go function

If we substitute $u^\star_t$ into $J_t(x_t)$, we get: 
\begin{align*}
J_t(x_t) &= \min_{u} \left\{ x_t^\top Q x_t + u^\top R u + J_{t+1}(Ax_t + Bu) \right\}\\
&=x_t^\top Q x_t + (u^\star_t)^\top R u^\star_t + J_{t+1}(Ax_t + Bu^\star_t) \enspace .
\end{align*}

After some simplification, we get: 
\begin{align*}
J_t(x_t) &= x_t P_t x_t \\
P_t &= Q + A^\top P_{t+1} A - A^\top P_{t+1} B(R + B^\top P_{t+1} B)^{-1} B^\top  P_{t+1} A
\end{align*}

# Backward Induction for LQR: Ricatti Equation

We get the algorithm: 

- Set $P_T = Q_T$
- From $t=T-1, ..., 1$:
  - Set $P_{t} = Q + A^\top P_{t+1} A - A^\top P_{t+1} B(R + B^\top P_{t+1} B)^{-1} B^\top  P_{t+1} A$
  - Set $K_t = -(R + B^\top P_{t+1} B)^{-1} B^\top P_{t+1} A$

You can then compute the optimal control at time $t$ in state $x_t$ with $u_t^\star = K_t x_t$ (the optimal controls are linear in the states).

# 

Continuous-Time Control 

# Types of Problems
Mayer: 
\begin{align*}
&\text{minimize}\enspace c(x(t_f)) \\
&\text{subject to}\enspace \dot{x}(t) = f(x(t), u(t)) \\
&\text{given } x(t_0) = x_0 \enspace .
\end{align*}
Lagrange: 
\begin{align*}
&\text{minimize}\enspace \int_{t_0}^{t_f} c(x(t), u(t)) dt\\
&\text{subject to}\enspace \dot{x}(t) = f(x(t), u(t)) \\
&\text{given } x(t_0) = x_0 \enspace .
\end{align*}

# Bolza

\begin{align*}
&\text{minimize}\enspace c(x(t_f)) + \int_{t_0}^{t_f} c(x(t), u(t)) dt\\
&\text{subject to}\enspace \dot{x}(t) = f(x(t), u(t)) \\
&\text{given } x(t_0) = x_0 \enspace .
\end{align*}

# 

:::note
We now want to find a control function $u(t)$ (not just a sequence) that depends on the time $t$ (which is a real).

:::

:::note
The control function $u(t)$ depends only on the time, and not the state, hence we are still in the world of open-loop control (not closed-loop). 
:::

# Ordinary Differential Equation

In the disrete-time case, we had a *difference equation*:
\begin{align*}
x_{t+1} = f_t(x_t, u_t) \enspace .
\end{align*}
Now instead of explicitely specifying the *next state*, we specify how the state changes through time, aka: 
\begin{align*}
\dot{x}(t) \triangleq D x(t) = f(x(t), u(t)) \enspace .
\end{align*}

# Initial Value Problem (IVP)

\begin{align*}
&\text{find} \enspace x(t_f) \\
&\text{subject to}\enspace \dot{x}(t) = f(x(t), t) \\
&\text{given}\enspace x(t_0) = x_0 \enspace .
\end{align*}

Given an ODE and initial state at time $t_0$, find the value of the state at time $t_f$. 

# Quadrature

If we want to know what would be the value of the state variable at $t_{i+1} \triangleq t_i + h_i$, with $h_i$ being the \textit{integration step size} for the $i$-th step, then we have to compute the integral. By the fundamental theorem of calculus:
\begin{align*}
    x(t_{i+1}) = x(t_i) + \int_{t_i}^{t_{i+1}} f(x(t), t)dt \enspace .
\end{align*}


Using a quadrature rule, we can approximate this integral by dividing the step $h_i$ into $K$ subintervals:
\begin{align*}
    \int_{t_i}^{t_{i+1}} f(x(t), t) dt \approx h_i \sum_{j=1}^N \beta_j f(x(\tau_{ij}), \tau_{ij})
\end{align*}

:::info
Quadrature: A way to take a weighted sum of points in order to compute the *area*
:::

# Quadrature 


\begin{align*}
    \int_{t_i}^{t_{i+1}} f(x(t), t) dt \approx h_i \sum_{j=1}^N \beta_j f(x(\tau_{ij}), \tau_{ij})
\end{align*}

The coefficients $\beta_j$ are called \textit{weights} while we refer to $\rho_j$ as \textit{nodes} and must obey the ordering $0 \leq \rho_1 \leq \hdots \leq \rho_k \leq 1$ (for example $j/K$)

# Quadrature within a Quadrature 

While the value of $x(t_i)$ is given to us, we still have the problem of knowing what the state would be for each of the $N$ points within that subinterval. If we knew these points, we would compute: 

\begin{align*}
    \tilde{x}_{t_{i+1}} =  \tilde{x}_{t_i} + h_i \sum_{j=1}^N \beta_j f(x(\tau_{ij}), \tau_{ij}) \enspace .
\end{align*}

The idea behind the so-called \textit{Runge-Kutta} methods is to set up an auxiliary quadrature problem to obtain the value of those points.

# "Bootstrapping"

In \textit{explicit} Runge-Kutta methods, we ``bootstrap'' our inner quadrature formula from the values computed before: \begin{align*}
    k_{ij} = f\left(\left(\tilde{x}_{t_i} + h_i \sum_{l=1}^{j-1} \alpha_{il} k_{il}\right),\,  t_i + \rho_i h_i\right) \enspace .
\end{align*}

This recursive expression is then used within the ``outer'' quadrature formula and yields:
\begin{align*}
    \tilde{x}_{t_{i+1}} = \tilde{x}_{t_i} + h_i \sum_{j=1}^K \beta_j k_{ij} \enspace .
\end{align*}

# Special cases 

If we choose $K=1$ and set $\beta_j = 1$, we get the \textit{Euler method}: 
\begin{align*}
    \tilde{x}_{t_{i+1}} =  \tilde{x}_{t_i} + h_i k_i
\end{align*}
The classical Runge-Kutta method with $K=4$ is given by the updates:
\begin{align*}
    k_{i,1} &= h_i f(\tilde{x}_i, \, t_i) \\
    k_{i,2} &= h_i f(\tilde{x}_i + \frac{1}{2}k_{i,1},\, t_i + \frac{h_i}{2}) \\
    k_{i,3} &= h_i f(\tilde{x}_i + \frac{1}{2}k_{i,2}, \, t_i + \frac{h_i}{2}) \\
    k_{i,4} &= h_i f(\tilde{x}_i + k_{i,3},\, t_i+h_i) \\
    \tilde{x}_{i+1} &= \tilde{x}_i + \frac{1}{6}\left( k_{i,1} + 2k_{i,2} + 2k_{i,3} + k_{i,4} \right) \enspace .
\end{align*}

# Collocation

Rather than viewing Runge-Kutta methods as a nested quadrature rule, it is also possible to obtain the same results by considering the problem of approximating the continuous function $x(t)$ by a polynomial of order $K$. This idea will be studied in the context of the so-called "collocation" methods.

# Boundary Value Problem 

Let's consider a generalization of IVPs, en route to solving "full" optimal control problems. A specific kind of BVP is a Two-point boundary value problem (TPBVP):
\begin{align*}
&\dot{x}(t) = f(x(t), t), \enspace  a < t < b\\
&\psi(x(a), x(b)) = 0 \enspace .
\end{align*}

# Example 

Consider the BVP where the dynamics given by

\begin{align*}
\dot{x} = x
\end{align*}
**Goal**: find the initial state $x(a)$ such that terminal state is s equal to $\beta$.

The boundary condition is: $\psi(x(a), x(b)) \triangleq x(b) - \beta$. 

# Example: Closed-Form IVP 

\begin{align*}
    x(t) = x(a)\exp(t - a) \enspace .
\end{align*}

Because we are trying to find the initial value which leads to a trajectory satisfying the boundary condition, we view the initial value as an optimization variable $x_a$ and define a constraint function of the form: 
\begin{align*}
    h(x_a) \triangleq x_a \exp(b - a) - \beta\enspace ,
\end{align*}

This leads us to the idea of single-shooting methods (or sequential methods): simulate (integrate), observe terminal state, evaluate cost, ``backprop'' (if doing gradient-based optimization). 

# 


Figure 


# Forward Sensitivity Equation

Let's consider a parameterized ODE of the form: 
\begin{align*}
    \dot{x} = f(x(t), t, \theta), \enspace x(a) = x_a(\theta) \enspace ,
\end{align*}
Taking the total derivative:
\begin{align*}
   \frac{\partial^2 x(t)}{\partial \theta \partial t} = \frac{\partial f(x(t), t, \theta)}{\partial x} \frac{\partial x(t)}{\partial \theta} + \frac{\partial f(x(t), t, \theta)}{\partial \theta} \enspace . 
\end{align*}

Using the symmetry of second derivatives \footnote{See Schwarz's theorem, Clairaut's theorem, or Young's theorem}, we can write instead: 
\begin{align*}
       \frac{\partial^2 x(t)}{\partial t \partial \theta} = \frac{\partial f(x(t), t, \theta)}{\partial x} \frac{\partial x(t)}{\partial \theta} + \frac{\partial f(x(t), t, \theta)}{\partial \theta} \enspace . 
\end{align*}

#  Forward Sensitivity Equation

If we define $s \triangleq \frac{\partial x(t)}{\partial \theta}$ (``$s''$ as in \textit{sensitivity}), we get the \textit{forward sensitivity equations}: 
\begin{align*}
    \dot{s} = \frac{\partial f(x(t), t, \theta)}{\partial x} s(t) + \frac{\partial f(x(t), t, \theta)}{\partial \theta}, \enspace s(a) = \frac{\partial x(a)}{\partial \theta} . 
\end{align*}

We can easily evaluate the Jacobian of $f$ by augmenting the dynamics system $f$ with the corresponding sensitivity equation. We can then solve for the original IVP simultaneously with its sensitivities. 