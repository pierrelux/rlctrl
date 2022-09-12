---
title: "A High-Level Overview of Path Integral Control"
author: [Pierre-Luc Bacon]
subject: "Reinforcement learning, optimal control"
keywords: [reinforcement learning, optimal control]
lang: "en"
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]
---

# Discrete-Time OCP

\begin{align*}
&\text{minimize} \enspace c_T(x_T) + \sum_{t=1}^{T-1} c_t(x_t, u_t) \\
&\text{subject to} \enspace x_{t+1} = f_t(x_t, u_t) , \enspace \text{for} \enspace t=1, \hdots, T-1\\
&\text{given} \enspace x_1 \enspace .
\end{align*}

The **value function** of a parametric mathematical program is the mapping from program parameters to optimal value. Here the "parameters" (inputs) are $x_1$ and the value is $c_T(x_T^\star) + \sum_{t=1}^{T-1} c_t(x_t^\star, u_t^\star)$ where $\{x_t^\star\}_{t=2}^T$ and $\{u_t^\star\}_{t=1}^{T-1}$.


# Bellman Optimality Equations

In the optimal control context, the value function is called the cost-to-go function and satisfies the Bellman optimality equations: 
\begin{align*}
J_T(x_T) &\triangleq c_T(x_T) \\
J_t(x_t) &\triangleq \min_{u_t \in \mathcal{U}(x_t)} \left\{ c_t(x_t, u_t) +  J_{t+1}(f_t(x_t,u_t))\right\} \enspace t=1, \hdots, T-1 .
\end{align*}

The above are DP equations in a discrete-time finite horizon MDP. 


# Special case: Linear Quadratic Regulation

\begin{align*}
&\text{minimize}\enspace x_T Q_T x_T + \sum_{t=1}^{T} \left(x_t^\top Q x_t + u_t^\top R u_t\right)\\
&\text{subject to} \enspace x_{t+1} = Ax_t + Bu_t,\; t=1, \hdots T-1 \\
&\text{given} \enspace x_1 \enspace .
\end{align*}

# Backward Induction for LQR: Ricatti Equation

The local minimization problem in the Bellman optimality equations can be solved in closed-form under the LQR setting. 


The cost-to-go function is quadratic and of the form $J_t(x_t) \triangleq x_t^\top P_t x_t$ for all $t=1, \hdots, T$.
and the matrices $\{P_1, \hdots, P_T\}$ can be found by backward induction:

- Set $P_T = Q_T$
- From $t=T-1, ..., 1$:
  - Set $P_{t} = Q + A^\top P_{t+1} A - A^\top P_{t+1} B(R + B^\top P_{t+1} B)^{-1} B^\top  P_{t+1} A$
  - Set $K_t = -(R + B^\top P_{t+1} B)^{-1} B^\top P_{t+1} A$

You can then compute the optimal control at time $t$ in state $x_t$ with $u_t^\star = K_t x_t$ (the optimal controls are linear in the states).

# Continuous-Time

Is there also a Dynamic Programming approach to continuous-time OCPs?

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

Note that while the OCP only involves an ODE, the HJB are partial differential equations (PDEs): a specification of how the partial derivatives of a function ought to behave together.

<!-- # Informal Derivation 

Idea: discretize using Euler and apply DP. Let's pick a uniform grid wih $n$ intervals, so that $h = T/n$.

- Discretized dynamics: 
\begin{align*}
x_{t+1} = x_{t} + h f(x_t, u_t)\enspace .
\end{align*}

- Discretized integral cost: 
\begin{align*}
c(x_n) + \sum_{k=0}^{n-1} c(x_k, u_k) h \enspace .
\end{align*}

Why? 

# Approximation of the Integral Cost

Consider a problem of the form: 
\begin{align*}
\text{find} \enspace z(t_f) = \int_{t_0}^{t_f} c(x(t)) dt \enspace \text{such that} \enspace \dot{x}(t) = f(x(t)) \enspace \text{and} \enspace x(t_0) = x_0 \enspace .
\end{align*}

We can solve this problem by forming an augmented IVP: 
\begin{align*}
\text{find} \enspace \tilde{x}(t_f) \enspace \text{such that} \enspace \begin{bmatrix} \dot{x}(t) \\ \dot{z}(t) \end{bmatrix}= \tilde{f}(\tilde{x}(t)) = \begin{bmatrix}  f(x(t))\\ 
c(x(t))
\end{bmatrix}   
\text{given} \enspace \tilde{x}(t_0) = \begin{bmatrix} x_0 \\ 0 \end{bmatrix}
\end{align*}


# Approximation of the Integral Cost

Using Euler discretization, we would get: 

