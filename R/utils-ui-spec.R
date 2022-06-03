

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' print a tic_spec
#' 
#' @param x \code{tic_spec} object
#' @param ... ignored
#' 
#' @importFrom  utils str
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.tic_spec <- function(x, ...) {
  # cat(as.character(x))
  
  recursive_unclass <- function(x) {
    x <- unclass(x)
    x$children <- lapply(x$children, recursive_unclass)
    x
  }
  
  
  str(recursive_unclass(x))
}


