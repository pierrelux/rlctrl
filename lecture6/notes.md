---
title: "Reinforcement Learning and Optimal Control"
author: [Pierre-Luc Bacon]
date: "2017-02-20"
subject: "Reinforcement learning, optimal control"
keywords: [reinforcement learning, optimal control]
subtitle: "IFT6760C, Fall 2021"
lang: "en"
header-includes: |
    \usepackage{mathtools}
    \usepackage{awesomebox}
    \usepackage{xcolor}
    \makeatletter
    \def\mathcolor#1#{\@mathcolor{#1}}
    \def\@mathcolor#1#2#3{%
    \protect\leavevmode
    \begingroup
        \color#1{#2}#3%
    \endgroup
    }
    \makeatother
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]
...

# Bellman optimality operator

The Bellman optimality operator that we worked with so far is of the form:
\begin{align*}
Lv \triangleq \max_{d \in \mathcal{D}^{MD}}\left\{ r_d + \gamma P_d v\right\} \enspace .
\end{align*}

Or in component form: 
\begin{align*}
(Lv)(s) = \max_{a \in \mathcal{A}(s)} \left\{ r(s,a) + \gamma \sum_{j\in\mathcal{S}}p(j|s,a) v(j)\right\}
\end{align*}

# Smoothed Bellman operator

The presence of the *max* in $L$ can be problematic because of nthe ondifferentiability.

It is therefore convenient to use the following smoothed operator introduced by Rust (1988):
\begin{align*}
(L_\tau v)(s) \triangleq \tau  \log \sum_{a \in \mathcal{A}(s)} \exp \left((1/\tau)\left(r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j) \right)\right) \enspace .
\end{align*}

The temperature parameter $\tau$ allows us to control the approximation error of $L$. We can show in fact that $\lim_{\tau \to 0} L_\tau v = L v$.
Furthermore, we will see that $v_\gamma^\star$ can also be recovered as a fixed point, in the limit of $\tau \to 0$.

# Approximate operator 

 Let $L_\theta: \mathcal{V} \to \mathcal{V}$ be an approximate Bellman operator indexed by $\theta$, and $v^\star_{\gamma,\theta}$ the corresponding fixed point. 

Theorem (lemma 2.1 of Rust 1994)

:   Let $\{L_\theta\}$ be a family  of *contraction mappings* converging pointwise, that is
$\lim_{\theta\to\infty} L_\theta v = L v, \enspace \forall v\in \mathcal{V}$,
    then:

    1. $\|v^\star_{\gamma,\theta} - v^\star_\gamma\| \leq \frac{\| L_\theta v^\star_\gamma - Lv^\star_\gamma\|}{(1 - \gamma)}$
    2. $\lim_{\theta \to \infty} \|v^\star_{\gamma,\theta} - v^\star_\gamma\| = 0$

# Proof

(Usual trick: add and subtract + triangle inequality)

\begin{align*}
\|v^\star_{\gamma,\theta} - v^\star_\gamma\| &= \|L_\theta v^\star_{\gamma,\theta} - L v^\star_\gamma \|\\
&\leq\|L_\theta v^\star_{\gamma,\theta} - L_\theta v^\star_\gamma\| + \|L_\theta v^\star_\gamma - L v^\star_\gamma \|\\
&\leq \gamma \|v^\star_{\gamma,\theta} - v^\star_\gamma\| + \|L_\theta v^\star_\gamma - L v^\star_\gamma \| \enspace .
\end{align*}

Therefore: 
\begin{align*}
\|v^\star_{\gamma,\theta} - v^\star_\gamma\| \leq \frac{\| L_\theta v^\star_\gamma - Lv^\star_\gamma\|}{(1 - \gamma)} \enspace .
\end{align*}

# Application to smoothed Bellman operator

Because $\{L_\tau\}$ is a family of contraction mappings converging pointwise as $\tau \to 0$, then we also have that: 

