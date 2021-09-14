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

- Infinite-horizon discounted case as random finite horizon 
- Markov policies are enough
- Vector notation
- Policy evaluation
    - Policy evaluation operator
    - Application of Neumann's lemma
- Bellman equations 
    - Bellman optimality equations
- Markov deterministic policies are enough
- v-improving and conserving decision rules


# Infinite Horizon Discounted as Randomized Finite Horizon

Theorem

:    Let $v_{\pi,N}$ denote the value of a policy $\pi$ in an MDP with a random finite horizon $N$ drawn from a geometric
distribution with parameter $\gamma$, then:

    \begin{align*}
    v_{\pi, N}(s) = v_{\pi,\gamma}(s) \enspace \forall s \in \mathcal{S} \enspace ,
    \end{align*}
    where $v_{\pi, \gamma}$ is the value of the policy $\pi$ under the expected total discounted reward criterion with discount factor
    $\gamma$.


# Proof
 
\begin{align*}
v_{\pi,N}(s) &= \mathbb{E}_\pi\left[\mathbb{E}_\gamma\left[\sum_{t=1}^N r(S_t, A_t) \,\middle|\, S_1, A_1, ... \right] \,\middle|\, S_1 = s\right] = \\
&= \mathbb{E}_\pi\left[ \sum_{n=1}^\infty \sum_{t=1}^n  r(S_t, A_t) (1 - \gamma) \gamma^{n-1} \,\middle|\, S_1 = s\right]
\end{align*}

Assuming that $\sup_{s \in \mathcal{S}}\sup_{a \in \mathcal{A}(s)} |r(s,a)| \leq M < \infty \, \forall s\in \mathcal{S}, a \in \mathcal{A}(s)$:
\begin{align*}
&= \mathbb{E}_\pi\left[ \sum_{t=1}^\infty \sum_{n=t}^\infty   r(S_t, A_t) (1 - \gamma) \gamma^{n-1} \,\middle|\, S_1 = s\right]\\
%&= \mathbb{E}_\pi\left[ \sum_{t=1}^\infty r(S_t, A_t) (1 - \gamma)  \gamma^{t-1} \sum_{n=1}^\infty  \gamma^{n-1} \,\middle|\, S_1 = s\right]\\
&= \mathbb{E}_\pi\left[ \sum_{t=1}^\infty \gamma^{t-1} r(S_t, A_t)  \,\middle|\, S_1 = s\right] = v_{\pi,\gamma}(s) \enspace .
\end{align*}

# Markov Policies are Enough

::: warning
So far, we haven't made any assumption on whether we consider only Markovian or history-dependent policies
:::

Theorem