\begin{align*}
\tilde{x}_{k+1} = \begin{pmatrix}x_k \\ z_k \end{pmatrix} + h \begin{pmatrix}f(x_k) \\ c(x_k) \end{pmatrix}
\end{align*}

Both components can also written non-recursively. The running "cost so far" $z$ is then:

\begin{align*}
z_n = \sum_{k=0}^{n-1} c(x_k) h
\end{align*}

# Discrete-time Discretized OCP 

\begin{align*}
&\text{minimize}\enspace c(x_T) + \sum_{t=0}^{T-1} c(x_t, u_t)h \\
&\text{such that} \enspace x_{t+1} = x_t + hf(x_t, u_t) \enspace t=0, \hdots, T-1 \\
&\text{given} \enspace x_0 
\end{align*}

# Bellman Optimality Conditions on the Discretized-OCP

Substituing the discretized integral cost and dynamics into the discrete Bellman optimality conditions, we get: 
\begin{align*}
\tilde{J}(x, nh) &= c(x) \\
\tilde{J}(x, kh) &= \min_{u \in \mathcal{U}} \left\{c(x,u) + \tilde{J}(x + f(x,u), (k+1)h) \right\}
\end{align*}

We will now write  $\tilde{J}(x + f(x,u), (k+1)h)$ using the Taylor series. 

# Taylor Approximation 

Taking the Taylor series approximation at $(x, kh)$, we get: 
\begin{align*}
\tilde{J}(x+ hf(x,u), kh + h) = \tilde{J}(x, kh) + h D_2 \tilde{J}(x, kh)  + h D_1 \tilde{J}(x, kh) f(x,u) + o(h)
\end{align*}
where $\lim_{h \to 0} o(h)/h = 0$. 

Why? The first-order Taylor approximation of a multivariate function $f(x,y)$ taken at $(a,b)$ and evaluated at $(x + a, y + b)$ is 
\begin{align*}
f(x+a, y + b) &\approx f(a,b) + \begin{pmatrix}D_1 f(a,b) & D_2 f(a,b)\end{pmatrix}\begin{pmatrix}x \\ y\end{pmatrix}\\
&= f(a,b) +D_1 f(a,b) x + D_2 f(a,b) y
\end{align*}

# Taylor + DP 

Plugging the Taylor approximation back in into the DP equations:
\begin{align*}
\tilde{J}(x, kh) &= \min_{u \in \mathcal{U}} \left\{c(x,u) + \tilde{J}(x, kh) + h D_2 \tilde{J}(x, kh)  + h D_1 \tilde{J}(x, kh) f(x,u) + o(h)\right\}\\
\Leftrightarrow 0 &= \min_{u \in \mathcal{U}} \left\{c(x,u) + h D_2 \tilde{J}(x, kh)  + h D_1 \tilde{J}(x, kh) f(x,u) \right\} \enspace .
\end{align*}
Because $J(x, kh)$ doesn't depend on $u$, we can pull it out of the $\min$. Finally, dividing by $h$ and taking the limit as $h \to 0$:
\begin{align*}
\lim_{k\to\infty,h\to 0, kh = t} \tilde{J}(kh,x,t) = J(t,x) \enspace \text{for all } x,t \enspace .
\end{align*}
We then recover the HJB equations:
\begin{align*}
0 &= \min_{u \in \mathcal{U}} \left\{c(x,u) + D_2 J(x, t)  + h D_1 J(x, t) f(x,u) \right\} \enspace .
\end{align*} -->

#

Theorem (Sufficiency).

:     Let $V(x,t)$ be a solution to the PDE: 
\begin{align*}
0 = \min_{u \in \mathcal{U}}\left\{c(x,u) + D_2 V(x,t) + D_1 V(x,t) f(x,u) \right\} \text{for all } x,t \enspace ,
\end{align*}
and boundary condition $V(x, t_f) = c(x)$ for all $x$. Then $V$ is the cost-to-go function $J$ and an optimal policy $\mu(x,t)$ can be obtained by minimizing the expression above given $V(x,t)$. 

::: warning

Potential issue: We assumed that $J$ is differentiable, but this may not be the case, and we may not be able to solve the corresponding HJB equations. But if we happen to do find a solution, analytically, or numerically, then we're in good shape!
::: 

<!-- 
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
\end{align*} -->

<!-- # Control Affine Dynamics 
In the general case, the minimizer in the HJB equation cannot be computed in closed-form. However, this is possible for the class of control affine systems of the form: 
\begin{align*}
f(x, u) \triangleq g(x) + h(x)u \enspace .
\end{align*}

for some given functions $g$ and $h$. Furthermore, we can further restrict our attention to immediate cost functions of the form: 
\begin{align*}
c(x, u) \triangleq l(x) + u^\top R u \enspace .
\end{align*}

