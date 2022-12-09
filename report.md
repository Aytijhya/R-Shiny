---
title: "LINEAR MODELS PROJECT REPORT"
author: "Aytijhya Saha (BS2002)"
output:
  html_document:
    df_print: paged
  pdf_document:
    keep_tex: false
    extra_dependencies: ["amsmath","tcolorbox","xcolor","hyperref","pifont"]
fontsize: 12pt
geometry: margin=0.9in
mainfont: cochineal
fontfamily: libertine
sansfont: Linux Biolinum O
editor_options: 
  markdown: 
    wrap: 72
runtime: shiny
---



```{=tex}
\definecolor{mypink1}{rgb}{0.95, 0.91, 0.85}
\definecolor{Prussian}{rgb}{0,0.2,0.4}
\definecolor{DeepBlue}{HTML}{3E0080}
```
\section{\textbf{\textcolor{DeepBlue}{\ding{99} ~Objective}}}

In this project, our aim was to take several screenshots that share some common locations and stitch them into a whole map.

\section{\textbf{\textcolor{DeepBlue}{\ding{99} ~Objective}}}

In this project, I took several screenshots of satellite images from Google Maps of the area in Bangalore and stitched them into a whole map. However, the code that I used for this, works fine for any and every area on Google Maps.

\section{\textbf{\textcolor{DeepBlue}{\ding{99} ~Methodology}}}

## Model

Suppose, I have $m$ screenshots and $n$ distinct places to locate on the map.I stored the screenshot number(as ss variable), the name of the place(as place variable) and the co-ordinates of the place with respect to that screenshot. I fitted linear model for predicting the x-ordinate and the y-ordinate separately.
For the y-ordinate the model is,
$$y_{ij}=ss_i+place_j+\epsilon_{ij} \text{ where  } i=1,\cdots,m; j=1,\cdots n_i \text{ and } \epsilon_{ij}\stackrel{IID}{\sim}N(0,\sigma^2)$$
Note that both the inputs are factor. This is a 2-way ANOVA model. We have only two indices $(i,j)$ as for each type $(i,j)$ we have only one observation.
Similarly for the x-ordinate the model is,
$$x_{ij}=ss_i+place_j+\epsilon_{ij} \text{ where  } i=1,\cdots,m; j=1,\cdots n_i\text{ and } \epsilon_{ij}\stackrel{IID}{\sim}N(0,\sigma^2)$$

<img src="/Users/aytijhyasaha/Documents/blackbox.png" title="Blackbox diagram" alt="Blackbox diagram" width="40%" height="20%" style="display: block; margin: auto;" />
## Design Matrix
Number of columns in design matrix is $m+n$.
Number of rows in design matrix = Total number of clicks= $C$ (let).
the dimension of the design matrix is
=(number of clicks x ( number of distinct place+ number of screenshots))
= $C \times (m+n)$

## Rank of the design matrix
\textbf{\textit{Claim: }}The map formed by the screenshots is connected iff
rank(design matrix) = m+n-1.

\textbf{\textit{Proof: }} To understand the idea, consider the screenshots as vertices of a graph and draw an edge between them if they have at least one marked place common. We know if a graph is connected there exists at least (m-1) many edges.

If place(j) is common in $k$ many of the screenshots, there exist at least $k-1$ many edges in the graph.
Hence total number of edges in the graph is $\sum_j^n (k(j)-1)=C-n$ where $k(j) =$ number of times place(j) has occurred.

Now, for the columns, if we add all the columns corresponding to place variable we get a vector of 1’s. Similarly adding up all the columns w.r.t. ss variable we get a vector of 1’s. All the ss variables are independent of each other and all the place variables are independent of each other. Hence, column rank of the design matrix = m+n-1.

Combining two cases we get, the map is connected iff rank (design matrix)= m+n-1
Using this I checked for faulty clicks from the users in my software later.


Combining two cases we get, the map is connected iff rank(design matrix)= m+n-1.

Using this I checked for faulty clicks from the users in my software later.

\section{\textbf{\textcolor{DeepBlue}{\ding{99} ~Documentation for R codes and outputs}}}