:    Let $\pi = (d_1, d_2, \hdots) \in \Pi^{\text{HR}}$, for each $s\in \mathcal{S}$ there exists a $\pi' = (d_1', d_2',\hdots) \in \Pi^{\text{MR}}$ such that: 
\begin{align*}
P_{\pi'}\left(S_t = j, A_t = a \,\middle|\, S_1 = s\right) = P_\pi\left(S_t = j, A_t = a \,\middle|\, S_1 = s\right), \\
\forall j \in \mathcal{S}, a \in \mathcal{A}(j), t=1,2,\hdots
\end{align*}

(both policies have the same **occupation measure**)


# Proof 

The full proof can be found in theorem 5.5.1 of Puterman (1994). The gist of it is that we can 
construct an equivalent Markov randomized policy by defining each decision rule  $d_t'$ as:

\begin{align*}
d_t'(a | j) \triangleq P_\pi\left(A_t = a \,\middle|\, S_t = j, S_1 = s\right), \enspace t=1,2,\hdots \enspace .
\end{align*}
for each $j \in \mathcal{S}, a \in \mathcal{A}(j)$,


# Policy Evaluation

Because of the above theorem, we don't need to consider history-dependent policies when dealing with MDPs.

Therefore: 
\begin{align*}
v_\gamma^\star(s) = \sup_{\pi \in \Pi^{HR}} v_{\pi, \gamma}(s) = \sup_{\pi \in \Pi^{MR}} v_{\pi, \gamma}(s), \enspace \forall s \in \mathcal{S} \enspace .
\end{align*}

(there is no loss of optimality in searching over the space of Markov policies)


# Recap on vector notation

Let $d \in \mathcal{D}^{MR}$, we define $P_d \in \mathbb{R}^{|\mathcal{S}| \times |\mathcal{S}|}$ as:
\begin{align*}
[P_d]_{ij} \triangleq \sum_{a \in \mathcal{A}(i)} p(j|i,a) d(a | i)\enspace \forall i,j \in \mathcal{S}, a \in \mathcal{A}(i),
\end{align*}
and $r_d \in \mathbb{R}^{|\mathcal{S}|}$ as:
\begin{align*}
[r_d]_{i} \triangleq \sum_{a \in \mathcal{A}(i)} r(i, a) d(a | i) \enspace .
\end{align*}

Furthermore, $P_\pi^t \in \mathbb{R}^{|\mathcal{S}|\times|\mathcal{S}|}$:
\begin{align*}
P_\pi^t = P_{d_t} P_{d_{t-1}} \hdots P_{d_1} \enspace .
\end{align*}



# Policy Evaluation

For generality, assume a **nonstationary** Markov policy $\pi$:

\begin{align*}
v_{\pi, \gamma}(i) &= \mathbb{E}\left[\sum_{t=1}^\infty \gamma^{t-1} r(S_t, A_t) \,\middle|\, S_1 = i \right] = \left[\sum_{t=1}^\infty \left(\gamma P_\pi \right)^{t-1} r_{d_t}\right]_i \enspace .
\end{align*}

Or recursively: 
\begin{align*}
 v_{\mathcolor{cyan}{\pi}, \gamma} &= r_{d_1} + \gamma P_{d_1} \sum_{t=1}^\infty \left(\gamma P_{\pi'} \right)^{t-1} r_{d_{t+1}}\\
 &= r_{d_1} + \gamma P_{d_1} v_{\mathcolor{magenta}{\pi'}, \gamma} \enspace.
\end{align*}
where $\pi' = (d_2, d_3, \hdots)$

# Stationary case

Let $d^\infty = (d, d, \hdots)$ where $d \in \mathcal{D}^{MR}$, then: 
\begin{align*}
v_{\mathcolor{cyan}{d^\infty}, \gamma} = r_d + \gamma P_d v_{\gamma, \mathcolor{magenta}{d^\infty}} \enspace .
\end{align*}


Therefore, $v_{d^\infty, \gamma}$ satisfies the linear system of equations: 
\begin{align*}
(I - \gamma P_d) v = r_d \enspace .
\end{align*}

Let $L_d$ be a linear transformation defined by:
\begin{align*}
L_d v \triangleq r_d + \gamma P_d v \enspace .
\end{align*}

# Policy evaluation operator

(Assuming the discrete state and action case)

Lemma

:   Let $|r(s,a)| \leq M < \infty, \forall s\in \mathcal{S}, a \in \mathcal{A}(s)$ and $0\leq \gamma < 1$, then 
$r_d + \gamma P_d v \in \mathcal{V}, \enspace \forall v \in \mathcal{V}, d \in \mathcal{D}^{MR}$.

Proof

: Both terms are bounded:

    1. $\|r_d\| \leq M$ so $r_d \in \mathcal{V}$
    2. $\|P_d v\| \leq \|P_d\| \|v\| = \|v\|$ so $P_d v \in \mathcal{V}$. 

We can therefore write $v_{d^\infty, \gamma}$ as a fixed point of $L_d$: 
\begin{align*}
v_{d^\infty, \gamma} = L_d v_{d^\infty, \gamma} \enspace .
\end{align*}


# Application of Neumann Lemma


Theorem 

: Let $0 \leq \gamma < 1$, then for any stationary policy $d^\infty, \, d \in \mathcal{D}^{MR}$, $v_{d^\infty,\gamma}$ is the solution to:
\begin{align*}
(I - \gamma P_d)v = r_d \enspace ,
\end{align*}
and can be written as: 
\begin{align*}
v_{d^\infty,\gamma} = (I - \gamma P_d)^{-1} r_d = \sum_{t=1}^\infty \left( \gamma P_d \right)^{t-1} r_d \enspace .
\end{align*}

Proof

:    It suffices to apply Neumann's lemma by noting that $\sigma(\gamma P_d) \leq |\gamma| \|  P_d \| < 1$ because $0 \leq \gamma < 1$ and $P_d$ is a stochastic matrix (rows sum to 1). 

# Bellman equations

We will show that optimal policies in the expected total discounted reward setting can be characterized via the 
nonlinear system of equations: 
\begin{align*}
v(s) = \sup_{a \in \mathcal{A}_s} r(s,a) + \gamma \sum_{j\in\mathcal{S}} p(j|s,a) v(j) \enspace .
\end{align*}

These are what we call the **optimality equations** or **Bellman equations**.

# Bellman operator 

Using the vector notation, we define the corresonding Bellman optimality operator as: 

\begin{align*}
\mathcal{L} v \triangleq \sup_{d \in \mathcal{D}^{\mathcolor{magenta}{MD}}} r_d + \gamma P_d v \enspace . 
\end{align*}

When the supremum is attained for all $v \in \mathcal{V}$ (for finite $\mathcal{A}(s)$ for example), then
we write instead:
\begin{align*}
L v \triangleq \max_{d \in \mathcal{D}^{\mathcolor{magenta}{MD}}} r_d + \gamma P_d v \enspace . 
\end{align*}

# Deterministic Decision Rules are enough

Theorem 

:   $\forall v\in\mathcal{V}, 0 \leq \gamma < 1$, $\sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MD}}} r_d + \gamma P_d v = \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MR}}} r_d + \gamma P_d v$

