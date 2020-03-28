context("Closing cuts")
library(dplyr)
library(purrr)

test_that("c_l and c_r only accept numeric, ascending vectors", {
  expect_error(c_l(5, 1))
  expect_error(c_r(5, 1))
  expect_error(c_l("a", "b"))
  expect_error(c_r("a", "b"))
})

test_that("c_l and c_r have the proper structure", {
  expect_equivalent(map(c_l(2, 5, 7), ~.$bounds) %>% unlist,
                    rep("[)", times = 4))
  expect_equivalent(map(c_r(2, 5, 7), ~.$bounds) %>% unlist,
                    rep("(]", times = 4))
})

# TODO test that each interval has a left and right

# TODO test that first left is negative infiinity

# TODO test that first right is positive infinity
