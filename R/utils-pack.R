

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Brief 'find_args()' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
find_args_simple <- function (...) {
  env <- parent.frame()
  args <- names(formals(sys.function(sys.parent(1))))
  vals <- mget(args, envir = env)
  vals <- vals[!vapply(vals, is_missing_arg, logical(1))]
  modify_list(vals, list(..., ... = NULL))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# assert numeric without NAs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
num <- function(x) {
  is.null(x) || (is.numeric(x) && length(x) > 0 && !anyNA(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a list of pack options used during widget creation
#' 
#' These pack options specify how a widget is packed into its parent element.
#'
#' @param anchor Specify where to position content within its parent. 
#'        Defaults to 'center'.  The alternative is to specify a string 
#'        consisting only of the letters 'n', 's', 'e', 'w', to indicate
#'        the compass direction to anchor to.  e.g. 'w', or 'sw' for 
#'        'west' (left) or 'southwest' respectively.
#' @param expand Should the content should be expanded to consume extra 
#'        space in its parent container? Default: TRUE
#' @param fill If parent size is larger than its requested dimensions, 
#'        this option may be used to stretch the content. 
#' \describe{
#' \item{\code{none}}{No stretching of widget}
#' \item{\code{x}}{Stretch the content horizontally to fill the space}
#' \item{\code{y}}{Stretch the content vertically to fill the space}
#' \item{\code{both}}{Stretch the content horizontally and vertically to fill the space}
#' }
#' 
#' @param ipadx,ipady How much horizontal/vertical \emph{internal} padding
#'        to leave on the side of each element.  
#'        
#'        If you are familiar with HTML/CSSThis is analogous to 
#'        CSS \code{margin}.
#' @param padx,pady How much horizontal/vertical \emph{external} padding
#'        to leave on the side of each element. This may be two values in 
#'        order to specify different padding for left vs right, or top 
#'        vs bottom.
#'        
#'        If you are familiar with HTML/CSSThis is analogous to 
#'        CSS \code{margin}.
#'        
#' @param side Which side of the container the content will be packed against?
#'        Possible values: left, right, top, bottom
#'
#' @param ... extra named args used by the packing spec. 
#'
#' @export
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on the packing specification 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/pack.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pack_opts <- function(anchor, expand, fill, ipadx, ipady, padx, pady, side, ...) {
  opts <- find_args_simple(...)
  
  stopifnot(is.null(opts$expand) || opts$expand %in% c(TRUE, FALSE))
  stopifnot(is.null(opts$fill) || opts$fill %in% c('none', 'x', 'y', 'both'))
  stopifnot(is.null(opts$side) || opts$side %in% c('left', 'right', 'top', 'bottom'))
  if (!is.null(opts$anchor)) {
    stopifnot(opts$anchor == 'center' || grepl('^[nsew]+$', opts$anchor))
  }
  stopifnot(num(opts$ipadx))
  stopifnot(num(opts$ipadu))
  stopifnot(num(opts$padx))
  stopifnot(num(opts$pady))
  
  
  opts
}


if (FALSE) {
  
  pack_opts(expand = TRUE, anchor = 'sn', side = 'leftx')
  
}
