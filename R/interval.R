interval_contains_element <- function(cut, value) {
  if (cut$bounds == "[)") {
    value >= cut$l & value < cut$r
  } else if (cut$bounds == "(]") {
    value > cut$l & value <= cut$r
  }
}