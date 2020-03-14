#' Scale model output to a format using manual input
#'
#' \code{scale_manual} takes a scorecard model and formats the output using
#' a manual offset and factor input
#'
#' This is useful for representing the credit scores in the three-digit format
#' common in credit scoring companies like Equifax, FICO, and TransUnion.
#' Scaling is performed not to improve model predictability, but to improve
#' readability by stakeholders. This will generally depend on where the credit
#' scores are being used.
#'
#' @param score_model A modified model object containing the model and
#'     associated WOEs
#' @param offset A numeric, the credit score given default
#' @param factor A numeric, multiply the probability of default with this
#'     factor
#' @return A modified model object containg the offset and factor computed
#'     by the function
#'
#' @export
scale_manual <- function(score_model, offset = 500, factor = 20) {

  # Append offset, odds
  score_model$factor <- factor
  score_model$off <- offset

  # Turn scaling mode on
  attr(score_model, "scaled") <- TRUE

  # Return model result
  score_model
}