1. $\|v^\star_{\gamma,\tau} - v^\star_\gamma\| \leq \frac{\| L_\tau v^\star_\gamma - Lv^\star_\gamma\|}{(1 - \gamma)}$
2. $\lim_{\tau \to 0} \|v^\star_{\gamma,\tau} - v^\star_\gamma\| = 0$

# Successive Approximation

Because $L_\tau$ is a $\gamma-contraction$, we can apply the method of successive approximation aka. value iteration as-is.


Given: $v^{(0)}$, and some tolerance $\epsilon > 0$. 

While $\| v^{(k+1)} - v^{(k)} \| \leq \epsilon (1 - \gamma)/2\gamma$:

- Compute for each $s\in\mathcal{S}$: 

$v^{(k+1)}(s) = \tau \log \sum_{a\in\mathcal{A}(s)} \exp \left((1/\tau) \left( r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v^{(k)}(j)\right)\right)$

Return: 

- $d_\tau(a|s) = \frac{\exp \left((1/\tau) \left( r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v^{(k)}(j)\right)\right) }{\sum_{a' \in \mathcal{A}(s)} \exp \left((1/\tau) \left( r(s,a') + \gamma \sum_{j\in\mathcal{S}} p(j|s,a') v^{(k)}(j)\right)\right)}$

# Newton-Kantorovich 

Rather than solving $L_\tau v = v$, we will instead work with the operator $B_\tau v \triangleq L_\tau v - v$ and solve the nonlinear system of equations $B_\tau v = 0$.

- Given $v^{(0)}\in \mathcal{V}, \epsilon > 0$
- Repeat:
    - Find $\Delta^{(k)}$ by solving for $\Delta$ in $B'_\tau(v^{(k)}) \Delta = B_\tau(v^{(k)})$
    - Set $v^{(k+1)} = v^{(k)} - \Delta^{(k)}$
    - Terminate if $\|v^{(k+1)} - v^{(k)}\| \leq \epsilon$
- Return $v^{(k)}$

This is essentially ``policy iteration'' for the smooth Bellman optimality equations.

# Explicit update

The main update in the above algorithm reads as:
\begin{align*}
v^{(k+1)} &= v^{(k)} - \left(B'_\tau v^{(k)}\right)^{-1} B_\tau v^{(k)} = v^{(k)} - \left(I - L'_\tau v^{(k)}\right)^{-1} (I - L_\tau v^{(k)}) \enspace .
\end{align*}
Here, $L'$ denotes the Gâteaux derivative (G-derivative) of $L$ at $v^{(k)}$. That is, the linear operator $L'v: \mathcal{V} \to \mathcal{V}$: 
\begin{align*}
(L'_\tau v)u  \triangleq \lim_{t\to 0} \frac{L_\tau(v + tu) - L_\tau v}{t}
\end{align*}

::: note
Remember that the above reads as $L'_\tau(v)(u)$: a mapping which takes $v$ as input and returns a mapping which we then evaluate at $u$. $L'_\tau(v)$ is the returned mapping. $L'_\tau(v)(u)$ is the value of the returned mapping evaluated at $u$.
:::

# Derivative of the smoothed Bellman operator

The Gâteaux derivative of $L_\tau$ is given by: 
\begin{align*}
((L_\tau'v)u)(s) &= \gamma \sum_{a \in \mathcal{A}(s)} d_\tau(a|s) \sum_{j\in\mathcal{S}} p(j|s,a)u(s') \\
d_\tau(a|s) &= \frac{\exp \left((1/\tau) \left( r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j)\right)\right) }{\sum_{a' \in \mathcal{A}(s)} \exp \left((1/\tau) \left( r(s,a') + \gamma \sum_{j\in\mathcal{S}} p(j|s,a') v(j)\right)\right)}
\end{align*}

In physics, $d_\tau$ is called the Boltzmann distribution.

# Newton-Kantorovich (NK) Theorem

If $L_\tau$ has continuous first and second derivatives such that $\|L_\tau''v\| \leq c$ for any $v \in \mathcal{V}$, then given any initial guess $v_0 \in \mathcal{V}$ such that: 
\begin{align*}
\|I - L_\tau v_0 \|= \eta \leq \frac{(1 - \gamma)^2}{2c} \enspace ,
\end{align*}
then:
\begin{align*}
\|v^{(k)} - v^\star_{\gamma, \tau}\| \leq \frac{1}{2^k} \left(\frac{2c\eta}{(1 - \gamma)^2} \right)^{2^k}\frac{(1 - \gamma)^2}{c} \enspace .
\end{align*}
This implies that: 
\begin{align*}
\|v^{(k+1)} - v^\star_{\gamma,\tau}\| \leq c' \| v^{(k)} - v^\star_{\gamma,\tau}\|^2 \enspace ,
\end{align*}
for some $c'$. Therefore, if $v_0$ is chosen appropriately, we can achieve a quadratic rate of convergence.

# Global convergence

As opposed to PI for discrete state and action spaces and the usual Bellman optimality equations, here we can no longer leverage the argument that the space of decision rules is finite. In fact, our decision rules here are Markov randomized and that set is infinite. 

Because of the convergence of NK is local, we can enlarge the region of attraction by first running successive approximation (VI) until we're close enough to the region of attraction, then switch to NK. 

Polyalgorithm: 

1. Run VI until close enough to region of attraction
2. Switch to NK

# Neumann series expansion 

Remember that $L'_\tau v$ is a linear operator that belongs in the space of all linear operators from $\mathcal{V}$ to $\mathcal{V}$. Therefore, we can establish existence of an inverse based on its spectral radius. 

Theorem 

:   Let $0 \leq \gamma < 1$, then $\sigma([L_\tau' v)]) <1$ and $(I - L'_\tau v)^{-1}$ exists for all $v\in\mathcal{V}$. Furthermore, $(I - L'_\tau v)^{-1} = \sum_{t=0}^\infty \left(L'_\tau v\right)^t$

# "Modified" Newton-Kantorovich

We can develop a "modifed" counterpart to the above procedure that mimics "modifed policy iteration" where we only take a few terms in the Neumann series expansion. 

- Given $v^{(0)}\in \mathcal{V}, \epsilon > 0$, truncation $n$, initial guess $\tilde{\Delta}_0$
- Repeat:
    - Set $\tilde{\Delta}^{(1)} = \tilde{\Delta}_0$
    - Repeat from $i=1, \hdots, n-1$
        - $\tilde{\Delta}^{(i+1)}  = B_\tau v^{(k)} + (L'_\tau v^{(k)})\tilde{\Delta}^{(i)}\enspace .$ 
    - Let $\Delta^{(k)} = \tilde{\Delta}^{(n)}$
    - Set $v^{(k+1)} = v^{(k)} - \Delta^{(k)}$
    - Terminate if $\|v^{(k+1)} - v^{(k)}\| \leq \epsilon$
- Return $v^{(k)}$

# Important pratical implication 

::: note
Remember: $L'_\tau v^{(k)})$ is the Gâteaux derivative. Therefore, computing  $(L'_\tau v^{(k)})\tilde{\Delta}^{(i)}$ in practice amounts to evaluating a Jacobian-vector product (jvp) JVPs and VJPs are the fundamental building blocks of automatic differentiation (AD) in machine learning. They allows to implement so-called ``matrix-free'' algorithms.

Using JAX for example, you could compute $(L'_\tau v^{(k)})\tilde{\Delta}^{(i)}$ with ``jax.linearize`` without forming any Jacobian matrix.
:::

# 

Linear programming formulation

#

Theorem 6.2.2a showed that if $v \geq Lv$ for some $v \in \mathcal{V}$ then it must be that $v \geq v^\star_\gamma$: ie $v$ is an upper bound on $v^\star_\gamma$.

Definition 

:   $v\in \mathcal{V}$ is said to be $\gamma$-superharmonic if: 
\begin{align*}
v(s) \geq r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j)\enspace , \forall s \in \mathcal{S}, a \in \mathcal{A}(s)
\end{align*}

Theorem

:   $v^\star_\gamma$ is the smallest $\gamma$-superharmonic vector

Proof

:   $v^\star_\gamma$ satisfies the Bellman optimality equations: 
\begin{align*}
v^\star_\gamma(s) = \max_{a\in\mathcal{A}(s)}\left\{ r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j) \right\}, \enspace s \in \mathcal{S}
\end{align*}

Let $a^\star_s$ be a maximizer of the above. Therefore: 
\begin{align*}
v^\star_\gamma(s) &= r(s,a^\star_s) + \gamma \sum_{j\in\mathcal{S}}p(j|s,a^\star_s)v(j) \\
&\geq r(s,a) + \gamma \sum_{j\in\mathcal{S}}p(j|s,a) v(j) \enspace \forall s \in \mathcal{S}, a\in \mathcal{A}(s)
\end{align*}

# Proof

Let $v \in \mathcal{V}$ be $\gamma$-superharmonic. Then: 
\begin{align*}
v \geq r_d + \gamma P_d v, \enspace \forall d \in \mathcal{D}^{MD}
\end{align*}
(just the definition in vector form)
Re-arranging: 
\begin{align*}
(I - \gamma P_d)v \geq r_d \enspace .
\end{align*}
Because $(I - \gamma P_d)^{-1}$ is a positive operator (see last lecture), then: 
\begin{align*}
v \geq \left(I - \gamma P_d\right)^{-1} r_d \triangleq v_{d^\infty}, \enspace \forall d \in \mathcal{D}^{MD} \enspace .
\end{align*}
Therefore, $v \geq v_{\pi}$ for any $\pi \in \Pi^{MD}$ (including optimal policies), and $v \geq v^\star_\gamma = \max_{\pi \in \Pi^{MD}} v_\pi$


# LP formulation 

Therefore, in the set of all superharmonic vectors, $v^\star_\gamma$ is the smallest. 


This is the basis for our LP formulation: let's search the set of $\gamma$-superharmonic vectors and find the smallest. 

## Primal LP

Let $\alpha \in \mathbb{R}^{|\mathcal{S}|}, \sum_{i \in \mathcal{S}} \alpha(i) = 1$, 

\begin{align*}
\text{minimize} \enspace &\sum_{i\in\mathcal{S}} \alpha(i) v(i) \\
\text{subject to}\enspace &v(s) - \gamma \sum_{j \in \mathcal{S}} p(j|s,a) v(j) \geq r(s,a),\enspace \forall s\in\mathcal{S}, a \in \mathcal{A}(s)
\end{align*}

# Dual LP 

\begin{align*}
&\text{maximize} \enspace \sum_{s \in \mathcal{S}} \sum_{a \in \mathcal{A}(s)} r(s,a)x(s,a)\\
&\text{subject to}\enspace \sum_{a \in \mathcal{A}(j)}x(s,a) - \gamma \sum_{s\in \mathcal{S}}\sum_{a \in \mathcal{A}(s)} p(j|s,a)x(s,a) = \alpha(j) 
\end{align*}

# Policies

Theorem (6.9.1 in Puterman)

:   Let $d \in \mathcal{D}^{MR}$ and for any $s \in \mathcal{S}$, $a \in \mathcal{A}(s)$, and define: 
\begin{align*}
x_d(s,a) \triangleq \sum_{i\in \mathcal{S}} \alpha(i)\sum_{t=1}^\infty \gamma^{(t-1)} P_{d^\infty}(S_t = s, A_t = a | S_1 = i)
\end{align*}

1. $x_d$ is a feasible solution to the dual problem
2. we can derive a stationary policy $d_x^\infty$ from $x$ with: 
\begin{align*}
d_x^\infty(a | s) = \frac{x(s,a)}{\sum_{a'\in \mathcal{A}(s)}x(s,a')}
\end{align*}

# Interpretation 

$x(s,a)$ is the total discounted probability joint probability that starting from the initial state $\alpha$, the system is in state $s$ taking action $a$.
