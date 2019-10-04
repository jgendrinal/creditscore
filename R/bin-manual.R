bin_manual <- function(.data, bad, ..., check = FALSE) {

  # Check if .data is data.frame or tibble
  assert_that(is.data.frame(.data) | is.tbl(.data),
              msg = "`.data` is not of type data.frame, tbl, or tbl_df")

  # Process bad, get from .data if not input by the user
  bad <- bad_handler(.data, bad)

  # Warn if ... is not a list of intervals
  bin_plan <- list2(...)
  for (i in names(bin_plan)) {
    var <- sym(i)
    result <- rep(NA_character_, nrow(.data))
    for (j in bin_plan[[i]]) {
      # Check if element is in interval then map interval to result
      target <- map_lgl(.data[[i]], function(j, .x) {
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
      assert_that(check_bads(data_result, bad, !!var),
                  msg = "Variable should have 30 bad borrowers")
      assert_that(is_monotonic(check_bads(data_result[[bad]],
                                          data_result[[var]])),
                  msg = "Variable should have 30 bad borrowers")
    }
    .data <- data_result
  }
  # Add attributes to data_result before returning
  attr(.data, "bad") <- as_string(bad)

  # Return binned result
  .data
}
