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

# Policy gradient methods


- You are given a class of parameterized (typically stationary) policies within $\Pi^{MR}$: ie. $d_\theta(a|s)$ where $\theta$ are parameters to learn
- Important: $d_\theta$ needs to be a differentiable function of $\theta$ for all $s \in \mathcal{S}$ and $a \in \mathcal{A}(s)$

Pros:

- Can leverage ``structure'' in policy space
  - Can provide prior knowledge about the kind of policies to consider
- Applies to continuous state and action spaces

Cons: 

- Typically high variance
- Doesn't leverage structure in value space/DP results


# Objective

Our goal is to:
\begin{align*}
\text{maximize} \enspace J(\theta) = \mathbb{E}_{\tau \sim p_\theta}\left[G(\tau) \right] \enspace ,
\end{align*}
where $G(\tau) = \sum_{t=1}^T r(S_t, A_t)$ and $p_\theta$ the distribution over trajectories induced by $d_\theta$ interacting with the MDP.

- We are facing a stochastic optimization problem with a distributional dependency and no structural component.

# LR for RL

Applying a change of measure (the LR approach), we get: 
\begin{align*}
\text{maximize}\enspace J(\theta) = \mathbb{E}_{\tau \sim q}\left[ G(\tau) \rho(\tau, \theta, q) \right]\enspace ,
\end{align*}
where $\rho(\tau, \theta, q) = p_\theta(\tau)/q(\tau)$ is the likelihood ratio.

- Consequence: we no longer have distributional dependency on $\theta$: we pushed $\theta$ inside the expectation as structural parameters.

The gradient of $J$ with respect to $\theta$ is: 
\begin{align*}
DJ(\theta) = \mathbb{E}_{\tau \sim q}\left[ G(\tau) D_2 \rho(\tau, \theta, q)\right] \enspace .
\end{align*}

# The likelihood ratio is a Martingale

Let $\tau = (s_1, a_1, \hdots, s_T, a_T)$, the likelihood of a trajectory $\tau$ under $d_\theta$ is:
\begin{align*}
p(\tau;\theta) = p(s_1) \left(\prod_{t=1}^{T-1} d_\theta(a_t|s_t) p(s_{t+1}|s_t, a_t)\right) d_\theta(a_T|s_T)
\end{align*}

Therefore: 
\begin{align*}
\frac{p(\tau;\theta)}{q(\tau)} = \prod_{t=1}^{T} \frac{d_\theta(a_t|s_t)}{d(a_t|s_t)} \enspace .
\end{align*}
where $d$ is a given stationary policy in MR. The likelihood ratio is a Martingale, ie:
\begin{align*}
\mathbb{E}\left[ \rho_{1:t+1} \,\middle|\, \tau_{1:t}  \right] = \mathbb{E}\left[ \frac{d_\theta(A_{t+1}|S_{t+1})}{d(A_{t+1}|S_{t+1})}\,\middle|\, \tau_{1:t}  \right] \rho_{1:t} = \rho_{1:t} \enspace .
\end{align*}

# Using the Extended Conditional Monte Carlo Method

Using the law of total expectation, we can show that: 

\begin{align*}
J(\theta) = \mathbb{E}_{\tau \sim q} \left[ G(\tau) \rho(\tau, \theta, q) \right] = \mathbb{E}_{ \tau \sim q} \left[ \sum_{t=1}^T r(S_t, A_t) \mathbb{E} \left[ \rho_{1:T} \,\middle|\, \tau_{1:t} \right] \right]
\end{align*}

And using the fact that the LR is a Martingale: 

\begin{align*}
J(\theta) =\mathbb{E}_{\tau \sim d}\left[ \sum_{t=1}^T r(S_t, A_t) \prod_{k=1}^t \frac{d_\theta(A_k|S_k)}{d(A_k|S_k)}\right] \enspace .
\end{align*}

# LR + CMC + Martingale

We then get:
\begin{align*}
J(\theta) =\mathbb{E}_{\tau \sim d}\left[ \sum_{t=1}^T r(S_t, A_t) \prod_{k=1}^t \frac{d_\theta(A_k|S_k)}{d(A_k|S_k)}\right] \enspace .
\end{align*}

If we pick the specific case $d_\theta = d$ as a sampling policy, we obtain the **score function** expression:

\begin{align*}
DJ(\theta) &= \mathbb{E}_{\tau \sim d}\left[ \sum_{t=1}^T r(S_t, A_t) \sum_{k=1}^t D_\theta \log d_\theta(A_k|S_k) \right] \enspace .
\end{align*}

# SF + CMC + Martingale

The resulting estimator, call it $\hat{D}^\triangledown$ (mnemonic: lower triangular), taken over $N$ trajectories is then: 
\begin{align*}
\hat{D}^\triangledown J(\theta) = \frac{1}{N} \sum_{i=1}^N \sum_{j=1}^T r_{i,j} \sum_{k=1}^j D_\theta \log d_\theta(a_{i,k}|s_{i,k})
\end{align*}

where $r_{i,j}$ denotes the $j$th reward from the $i$th trajectory (same for $a_{i,k}$ and $s_{i,k}$). 
The inner most term can also be computed recursively: 
\begin{align*}
\hat{D}^\triangledown J(\theta) &= \frac{1}{N} \sum_{i=1}^N \sum_{j=1}^T r_{i,j} z_{i,j} \\
z_{i,j} &= D_\theta \log d_\theta(a_{i,j}|s_{i,j}) + z_{i,j-1}\enspace .
\end{align*}
and $z_{i,\bullet}$ is the eligibility trace for the $i$th trajectory.


# SF + CMC + Martingale + change of bounds

We have: 
\begin{align*}
DJ(\theta) &= \mathbb{E}_{\tau \sim d}\left[ \sum_{t=1}^T r(S_t, A_t) \sum_{k=1}^t D_\theta \log d_\theta(A_k|S_k)  \right]\enspace .
\end{align*}

The indices in the above expression are such that $1 \leq k \leq t \leq T$. Instead of taking $1 \leq t \leq T$ and $k \leq t \leq T$, we can use instead $1 \leq k \leq T$ and $k \leq t \leq T$. This gives us: 
\begin{align*}
DJ(\theta) &= \mathbb{E}_{\tau \sim d}\left[ \sum_{t=1}^T D_\theta \log d_\theta(A_t | S_t) \sum_{k=t}^T  r(S_k, A_k) \right]\enspace .
\end{align*}

# Estimator

The resulting (offline) estimator, call it $\hat{D}^\triangle$ (mnemonic: upper triangular)  is then: 
\begin{align*}
\hat{D}^\triangle J(\theta) = \frac{1}{N} \sum_{i=1}^N \sum_{j=1}^T D_\theta \log d_\theta(a_{i,j} | s_{i,j}) \sum_{k=j}^T r(s_{i,k}, a_{i,k}) \enspace .
\end{align*}
This estimator is the most frequently encountered in modern deep RL and is typically implemented using the SAA perspective, that is, by defining a surrogate objective:
\begin{align*}
\hat{J}^\triangle(\theta) =  \frac{1}{N} \sum_{i=1}^N \sum_{j=1}^T \log d_\theta(a_{i,j} | s_{i,j}) \sum_{k=j}^T r(s_{i,k}, a_{i,k}) \enspace , 
\end{align*}
and the gradient $D \hat{J}^\triangle$ is the computed using automatic differentiation.