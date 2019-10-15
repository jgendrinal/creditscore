#' Bin the variables of a dataset manually
#'
#' \code{bin_manual} cuts numeric, variables according to the mapping specified
#' by the user. This is a standard step in feature engineering or data
#' transformation for scorecard modelling.
#'
#' Similar to the dplyr \code{mutate}, the function takes a named list of lists,
#' separated by commas, with the variable name on the left side, and the
#' transformation on the right side. \code{bin_manual} uses the \code{c_l} and
#' \code{c_r} functions to close where the values of a variable will be cut and
#' transformed into categories.
#'
#' @param .data A tibble or data.frame
#' @param bad A variable name indicating which rows are bad borrowers
#' @param ... Named lists separated by commas containing mappings of variables
#'   to a transformation. Cuts for each variable are separated by \code{c_l} or
#'   \code{c_r}.
#' @param check A logical, if TRUE, \code{bin_manual} will check for a minimum
#'     of 30 borrowers for each bin. FALSE by default.
#' @return A tibble or data.frame with the variables transformed into character
#'   vectors.
#'
#' @examples
#' bin_manual(german, bad, age = c_l(40, 55))
#' bin_manual(german,
#'            bad,
#'            duration = c_r(15, 32),
#'            check = TRUE)
#' @import dplyr rlang
#' @importFrom assertthat assert_that
#' @importFrom purrr map_lgl
#' @importFrom stringr str_c
#' @export
bin_manual <- function(.data, bad, ..., check = FALSE) {

  # Check if .data is data.frame or tibble
  assert_that(is.data.frame(.data) | is.tbl(.data),
              msg = "`.data` is not of type data.frame, tbl, or tbl_df")

  # Process bad, get from .data if not input by the user
  bad <- bad_handler(.data, bad)

  # Check if bad is a numeric that is `1` or `0`
  assert_bad_numeric_binary(.data, bad)

  # Warn if ... is not a list of intervals
  bin_plan <- list2(...)
  for (i in names(bin_plan)) {

    # Check if variable name exists in the dataset
    assert_that(i %in% names(.data),
                msg = str_c("Variable ", i, " not in .data"))

    var <- sym(i)
    result <- rep(NA_character_, nrow(.data))
    # Check if element is in interval then map interval to result
    for (j in bin_plan[[i]]) {
      target <- map_lgl(.data[[i]], function(.x) {
        if (j$bounds == "[)") {
          .x >= j$l & .x < j$r
        } else if (j$bounds == "(]") {
          .x > j$l & .x <= j$r
        }
      })
      result[target] <- str_c(j$l, " - ", j$r)
    }
    data_result <- .data %>%
      mutate(!!var := result)
    if (check) {
      assert_that(has_30_bad(data_result, bad, !!var),
                  msg = "Variable should have 30 bad borrowers")
    }
    .data <- data_result
  }
  # Add attributes to data_result before returning
  attr(.data, "bad") <- as_string(bad)

  # Return binned result
  .data
}
