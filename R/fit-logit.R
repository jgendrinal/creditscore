# TODO Document fit_logit
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
                             select(!!!target)) %>%
    gather(key = "var", value = "val", -!!bad) %>%
    nest(val, !!bad) %>%
    mutate(woe = map(data, function(data) {
      bad <- as_string(bad)
      calculate_woes(data[["val"]], data[[bad]])
      })) %>%
    select(-data)

  # Return model result
  result
}
