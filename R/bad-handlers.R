# Handle bad variable, whether input by the user or from the .data object
bad_handler <- function(.data, bad) {
  result <- tryCatch(
    {
      bad <- ensym(bad)
    },
    error = function(cond) {
      if (is_null(attr(.data, "bad"))) {
        abort("`bad` not found in either `.data` or user input.")
      } else {
        inform("Getting `bad` variable from `.data`")
        bad <- sym(attr(.data, "bad"))
      }
    })
  result
}

# Check if bad is a numeric that is `1` or `0`
assert_bad_numeric_binary <- function(.data, bad) {
  select(.data, !!bad) %>%
    pull() -> bad
    assert_that(is.numeric(bad) & all(bad %in% c(1, 0)),
                msg = "`bad` should be numeric and `1` or `0`")
}
