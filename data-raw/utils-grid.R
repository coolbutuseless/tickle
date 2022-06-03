

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# I couldn't get the 'grid' layout working nicely so I've abandoned it
# for the first release of tickle.
#
# Maybe worth revisiting, so leaving the code around. Ignore it.
# Mikefc 2022-06-02
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a grid of objects
#' 
#' This is an alternate widget layout engine for creating a 2D grid of cells
#' in which to place child widgets.
#' 
#' Grid layout has its own way of specifying placement and sizes. 
#' See \code{grid_opts()} for more info
#' 
#' Grid cells may be empty.
#' 
#' The default placement for child elements of this grid is given by 
#' \code{grid_def}, and each child may specify a \code{grid} argument to 
#' override these defaults.
#' 
#' @inheritParams tic_button
#' @inheritParams tic_labelframe
#' @param grid_def the default packing for child elements contained in this grid.
#'        This will be overridden by any options specified in the individual 
#'        child's \code{grid} argument.
#' @param nrow,ncol number of rows/cols in the grid.
#' @param widths,heights the relative widths and heights of the grid cells.
#'        default is all \code{1} such that each cell has the same size.  E.g.
#'        use \code{widths = c(1, 2)} to indicate the second column should 
#'        be twice as wide as the first
#'  
#' @return handle on the tcl/tk object
#' @noRd
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on the elements are placed 
#' within a grid
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/grid.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_grid <- function(..., nrow, ncol, widths = rep(1, ncol), heights = rep(1, nrow), 
                     bind = NULL, pack = NULL, grid = NULL, grid_def = grid_opts()) {
  args <- find_args(..., ignore = c('nrow', 'ncol', 'widths', 'heights'))
  
  args$named$sizes  <- NULL
  
  spec <- list(
    args     = args$named,
    type     = 'grid',
    children = args$unnamed,
    binding  = bind,
    pack     = pack,
    grid     = grid,
    grid_def = grid_def,
    nrow     = nrow,
    ncol     = ncol,
    widths   = widths,
    heights  = heights
  )
  class(spec) <- 'tic_spec'
  spec
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_grid <- function(parent, spec) {
  stopifnot(identical(spec$type, 'grid'))
  
  frame <- tcltk::tkframe(parent)
  frame$type <- 'frame_grid'
  
  grid  <- call_tcltk(tcltk::tkgrid, c(list(frame), spec$args), spec)
  objs  <- eval_specs(frame, spec$children)
  
  grid_specs <- lapply(spec$children, function(x) {
    x[['grid']]
  })
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Size the grid based upon the 'heights', 'widths' given to `tic_grid()`
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  for (row in seq_along(spec$heights)) {
    tcltk::tkgrid.rowconfigure (frame, row - 1L, weight = spec$heights[row])
  }
  for (col in seq_along(spec$widths)) {
    tcltk::tkgrid.columnconfigure (frame, col - 1L, weight = spec$widths[col])
  }
  # tcltk::tkgrid.columnconfigure(frame, 0, weight = 1)
  # tcltk::tkgrid.rowconfigure   (frame, 0, weight = 1)
  
  global_grid_spec <- modify_list(list(sticky = ""), spec$grid_def)
  
  for (i in seq_along(objs)) {
    obj       <- objs[[i]]
    grid_spec <- grid_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      this_grid_spec <- modify_list(global_grid_spec, grid_spec)
      do.call(tcltk::tkgrid, c(list(obj), this_grid_spec))
      # tcltk::tkgrid(obj, row = 0, column = i - 1, sticky = 'nsew')
    }
  }
  
  render_binding(frame, spec)
  pack_children(frame, objs)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a list of grid layout options used during widget creation
#' 
#' These grid options specify how a widget is packed into its parent element, 
#' if that element is a \code{tic_grid()}
#'
#' @param sticky If a grid cell is larger than its default dimensions for
#'        this widget, then 
#'        this option may be used to position (or stretch) the content within 
#'        its cell. \code{stick} is a string that contains zero or more of the
#'        characters n, s, e or w. 
#'        Each letter refers to a side
#'        (north, south, east, or west) that the content will “stick” to.
#'        If both n and s (or e and w) are specified, the content will 
#'        be stretched to fill the entire height (or width) of its cavity.
#'         The default is "", which causes the 
#'        content to be centered in its cell, at its default size.
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
#' @param row,column The row/column in the parent grid where this object should 
#'        be placed.  This should be an integer starting at 1.  If the row
#'        or col specified is larger than any specified size for the grid
#'        container, then the grid container is automatically sized to 
#'        include this cell.
#' @param rowspan,colspan how many rows or columns of the grid should be 
#'        spanned by this element. Default: 1.
#'
#' @param ... extra named args used by the packing spec. 
#'
#' @noRd
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on the elements are placed 
#' within a grid
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/grid.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
grid_opts <- function(sticky, row, column, rowspan, colspan, ipadx, ipady, padx, pady, ...) {
  opts <- find_args_simple(...)
  
  if (!is.null(opts$sticky)) {
    stopifnot(grepl('^[nsew]*$', opts$sticky))
  }
  stopifnot(num(opts$ipadx))
  stopifnot(num(opts$ipadu))
  stopifnot(num(opts$padx))
  stopifnot(num(opts$pady))
  stopifnot(num(opts$row))
  stopifnot(num(opts$col))
  stopifnot(num(opts$rowspan))
  stopifnot(num(opts$colspan))
  
  if (!is.null(opts$row   )) opts$row    <- opts$row - 1L
  if (!is.null(opts$column)) opts$column <- opts$column - 1L
  
  opts
}


if (FALSE) {
  
  grid_opts(expand = TRUE, anchor = 'sn', side = 'leftx')
  
}
