context("Manual binning")

test_that("bin_manual converts numeric inputs to character", {
  expect_type(bin_manual(german, bad, duration = c_l(12, 24))$duration,
              "character")
})
