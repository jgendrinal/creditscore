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
