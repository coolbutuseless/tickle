#' @useDynLib tickle, .registration=TRUE
NULL


# global counter for images that have been loaded.
env <- new.env()
env$img_count <- 0L