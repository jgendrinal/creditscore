context("Scoring a credit scorecard model")
library(dplyr)

mod1 <- bin_manual(german, bad, duration = c_l(12, 24)) %>%
  fit_logit(bad ~ duration)

mod2 <- bin_manual(german, bad, duration = c_l(12, 24)) %>%
  fit_logit(bad ~ duration) %>%
  scale_manual()

test_that("score_credit returns numeric vector", {
  expect_type(score_credit(slice(german, 1:30), mod1), "double")
  expect_type(score_credit(slice(german, 1:30), mod2), "double")
})

test_that("score_credit returns values according to scale", {
  expect_gt(score_credit(slice(german, 5), mod1), 0)
  expect_lt(score_credit(slice(german, 5), mod1), 1)
  expect_gt(score_credit(slice(german, 5), mod2), 100)
})
