c_l <- function(...) {
  
  assert_numeric_ascending(...)
  
  cuts <- c(-Inf, ..., Inf)
  result <- list()
  for (i in 1:(length(cuts)-1)) { 
    result[[i]] <- list(l = cuts[[i]], r = cuts[[i+1]], bounds = "[)")
  }
  result
}

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
