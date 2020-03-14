#' Fit data into a logistic regression model
#'
#' \code{fit_logit} takes a dataset and formula input by the user to generate
#' a logistic regression model that will be later used for the scoring borrower
#' accounts.
#'
#' The function performs the following:
#' \enumerate{
#'     \item Calculate the weights-of-evidence (WOEs) of the categorical
#'         variables
#'     \item Replace the category values with the weights of evidence
#'     \item Returns a glm model object with modified attributes
#' }
#'
#' All numeric variables are used in the logistic regression model as is. All
#' categorical variables are converted into WOEs before modelling. For better
#' accuracy and for simplicity, it is recommended that numeric variables are
#' first \link[=bin_manual]{binned} before modelling.
#'
#' @param .data A tibble or data.frame
#' @param formula A formula of the form \code{y ~ x_1 + x_2 + ...}, where
#'     \code{y} is the bad variable and \code{x1_2}, \code{x_2}, \code{...} are
#'     the variables that will be used in the scorecard.
#' @return A glm object containing the resulting model, with the name of the
#'     bad variable, and the weights of evidence for each value in each
#'     variable as attributes.
#'
#' @examples
#' library(dplyr)
#'
#' bin_manual(german, bad, age = c_l(40, 55)) %>%
#'   fit_logit(bad ~ age + history + purpose)
#'
#' bin_manual(german,
#'            bad,
#'            duration = c_r(15, 32),
#'            check = TRUE) %>%
#'  fit_logit(bad ~ duration + age + employed_since)
#' #
#'
#' @import dplyr
#' @importFrom purrr map map_dbl
#' @importFrom stats binomial glm var
#' @importFrom tidyr gather nest
#' @export
fit_logit <- function(.data, formula) {
  # Deciding whether 'bad' variable should be explicitly defined by the user

  bad <- sym(attr(.data, "bad")) # Solution for now

  # Check if formula is valid
  assert_that(is_formula(formula) & !is_null(f_lhs(formula)),
              msg = "Formula is not of the form y ~ x.")

  # Parse formula
  if (f_rhs(formula) != sym(".")) {
    # Pick out formula from a list of variables
    target <- f_text(formula) %>%
      strsplit(c(" ?\\+ ?")) %>%
      `[[`(1) %>%
      syms()
  } else {
    # Pick out formula from all variables except bad
    target <- names(.data) %>%
      `[`(. != as_string(eval(bad))) %>%
      syms()
  }

  # Extract WOE legends from .data
  .data %>%
    select(c(!!bad, !!!target)) %>%
    # Convert all categorical variables to WOEs
    mutate_if(is.character, ~replace_as_woes(.x, !!bad)) -> df

  # Push to model object
  result <- glm(formula = formula,
                data = df,
                family = binomial(link = "logit"))


  # Add attributes, legends to result
  attr(result, "bad") <- as_string(bad)
  result$woes <- bind_cols(select(.data, !!bad),
                           select_if(.data, is.character) %>%
                             select(one_of(as.character(target)))
                           # TODO Suppress warnings for this expression
                           ) %>%
    gather(key = "var", value = "val", -!!bad) %>%
    nest(val, !!bad) %>%
    mutate(woe = map(data, function(data) {
      bad <- as_string(bad)
      calculate_woes(data[["val"]], data[[bad]])
    })) %>%
    select(-data)
  attr(result, "scaled") <- FALSE

  # Return model result
  result
}