Note that the the above setting is more general the the plain LQR one.  -->
<!-- 
# Infinite-Horizon HJB under Control Affine Assumptions

The minimizer of the HJB equation can be computed in closed-form for the class of "control-affine" systems, ie: 
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
\end{align*} -->

<!-- # LQR in Continuous-Time 

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
\end{align*} -->

# 

## Stochastic Optimal Control via and Path Integral


# Problem formulation 

The problem formulation is still in continuous-time, but we now add noise: ie the dynamics are described by stochastic differential equations (SDEs) rather than ODEs. 

We also make two important assumptions: 

- Control-affine dynamics
- Quadratic cost

# SDE Dynamics

The PI framework assumes that we have control-affine dynamics: the system has a linear relationship on the controls but can be nonlinear elsewhere:
\begin{align*}
dX(t) = \underbrace{f(X(t), t)dt}_{\text{drift}} + \underbrace{g(X(t), t)\left(u(X(t), t)dt + dW(t) \right)}_{\text{diffusion}}
\end{align*}

- The "drift" term is also sometimes referred to as the "passive dynamics" of the system (eg. gravity).
- $dW(t)$ is Gaussian noise with $\mathbb{E}\left[dW(t)\right] = 0$


# Euler-Maruyama

The Euler discretization counterpart for SDEs is the "Euler-Maruyama" method, which for an SDE
\begin{align*}
dX(t) = \underbrace{\mu(X(t), t))dt}_{\text{drift}} + \underbrace{\sigma(X(t), t) dW(t)}_{\text{diffusion}} \enspace ,
\end{align*}
we compute the random sequence:
\begin{align*}
X_{k+1} = X_k + \mu(X_k, kh)h + \sigma(X_k, kh) \Delta W_k \enspace \text{where} \enspace \Delta W_k \sim \mathcal{N}(0, \sqrt{h}) \enspace .
\end{align*}

for a fixed discretization of the interval $[0, T]$ into $n$ bins of width $h = T/n$. 

# Time-Discretization

Consider our control-affine system:
\begin{align*}
dX(t) = f(X(t), t)dt + g(X(t), t)\left(u(X(t), t)dt + dW(t) \right) \enspace ,
\end{align*}

Furthermore, let's be a bit more precise and assume that $x\in \mathbb{R}^m$, $u \in \mathbb{R}^n$ so that $g: \in \mathbb{R}^{m} \times \mathbb{R} \to \mathbb{R}^{m\times n}$ is a **control matrix** and $f: \in \mathbb{R}^m \to \mathbb{R}^m$.
The Euler-Maruyma discretization is: 
\begin{align*}
x_{k+1} = x_k + f_k h + G_k\left(u_k h + \Delta w_k\right),\enspace \Delta W_k \sim \mathcal{N}\left(0, \sqrt{h}\right) \enspace .
\end{align*}

# Gaussian Process
\begin{align*}
x_{k+1} = x_k + f_k h + G_k\left(u_k h + \Delta w_k\right),\enspace \Delta W_k \sim \mathcal{N}\left(0, \sqrt{h}\right) \enspace .
\end{align*}
The above is a discrete-time Markov Decision Process whose transition probability function is given by:
\begin{align*}
p(x_{k+1} | x_{k}, u_k) = \mathcal{N}\left(x_k + f_kh + G_k u_k h, G_k \Sigma G_k^\top \right)
\end{align*}
where $\Sigma$ is the covariance matrix of the Wiener process. To see this, remember the "reparameterization" properties of the Normal distribution, ie. if $X \sim \mathcal{N}(\mu, \Sigma)$ with $\mu \in \mathbb{R}^n, \Sigma \in \mathbb{R}^{n\times n}$ and under the affine transformation: 
$Y = a + BX$ then the transformed variable is distributed as $Y \sim \mathcal{N}\left( a + B \mu, B\Sigma B^\top\right)$.

<!-- # Discrete-time Bellman Optimality Equations (stochastic)

Bellman's optimality principle in discrete time also holds when the dynamics are stochastic (this is the usual RL setup) when we want to $\text{minimize}\enspace c_T(x_T) + \mathbb{E}\left[\sum_{t=1}^T c_t(X_t, U_t) \right]$. The cost-to-go function can be computed by backward induction with:
\begin{align*}
J_T(x_T) &\triangleq c_T(x_T) \\
J_t(x_t) &\triangleq \min_{u_t \in \mathcal{U}(x_t)} \left\{ c_t(x_t, u_t) +  \mathbb{E}\left[J_{t+1}(X_{t+1}) \,\middle|\, U_t = u_t\right]\right\} \enspace t=1, \hdots, T-1 .
\end{align*} -->

