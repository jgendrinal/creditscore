
<!-- README.md is generated from README.Rmd. Please edit that file -->

# creditscore

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)  
<!-- badges: end -->

The goal of creditscore is to create tidy workflows for credit scorecard
modelling. Verbs used in this package make it easier to understand how
the models were built. Use of the pipe (`%>%`) allows the user to code
models step-by-step. A final utility function allows the user to score
borrowers given a credit scorecard model.

The creditscore model development framework has three main function
groups:

1.  `bin_manual`, `c_l`, `c_r` - Used to bin numeric variables  
2.  `fit_logit` - For taking data to fit into a logit model  
3.  `scale_manual`, `scale_double` - Scaling the scorecard models to a
    400+ number system or as specified by the user

The result of the workflow is a glm model object containing the
scorecard model.

Finally, the utility function `score_credit` is the function that scores
borrowers given their information and the model just created.

## Installation

You can install the development version of creditscore from the [Github
repo](https://github.com/jgendrinal/creditscore) with:

``` r
devtools::install_github("jgendrinal/creditscore")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(creditscore)
library(dplyr)
```

``` r
# Create scorecard model - with scaling
card_model_scaled <- bin_manual(german,
                         bad,
                         duration = c_r(15, 32)) %>%
  fit_logit(bad ~ duration + age + employed_since) %>% 
  scale_double_odds(odds_fifty = 600, pdo = 20)

# Without scaling
card_model_noscale <- bin_manual(german,
                         bad,
                         duration = c_r(15, 32)) %>%
  fit_logit(bad ~ duration + age + employed_since)
```

Now that we’ve built our models, let’s see how they perform:

``` r
score_credit(slice(german, 1:30), card_model_scaled)
#>        1        2        3        4        5        6        7        8 
#> 545.6063 482.4050 544.1740 503.8221 513.6329 487.0091 521.9615 487.0091 
#>        9       10       11       12       13       14       15       16 
#> 548.4239 495.8447 508.7518 469.4625 521.3402 524.4407 523.4652 506.1954 
#>       17       18       19       20       21       22       23       24 
#> 521.9615 490.0654 518.7741 514.1699 530.5485 529.1318 516.8976 515.4810 
#>       25       26       27       28       29       30 
#> 522.7569 526.2985 535.6896 528.4235 525.5902 505.2544
```

``` r
score_credit(slice(german, 1:30), card_model_noscale)
#>         1         2         3         4         5         6         7         8 
#> 0.1164094 0.5407867 0.1216134 0.3592202 0.2852091 0.5009856 0.2301585 0.5009856 
#>         9        10        11        12        13        14        15        16 
#> 0.1067351 0.4250014 0.3209079 0.6484114 0.2339963 0.2152885 0.2210551 0.3405140 
#>        17        18        19        20        21        22        23        24 
#> 0.2301585 0.4745269 0.2503125 0.2814302 0.1816784 0.1890922 0.2627131 0.2723332 
#>        25        26        27        28        29        30 
#> 0.2253111 0.2046105 0.1566728 0.1928852 0.2086347 0.3478755
```