Proof

:   Since $\mathcal{D}^{MD} \subset \mathcal{D}^{MR}$: 
    \begin{align*}
    \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MD}}} r_d + \gamma P_d v \leq \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MR}}} r_d + \gamma P_d v
    \end{align*}

    To show that: 
    \begin{align*}
    \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MD}}} r_d + \gamma P_d v \geq \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MR}}} r_d + \gamma P_d v \enspace ,
    \end{align*}

# Proof (continued)

we apply lemma 4.3.1 in Puterman which says that given a real-valued function $f: \mathcal{X} \to \mathbb{R}$ on a discrete set $\mathcal{X}$ and a probability distribution $p$ over $\mathcal{X}$, then: 
\begin{align*}
\sup_{x \in \mathcal{X}} f(x) \geq \sum_{x \in \mathcal{X}} p(x) f(x) \enspace .
\end{align*}

To see this, let $x^\star = sup_{x \in \mathcal{X}} f(x)$ so that:
\begin{align*}
x^\star = \sum_{x \in \mathcal{X}} p(x) x^\star \geq \sum_{x \in \mathcal{X}} p(x) f(x) \enspace .
\end{align*}

# Proof (continued)

In our context, we want to establish that: 
\begin{align*}
\sup_{a \in \mathcal{A}(s)} \left(r(s, a) + \gamma \sum_{j\in\mathcal{S}}p(j|s,a)v(j) \right) \\
\geq \sum_{a \in \mathcal{A}(s)} d(a|s) \left( r(s,a) + \gamma \sum_{j \in \mathcal{S}} p(j|s,a) v(j)\right)\enspace .
\end{align*}

To apply the lemma, we let $f( \cdot ) \triangleq r(s, \cdot) + \gamma \sum_{j \in \mathcal{S}} p(j|s,\cdot) v(j)$ and $p(\cdot) \triangleq d(\cdot|s)$ for every $s \in \mathcal{S}$.

We showed that both $\leq$, and $\geq$ hold, therefore we conclude that: 

$\sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MD}}} r_d + \gamma P_d v = \sup_{d \in \mathcal{D}^{\mathcolor{cyan}{MR}}} r_d + \gamma P_d v.$

# v-improving and conserving decision rules

Definition

:   A decision rule $d_v \in \mathcal{D}^{MD}$ is said to be **v-improving** if:
\begin{align*}
d_v \in \arg\max_{d \in \mathcal{D}^{MD}} \left( r_d + \gamma P_d v \right), v \in \mathcal{V} \enspace .
\end{align*}

Therefore, if $d_v$ is v-improving then: 
\begin{align*}
r_{d_v} + \gamma P_{d_v} v = \max_{d \in \mathcal{D}^{MD}} \left(r_d + \gamma P_dv \right) \hspace{2em} \text{or} \hspace{2em} L_{d_v} v = Lv\enspace .
\end{align*}


Definition 

:   A decision rule $d^\star$ which is $v^\star_\gamma$-improving is also said to be **conserving**.

Therefore $L_{d^\star} v_\gamma^\star = r_{d^\star} + \gamma P_{d^\star}v_\gamma^\star = v^\star_\gamma$.


# Component-wise maximization 

::: warning
Because we have a component-wise partial order, whenever you see a sup over the space of policies, this doesn't mean that algorithmically you need to enumerate all policies to implement the given mapping.
:::

That is:
\begin{align*}
\left[\sup_{d \in \mathcal{D}^{MD}} r_d + \gamma P_d v\right]_i = \sup_{a \in \mathcal{A}(i)}\left( r(i,a) + \gamma \sum_{j \in \mathcal{S}} p(j|i,a) v(j) \right) \enspace .
\end{align*}