# Discrete-time MDP Counterpart
Having a discrete-time Markov process, we can define an approximate MDP counterpart:
\begin{align*}
J(x_T, T) &\triangleq c_T(x_T) \\
J(x_t, t) &\triangleq \min_{u_t \in \mathcal{U}(x_t)} \left\{ c_t(x_t, u_t) +  \mathbb{E}\left[J(X_{t+1}, t+1) \,\middle|\, U_t = u_t\right]\right\} .
\end{align*}
<!-- Furthermore, the above expectation is taken with respect to the Gaussian transition function:
\begin{align*}
p(x_{k+1} | x_{k}, u_k) = \mathcal{N}\left(x_k + f_kh + G_k u_k h, G_k^\top \Sigma G_k \right) \enspace .
\end{align*} -->
The expectation is now taken under the Gaussian defined above and the cost function is assumed to be quadratic in the controls:
\begin{align*}
c_t(x_t,u_t) \triangleq l(x, t) + u^\top R_t u \enspace .
\end{align*} 

where $l$ can be a nonlinear function.

# HJB Equation for PI Control

If we take the second-order Taylor expansion of $J$, replace it back into the discrete-time Bellman's equations and take the limit of the step size to $0$, we get an HJB equation of the form: 

\begin{align*}
D_2 J(x, t) &= \\
&l(x,t) + \min_{u \in \mathcal{U}} \left( u^\top R_t u + D_1 J(x, t)(f_t + G_t u) + \frac{1}{2} \text{tr}\left(   D^2_1 J(x, t) G_t \Sigma G_t^\top\right)\right) \enspace ,
\end{align*}
Because of the control-affine assumption, we can solve for $u$ directly and get that the minimizing action $u_t^\star$ is: 
\begin{align*}
u_t^\star = -R^{-1} G_t^\top \left(D_1 J(x, t)\right)^\top
\end{align*}
<!-- # PI HJB: Substitution of Optimal Controls

If we substitute the optimal control into the HJB, we get: 
\begin{align*}
D_2 J(x, t) &= \\
&l_t(x) +  D_1 J(x, t) f_t - \frac{1}{2} D_1 J(x,t) G_t R^{-1} G_t^\top (D_1 J(x, t))^\top+ \frac{1}{2} \text{tr}\left(D^2_1 J(x, t) \Sigma_x  \right)
\end{align*} -->
But how can we solve this PDE?

# Exponential Transformation 

We are going to transform the above PDE by setting: 
\begin{align*}
J(x, t) = - \lambda \log \Psi(x,t) \enspace ,
\end{align*}
for some function $\Psi$ satisfying: 
\begin{align*}
- D_2 \Psi(x,t) &= \\
&-\frac{1}{\lambda}l(x,t)\Psi(x,t) +  D_1 \Psi(x,t) f_t + \frac{1}{2} \text{tr}\left( D_1^2 \Psi(x,t) G_t \Sigma G_t^\top \right)
\end{align*}
This PDE is special: it's called the Kolmogorov backward PDE, a second-order **linear** PDE. 

# Feynman-Kac 

The Feynman-Kac theorem allows us to solve such PDEs (Kolmogorov) numerically, by showing that their solution is that of an expectation (an integral) over paths.  

Theorem (informal)

: Feynman-Kac (informal) If $X(t)$ satisfies an SDE of the form $dX(t) = f(X(t), t)dt + G(X(t))dW(t)$ then:

\begin{align*}
\Psi(x, t) = \mathbb{E}\left[ \exp\left( -\frac{1}{\lambda}c_T(X(T)) - \frac{1}{\lambda}\int_{t}^{T} l(X(t), t) dt\right) \right]
\end{align*}

**iff** $\Psi$ satisfies the Backward-Kolmogorov PDE: 
\begin{align*}
- D_2 \Psi(x,t) &= \\
&-\frac{1}{\lambda}l(x,t)\Psi(x,t) +  D_1 \Psi(x,t) f_t + \frac{1}{2} \text{tr}\left( D_1^2 \Psi(x,t) G_t \Sigma G_t^\top \right)
\end{align*}

# Recap 

1. We posed the stochastic optimal control problem under the assumptions of control-affine SDE dynamics + quadratic cost on the controls
2. The corresponding SOCP can be solved via the HJB equation, a PDE
3. To solve the PDE, we use the exponetial transform: this gives us a **linear PDE**
4. This linear PDE happens to be the Backward-Kolmogorov PDE
5. The Backward-Kolmogorov PDE can be solved numerically using the Monte-Carlo method using the Feyman-Kac theorem 

