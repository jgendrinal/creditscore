context("Fitting to logistical regression model")
library(dplyr)

test_that("fit_logit returns glm object", {

  mod <- bin_manual(german, bad, duration = c_l(12, 24)) %>%
    fit_logit(bad ~ duration)

  expect_s3_class(mod, "glm")

})
