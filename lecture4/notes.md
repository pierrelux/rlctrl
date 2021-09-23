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

# Overview

<!-- - Next year: lemma 6.1.2 about (I - gamma P_d) being a positive operator -->
- The Bellman optimality operator is a contraction
- Bounds on value iteration
- Derivative, Spivak notation

# Optimality equations

Today, we will see that the nonlinear equations:
\begin{align*}
v(s) = \max_{a \in \mathcal{A}(s)} r(s,a) + \sum_{j\in\mathcal{S}} p(j|s,a) v(j) \enspace ,
\end{align*}
called the **optimality equations** have a unique solution, and that solution coincides with $v^\star_\gamma$ -- the value of the MDP. In vector notation: 
\begin{align*}
v = \max_{d \in \mathcal{D}^{MD}} r_d + \gamma P_d v = L v \enspace ,
\end{align*}
where $L$ is the Bellman optimality operator. We will show that:

1. $L$ is a contraction
2. $v^\star_\gamma$ is the unique fixed point of $L$. 

# The Bellman optimality operator is a contraction

Theorem 

:   If $\gamma \in [0, 1)$, then $L$ is a contraction mapping. 


Proof 

As usual, we assume that $\mathcal{S}$ is discrete and $L: \mathcal{V} \to \mathcal{V}$. We want to show that there exists a $\lambda \in [0, 1)$ such that $\|Lv - Lu \| \leq \lambda \|v - u\|, \forall u,v \in \mathcal{V}$. 
<!-- We show this for the l$\infty$ norm, ie: $\| A \|_\infty \triangleq \max_{1\leq i\leq m} \sum_{j=1}^n |A_{ij}|$ where $A: \mathbb{R}^n \to \mathbb{R}^m$. -->

Assume that $Lv(s) \geq Lu(s)$:
\begin{align*}
&0 \leq Lv(s) - Lu(s) \\
&= \max_{a\in\mathcal{A}(s)} \left\{r(s, a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j)\right\} - \max_{a \in\mathcal{A}(s)}\left\{r(s,a) - \gamma \sum_{s\in\mathcal{S}}p(j|s,a) u(j)\right\}\\
\end{align*}

# Proof

Now let $a^\star_s \in \arg\max_{a \in \mathcal{A}(s)} \left\{r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j) \right\}$.
\begin{align*}
&\leq r(s, a^\star_s) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a^\star_s) v(j) - r(s,a^\star_s) - \gamma \sum_{s\in\mathcal{S}} p(j|s,a^\star_s)u(j)\\
&= \gamma \sum_{j\in\mathcal{S}}p(j|s,a^\star_s)\left(v(j) - u(j) \right) \leq \gamma \sum_{j\in\mathcal{A}(s)} p(j|s,a^\star_s) \underbrace{\| v- u\|}_{\max_{i\in\mathcal{S}}|v_i - u_i|} = \gamma \|v - u\| \enspace .
\end{align*}

Therefore: 
\begin{align*}
|Lv(s) - Lu(s)| \leq \gamma \| v -u \| \\
\Rightarrow \max_{s \in \mathcal{S}} |Lv(s) - Lu(s)| \triangleq \| Lv - Lu\| \leq \gamma \| v -u \| \enspace .
\end{align*}

We can repeat the same argument for $Lu(s) \geq Lv(s)$.


# Bellman equations: existence of unique solution

Theorem 

:   Let $\gamma \in [0, 1)$ with $\mathcal{S}$ finite or countable and bounded reward function: 

1. There exists a unique $v^\star \in \mathcal{V}$ such that $Lv^\star = v^\star$.
2. This $v^\star$ is equal to $v^\star_\gamma$, ie: $v^\star = v^\star_\gamma = \max_{\pi \in \Pi^{MR}} v_{\pi,\gamma}$

Proof

- Part 1. follows directly from the fact that $L$ is a $\gamma$-contraction under the sup norm.
- Part 2. Doesn't come for free! In fact, we need to first  (thm. 6.2.2 in Puterman) that if there exists a $v \in \mathcal{V}$ such that:
    - when $v \geq Lv$ then $v \geq v_\gamma^\star$
    - when $v \leq Lv$ then $v \leq v_\gamma^\star$
    - then if $v = Lv$, this $v$ must be the only element of $\mathcal{V}$ with this property and that $v = v^\star_\gamma$. 

# Recap

Consequence: 

- We now know that the Bellman equations have a unique solution. 
- The solution to the Bellman equations gives us the value of the MDP, ie: $v^\star_\gamma$. 

What's next: 

- How to find optimal policies
- How to find the solution to the Bellman equations numerically. 

# Optimal policies

