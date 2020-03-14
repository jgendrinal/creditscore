#' Score input data using the scorecard model
#'
#' Borrower data is placed into \code{score_card} together with the model to
#' score each borrower.
#'
#' @param .data A tibble of borrower information with the variable names that
#'     match the variable names of the scorecard model
#' @param model A scorecard model object
#' @return A numeric vector of credit scores, whether scaled or not
#'
#' @export

score_card <- function(.data, model) {

  # Convert .data values to WOES, if applicable

  # Use predict.glm function to give probabilities of default for each borrower

  # Scale according to input, if applicable
  if (attr(model, "scaled")) {

  }

}
