context("Scaling model")
library(dplyr)

mod1 <- bin_manual(german, bad, duration = c_l(12, 24)) %>%
  fit_logit(bad ~ duration) %>%
  scale_manual()

mod2 <- bin_manual(german, bad, duration = c_l(12, 24)) %>%
  fit_logit(bad ~ duration) %>%
  scale_double_odds()

test_that("scale_double_odds, scale_manual returns glm object", {
  expect_s3_class(mod1, "glm")
  expect_s3_class(mod2, "glm")
})

test_that('scale_double_odds, scale_manual returns correct factor, offset', {
  expect_equal(mod1$factor, 20)
  expect_equal(mod2$factor, 20/log(2))
  expect_equal(mod1$off, 500)
  expect_equal(mod2$off, 600 - (20/log(2))*log(50))
})