::: warning
So far, we have shown that $v^\star_\gamma$ exists and can be found as the solution to the Bellman equations. What we obtain out of this nonlinear system of equations is $v^\star_\gamma$: not an optimal policy just yet.
:::

::: note
In the following, we will show that there exists a **stationary deterministic** optimal policy.
:::

# Optimal policies

Theorem

:   Let $\mathcal{S}$ be discrete, and assume that the sup in $\mathcal{L}v = \sup_{d \in \mathcal{D}^{MD}} \left\{ r_d  + \gamma P_d v\right\}$ is attained for all $v\in \mathcal{V}$, then:

1. There exists a conserving decision rule $d^\star \in \mathcal{D}^{MD}$, ie: 
\begin{align*}
L_{d^\star}v_\gamma^\star = r_{d^\star} + \gamma P_{d^\star} v^\star_\gamma = v^\star_\gamma \enspace .
\end{align*}
and the stationary policy $(d^\star)^\infty$ is optimal. 
2. $v^\star_\gamma = \sup_{\pi \in \Pi^{MR}} v_{\pi, \gamma} = \sup_{d\in\mathcal{D}^{MD}} v_{d^\infty, \gamma}$

Proof

:   Since $v^\star_\gamma$ is the unique solution of $Lv = v$, then: 
\begin{align*}
L_{d^\star}v_\gamma^\star = r_{d^\star} + \gamma P_{d^\star} v^\star_\gamma = v^\star_\gamma = Lv^\star_\gamma 
\end{align*}

# Proof
By the application of Neumann's lemma for policy evaluation(last lecture), we have that for any $d \in \mathcal{D}^{MD}$, $v_{d^\infty, \gamma}$ is the solution to:
\begin{align*}
v_{d^\infty, \gamma} = L_{d}v_{d^\infty, \gamma} = r_{d} + \gamma P_{d^\infty, \gamma} = \left( I - \gamma P_d \right)^{-1} r_d \enspace .
\end{align*}

Going back to our theorem:
\begin{align*}
v^\star_\gamma = Lv^\star_\gamma = \underbrace{r_{d^\star} + \gamma P_{d^\star} v_\gamma^\star = L_{d^\star} v^\star_\gamma}_\text{because conserving} \enspace .
\end{align*}

Therefore:
\begin{align*}
v^\star_\gamma = r_{d^\star} + \gamma P_{d^\star} v^\star_\gamma = v_{(d^\star)^\infty, \gamma} \enspace .
\end{align*}

# Important thing to remember

::: note

The important consequence of the above is that we can now say that: 
$v^\star_\gamma = \sup_{\pi \in \Pi^{MR}} v_{\pi, \gamma} = \sup_{d\in\mathcal{D}^{MD}} v_{d^\infty, \gamma}$.

This is a big deal because we went from searching over the space of nonstationary history-dependent randomized policies to only searching over the space of Markov deterministic decision rules, resulting in stationary deterministic Markovian policies.

::: 


# Practical consequence

If we identified $v^\star_\gamma$, then we can derive an optimal stationary policy $(d^\star)^\infty$ by taking:
\begin{align*}
d^\star(s) \in \arg\max_{a \in \mathcal{A}(s)} \left\{ r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v^\star_\gamma(j) \right\}
\end{align*}

#

Numerical methods

# Value iteration

This algorithm corresponds to the **method of successive approximation**, which comes directly from the constructive proof in Banach fixed point theorem. 

Given: $v^{(0)}$, and some tolerance $\epsilon > 0$. 

While $\| v^{(k+1)} - v^{(k)} \| \leq \epsilon (1 - \gamma)/2\gamma$:

- Compute for each $s\in\mathcal{S}$: $v^{(k+1)}(s) = \max_{a\in\mathcal{A}(s)} \left\{ r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v^{(k)}(j)\right\}$

Return: 

- $d_\epsilon(s) \in \arg\max_{a\in\mathcal{A}(s)} \left\{r(s,a) + \gamma \sum_{j\in\mathcal{S}}p(j|s,a) v^{(k+1)}(j) \right\}$


# Termination criterion

Theorem 

:   Upon termination of value iteration with the above criterion, the last iterate is within $\epsilon/2$ of the optimal value function, ie: $\|v^{(k+1}) - v^\star_\gamma\| < \epsilon/2$.

Proof 

:   \begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v_\gamma^\star\| \leq \|v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)}\| + \|v^{(k+1)} - v^\star_\gamma \| \enspace.
\end{align*}

