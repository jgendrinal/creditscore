#' Scale model output to a format using points to double and default points at
#' odds of 50-to-1
#'
#' \code{scale_double_odds} takes a scorecard model and formats the output using
#' points-to-double and the set score representing odds of default at 50-to-1.
#' Both are input by the user.
#'
#' This is useful for representing the credit scores in the three-digit format
#' common in credit scoring companies like Equifax, FICO, and TransUnion.
#' Scaling is performed not to improve model predictability, but to improve
#' readability by stakeholders. This will generally depend on where the credit
#' scores are being used.
#'
#' @param score_model A modified model object containing the model and
#'     associated WOEs
#' @param odds_fifty A numeric, the point score of a borrower with a probability
#'     of default of 50 to 1, default input is 600 points
#' @param pdo A numeric, score points given doubling odds of a default, defaults
#'     to 20 points
#' @return A modified model object containg the offset and factor computed
#'     by the function
#'
#' @export
scale_double_odds <- function(score_model, odds_fifty = 600, pdo = 20) {

  # Turn scaling mode on
  attr(score_model, "scaling") <- TRUE

  # Append offset, odds
  score_model$factor <- pdo/log(2)
  score_model$offset <- odds_fifty - (pdo/log(2))*log(50)

  # Return model result
  score_model
}
