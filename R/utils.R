# Check if the bin/segment has good borrowers
has_good <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 0) %>%
    group_size() %>%
    all(. > 0)
}

# Check if the bin/segment has bad borrowers
has_bad <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 1) %>%
    group_size() %>%
    all(. > 0)
}

# Check if the bin/segment has bad borrowers
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

# Check if the bin/segment is monotonic
is_monotonic <- function(bad, .) {
  var <- cbind(.)
  cbind(bad, var) %>%
    group_by(var) %>%
    filter(bad == 1) %>%
    group_size() %>%
    any(all(diff(.) >= 0),
        all(diff(.) <= 0))
}

# Calculate WOEs for continuous variables
calculate_woes <- function(.var, .bad) {
  tibble(var = .var,
         bad = .bad) %>%
    group_by(var) %>%
    summarize(bpct = sum(bad)/sum(.bad),
              gpct = (n()-sum(bad))/(length(.bad)-sum(.bad))) %>%
    mutate(woe = log(gpct/bpct)*100) %>%
    select(var, woe)
}

replace_as_woes <- function(.var, .bad) {
  # Check that bad is 1 or 0


  # Calculate woes
  woe_legend <- calculate_woes(.var, .bad)

  map_dbl(.var, function(x) {
    for (i in 1:nrow(woe_legend)) {
      if (woe_legend[[i, 1]] == x) {
        return(woe_legend[[i, 2]])
      }
    }
  })
}


# Check whether bad variable is binary
check_binary_bad <- function(.data, bad) {
  any(
    all(.data[[as_string(bad)]] %in% c(1L, 0L)),
    all(.data[[as_string(bad)]] %in% c(1, 0)),
  )
}