Looking at the first term: 
\begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)}\| &= \| L_{d_\epsilon} v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)} \|\\
&\leq \| L_{d_\epsilon} v_{(d_\epsilon)^\infty, \gamma} - Lv^{(k+1)} \| + \| Lv^{(k+1)} - v^{(k+1)} \|\\
&= \| L_{d_\epsilon} v_{(d_\epsilon)^\infty, \gamma} - L_{\mathcolor{magenta}{d_\epsilon}}v^{(k+1)} \| + \| Lv^{(k+1)} - \mathcolor{cyan}{L}v^{(k)} \|\\
&\mathcolor{red}{\leq} \gamma \| v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)}\| + \gamma \| v^{(k+1)} - v^{(k)} \|
\end{align*}

# Proof

Re-arranging the terms: 
\begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)}\| \leq \frac{\gamma}{1 - \gamma} \|v^{(k+1)} - v^{(k)}\|
\end{align*}

We can also apply the same exact step to the second term and get: 
\begin{align*}
\|v^{(k+1)} - v^\star_\gamma \| \leq \frac{\gamma}{1 - \gamma} \|v^{(k+1)} - v^{(k)}\|
\end{align*}

Therefore, since:
\begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v_\gamma^\star\| \leq \|v_{(d_\epsilon)^\infty, \gamma} - v^{(k+1)}\| + \|v^{(k+1)} - v^\star_\gamma \| \enspace.
\end{align*}
then:
\begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v_\gamma^\star\| \leq \frac{\gamma}{1 - \gamma} \|v^{(k+1)} - v^{(k)}\| + \frac{\gamma}{1 - \gamma} \|v^{(k+1)} - v^{(k)}\| \enspace.
\end{align*}

# Proof

By our termination criterion, we have $\|v^{(k+1)} - v^{(k)} \| < \epsilon (1 - \gamma)/2\gamma$, therefore: 
\begin{align*}
\|v_{(d_\epsilon)^\infty, \gamma} - v_\gamma^\star\| \leq \epsilon \enspace.
\end{align*}

#

Using Newton's method

# Differentiation as Linearization

Definition (Differentiability). \label{derivative}

:   A function $f: \mathbb{R}^n \to \mathbb{R}^m$ is said to be differentiable at $x \in \mathbb{R}^n$  if there exists a linear map 
$\lambda: \mathbb{R}^n \to \mathbb{R}^m$ such that: 
 \begin{align*}
 \lim_{h\to 0} \frac{\|f(x + h) - f(x) - \lambda(h)\|}{\|h\|} = 0 \enspace ,
 \end{align*}
 where $h \in \mathbb{R}^n$. 

 We can show that if $f$ is differentiable at $x$, then the linear map $\lambda$ is unique. 

# Jacobian 

Definition (Jacobian matrix). 

: The Jacobian matrix of $f: \mathbb{R}^n \to \mathbb{R}^m$ at $x \in \mathbb{R}^n$ is the matrix of $Df(x)$ under the standard bases for $\mathbb{R}^n$ and $\mathbb{R}^m$. We denote this matrix by $f'(x) \in \mathbb{R}^{m \times n}$ which we obtain by concatenating the values of $Df(x)(e_i), i=1,\hdots,n$ as columns: $f'(x) \triangleq [ Df(x)(e_i), \hdots, Df(x)(e_n)]$.

# Chain rule

Lemma (Chain rule). \label{chain-rule}

:   If $g: \mathbb{R}^k \to \mathbb{R}^n$ is differentiable at $x\in\mathbb{R}^k$ and $f:\mathbb{R}^n \to \mathbb{R}^m$ is differentiable at $g(x)$, then $f \circ g: \mathbb{R}^n \to \mathbb{R}^m$ is differentiable at $x$ and 
\begin{align*}
D(f\circ g)(x) = D f(g(x)) \circ Dg(x) \enspace,
\end{align*}
and the matrix of $D(f \circ g)(x)$ is given by: 
\begin{align*}
[ D(f \circ g)(x)] = [Df(g(x))] [Dg(x)] \enspace .
\end{align*}

# Directional derivative 

Definition (Directional derivative).

:    Let $f: \mathbb{R}^n \to \mathbb{R}$, the directional derivative of $f$ at $x \in \mathbb{R}^n$ in the direction of $v \in \mathbb{R}^n$ is the limit: 
\begin{align*}
D_v f(x) \triangleq \lim_{t\to 0} \frac{f(x + tv) - f(x)}{t}
\end{align*}
where $t \in \mathbb{R}$.

If the derivative of $f$ at $x$ exists, the directional directive is given by the value of the linear mapping obtained at this point and evaluated at $v$, ie: $D_v f(x) = D f(x)(v)$. Using the matrix of $Df(x)$ -- the Jacobian -- we also have that is given by the Jacobian-vector product $D_v f(x) = [Df(x)] v$ or $v^\top \nabla f(x)$ using the gradient notation. 