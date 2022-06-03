

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Unpack a possible reactive value into a plain \code{tclVar}
#' 
#' @param x object
#' @return if object is a reactive value, then return the core \code{.impl}
#'         object which is a \code{tclVar}.
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unpack_reactive <- function(x) {
  if (inherits(x, 'reactive_value')) {
    attr(x, ".impl")
  } else {
    x
  } 
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Helper function to unpack reactives to tclVars within a list
#'
#' @param x list of named arguments
#'
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unpack_reactives <- function(x) {
  lapply(x, unpack_reactive)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Format/print a reactive value
#' 
#' @param x object
#' @param ... ignored
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
format.reactive_value <- function(x, ...) {
  paste0(class(x)[1], ": ", x())
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname format.reactive_value
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
format.reactive_textbox <- function(x, ...) {
  paste0(class(x)[1], ": ", nchar(x()), " characters in textbox")
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname format.reactive_value
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.reactive_value <- function(x, ...) {
  cat(format(x, ...))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a reactive variable
#' 
#' @param value initial value. 
#' 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reactive_lgl <- function(value = FALSE) {
  rv <- tcltk::tclVar(init = value)
  structure(function(x) {
    if (missing(x)) {
      tcltk::tclvalue(rv) == "1"
    } else {
      force(x)
      tcltk::tclvalue(rv) <- x
    }
  }, class = c("reactive_value", "reactive_lgl"), 
  .impl = rv)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname reactive_lgl
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reactive_int <- function(value = 0L) {
  rv <- tcltk::tclVar(init = value)
  structure(function(x) {
    if (missing(x)) {
      as.integer(tcltk::tclvalue(rv))
    } else {
      force(x)
      tcltk::tclvalue(rv) <- x
    }
  }, class = c("reactive_int", "reactive_value"), 
  .impl = rv)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname reactive_lgl
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reactive_chr <- function(value = "") {
  rv <- tcltk::tclVar(init = value)
  structure(function(x) {
    if (missing(x)) {
      tcltk::tclvalue(rv)
    } else {
      force(x)
      tcltk::tclvalue(rv) <- x
    }
  }, class = c("reactive_chr", "reactive_value"), 
  .impl = rv)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname reactive_lgl
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reactive_dbl <- function(value = 0.0) {
  rv <- tcltk::tclVar(init = value)
  structure(function(x) {
    if (missing(x)) {
      as.numeric(tcltk::tclvalue(rv))
    } else {
      force(x)
      tcltk::tclvalue(rv) <- x
    }
  }, class = c("reactive_dbl", "reactive_value"), 
  .impl = rv)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname reactive_lgl
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reactive_textbox <- function(value) {
  # For a textbox, this reactive holds the ID of the textbox GUI element.
  # when the use accesses this variable, the ID of the textbox is used to 
  # fetch the latest contents
  rv <- tcltk::tclVar(init = '')
  structure(function(x) {
    if (missing(x)) {
      if (tcltk::tclvalue(rv) == "") {
        ""
      } else {
        current <- tcltk::tkget(tcltk::tclvalue(rv), "1.0", "end")
        tclvalue(current)
      }
    } else {
      stop("textbox contents cannot currently be set programmatically in this manner")
    }
  }, class = c("reactive_textbox", "reactive_value"), 
  .impl = rv)
}




