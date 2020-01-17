#' Define value cuts for binning
#'
#' Functions for explicitly defining value cuts and how the intervals are closed
#' either left or right.
#'
#' @param ... Numbers, separated by commas indicating interval cuts in ascending
#'     order
#' @return A list of lists containing each cut and a length (1) character vector
#'     containing the symbol for the bounds.
#'
#' @examples
#' c_l(23, 50, 60)
#' c_r(2.5, 4, 5)
#' @importFrom assertthat assert_that
#' @rdname closed
#' @export
c_l <- function(...) {

  assert_numeric_ascending(...)

  cuts <- c(-Inf, ..., Inf)
  result <- list()
  for (i in 1:(length(cuts)-1)) {
    result[[i]] <- list(l = cuts[[i]], r = cuts[[i+1]], bounds = "[)")
  }
  result
}

#' @rdname closed
#' @export
c_r <- function(...) {

  assert_numeric_ascending(...)

  cuts <- c(-Inf, ..., Inf)
  result <- list()
  for (i in 1:(length(cuts)-1)) {
    result[[i]] <- list(l = cuts[[i]], r = cuts[[i+1]], bounds = "(]")
  }
  result
}

assert_numeric_ascending <- function(...) {
  # Abort if not numeric
  assert_that(all(is.numeric(c(...))),
              msg = "Elements should be numeric")

  # Abort if not ascending
  assert_that(all(diff(c(...)) >= 0),
              msg = "Elements should be ascending")
}
