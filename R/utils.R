#' @keywords internal
has_good <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 0) %>%
    group_size() %>%
    all(. > 0)
}

#' @keywords internal
has_bad <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 1) %>%
    group_size() %>%
    all(. > 0)
}

#' @keywords internal
has_30_bad <- function(.data, bad, .) {
  var <- enquo(.)
  bad <- enquo(bad)
  .data %>%
    select(!!bad, !!var) %>%
    group_by(!!var) %>%
    filter(!!bad == 1) %>%
    group_size() %>%
    all(. >= 30)
}

#' @keywords internal
is_monotonic <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 1) %>%
    group_size() %>%
    any(all(diff(.) >= 0),
        all(diff(.) <= 0))
}

#' @keywords internal
check_binary_bad <- function(.data, bad) {
  any(
    all(.data[[as_string(bad)]] %in% c(1L, 0L)),
    all(.data[[as_string(bad)]] %in% c(1, 0)),
  )
}
