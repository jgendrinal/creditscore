
<!-- README.md is generated from README.Rmd. Please edit that file -->

# creditscore

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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# Create scorecard model - with scaling
card_model_scaled <- bin_manual(german,
                         bad,
                         duration = c_r(15, 32)) %>%
  fit_logit(bad ~ duration + age + employed_since) %>% 
  scale_double_odds(odds_fifty = 600, pdo = 20)
#> Warning: Unknown columns: `age`
#> Warning: All elements of `...` must be named.
#> Did you want `data = c(val, bad)`?

# Without scaling
card_model_noscale <- bin_manual(german,
                         bad,
                         duration = c_r(15, 32)) %>%
  fit_logit(bad ~ duration + age + employed_since)
#> Warning: Unknown columns: `age`

#> Warning: All elements of `...` must be named.
#> Did you want `data = c(val, bad)`?
```

Now that we’ve built our models, let’s see how they perform:

``` r
score_credit(slice(german, 1:30), card_model_scaled)
#>        1        2        3        4        5        6        7        8 
#> 483.5519 464.6676 483.3814 474.2809 477.4347 467.0659 479.5755 467.0659 
#>        9       10       11       12       13       14       15       16 
#> 483.8661 471.1555 475.9565 456.9621 479.4313 480.1276 479.9147 475.1112 
#>       17       18       19       20       21       22       23       24 
#> 479.5755 468.5567 478.8101 477.5869 481.3377 481.0751 478.3288 477.9499 
#>       25       26       27       28       29       30 
#> 479.7567 480.5175 482.2062 480.9398 480.3712 474.7873
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
