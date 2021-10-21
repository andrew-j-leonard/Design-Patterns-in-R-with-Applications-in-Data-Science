is_null_or_na <- function(x, ...) {
  if (!missing(...)) {
    sapply(list(x, ...), function(.x) (is.null(.x) || is.na(.x)), simplify = "array")
  } else {
    (is.null(x) || is.na(x))
  }
}

.zero_if_x <- function(x, ..., f) {
  .f <- function(.x) if(isTRUE(f(.x))) 0 else .x
  if (!missing(...)) {
    sapply(list(x, ...), .f, simplify = "array")
  } else {
    .f(x)
  }
}

zero_if_null <- function(x, ...) .zero_if_x(x, ..., f = is.null)

zero_if_na <- function(x, ...) .zero_if_x(x, ..., f = is.na)

zero_if_null_or_na <- function(x, ...) .zero_if_x(x, ..., f = is_null_or_na)

# UNIT TEST
funcs <- list(zero_if_na, zero_if_null, zero_if_null_or_na)
plyr::l_ply(funcs, function(func) {
  message("Testing function:",  assertive::get_name_in_parent(func))
  message(func("a", 1, NULL, NA, data.frame(), letters))
}, .progress = "text")
