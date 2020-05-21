context("Fitting to logistical regression model")
library(dplyr)

data_binned <- bin_manual(german, bad, duration = c_l(12, 24))

test_that("fit_logit returns glm object", {

  expect_s3_class(fit_logit(data_binned, bad ~ duration), "glm")

})

test_that("fit_logit does not throw warnings or errors", {

  expect_silent(fit_logit(data_binned, bad ~ duration))

})
