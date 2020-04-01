#' Score input data using the scorecard model
#'
#' Borrower data is placed into \code{score_credit} together with the model to
#' score each borrower.
#'
#' @param .data A tibble of borrower information with the variable names that
#'     match the variable names of the scorecard model
#' @param model A scorecard model object
#' @return A numeric vector of credit scores, whether scaled or not
#'
#' @import dplyr rlang
#' @importFrom assertthat assert_that
#' @importFrom stats predict
#' @export

score_credit <- function(.data, model) {

  # Convert .data values to WOES, if applicable
  if (!is.null(attr(model, "binplan"))) {
    binplan <- attr(model, "binplan")
    new_data <- bin_manual(.data, attr(model, "bad"), !!!binplan)
  }

  if (!is.null(model[["woes"]])) {

    # Check if WOE variables exist in data
    assert_that(all(model[["woes"]]$var %in% names(new_data)),
                msg = "Some model WOE names do not exists in .data")

    # Recode variable values in data with WOEs
    for (i in model[["woes"]]$var) {
      woeplan <- model[["woes"]]$woe[[match(i, model[["woes"]]$var)]]$woe %>%
        as.character
      names(woeplan) <- model[["woes"]]$woe[[match(i, model[["woes"]]$var)]]$var
      woeplan <- unlist(lapply(split(woeplan, names(woeplan)), unname))
      i <- sym(i)
      new_data <- mutate(new_data,
                         !!i := recode(!!i, !!!woeplan) %>% as.numeric)
    }
  }

  # Use predict.glm function to give probabilities of default for each borrower
  result <- predict(model, newdata = new_data, type = "response")

  # Scale according to input, if applicable
  if (attr(model, "scaled")) {
    result <- model$off + model$factor*log(1 - result)
  }
  result
}
