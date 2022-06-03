

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Pack children as named elements on the parent object
#
# Note that because you can have muliple "buttons" in a container (for example)
# will need to suffix the repeated names with number 1..N
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pack_children <- function(obj, children) {
  
  names <- vapply(children, function(x) {x$type}, character(1))
  
  for (name in names) {
    count <- sum(names == name)
    if (count > 1) {
      names[names == name] <- paste0(names[names == name], seq(count))
    }
  }
  
  
  for (i in seq_along(children)) {
    name <- names[[i]]
    obj[[name]] <- children[[i]]
  }
  
  as_tic_ui(obj)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Helper function to sanitize the weights for fluid row/col sizes
#' 
#' @param weights numerc vector of weights
#' @param N the expected length based upon the number of objects within this layout
#'
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sanitize_weights <- function(weights, N) {
  if (is.null(weights)) {
    weights <- rep(1, N)
  } else if (length(weights) == 1) {
    weights <- rep(weights, N)
  } else {
    stopifnot(length(weights) == N)
  }
  stopifnot(!anyNA(weights))
  weights
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create the top level window
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/toplevel.html}
#' 
#' @inheritParams tic_button
#' @inheritParams tic_labelframe
#' @param title Window Title
#' @param width,height width and height of window.  If not given then 
#'        UI will be automatically sized.
#'
#' @import tcltk
#' @return the tcl/tk window handle
#' @export
#' 
#' @family widgets containers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_window <- function(..., title = "{tickle}", width = NULL, height = NULL,
                       bind = NULL, pack = NULL, pack_def = NULL) {
  
  args <- find_args(..., ignore = c('width', 'height'))
  args$named$title  <- NULL
  
  spec <- list(
    args     = args$named,
    type     = 'window',
    children = args$unnamed,
    binding  = bind,
    title    = title,
    width    = width,
    height   = height
  )
  class(spec) <- 'tic_spec'
  spec
}


# parent is ignored for tic_window rendering
render_tic_window <- function(parent = NULL, spec) {
  stopifnot(identical(spec$type, 'window'))
  stopifnot(`parent must be NULL for tic_window()` = is.null(parent))
  
  spec$args <- handle_images(spec$args)
  container <- call_tcltk(tcltk::tktoplevel, spec$args, spec)
  tcltk::tkwm.title(container, spec$title) # Set title
  
  # Set the window geometry if width/height given
  if (!is.null(spec$width) && !is.null(spec$height)) {
    geom <- paste0(spec$width, "x", spec$height)
    tcltk::tkwm.geometry(container, geom)
  }
  
  objs <- eval_specs(parent = container, specs = spec$children)
  
  pack_specs <- lapply(spec$children, function(x) {
    x[['pack']]
  })
  
  container_pack_opts <- modify_list(
    list(side = 'left', expand = TRUE, fill = 'both', padx = 1, pady = 1),
    spec$pack_def
  )
  
  for (i in seq_along(objs)) {
    obj            <- objs[[i]]
    this_pack_opts <- pack_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      pack_opts <- modify_list(container_pack_opts, this_pack_opts)
      do.call(tcltk::tkpack, c(list(obj), pack_opts))
    }
  }
  
  render_binding(container, spec)
  pack_children(container, objs)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Container widgets with/without label label
#' 
#' A labelframe widget is a container used to group other widgets together.
#' 
#' It has a label.
#' 
#' @inheritParams tic_button
#' @param text Label to display for this frame. Character string.
#' @param relief border style. One of: flat, groove, raised, ridge, solid
#'        sunken.  Defaults to: 'flat'
#' @param borderwidth desired width of widget border
#' @param pack_def Default packing options for children of this object. This
#'        can be overriden by setting \code{pack} explicitly on child elemnets
#'        you want to control packing for.
#'
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets containers
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_labelframe.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_labelframe <- function(..., text, relief, borderwidth, 
                           bind = NULL, pack = NULL, pack_def = NULL) {
  
  args <- find_args(...)
  
  spec <- list(
    args     = args$named,
    type     = 'labelframe',
    children = args$unnamed,
    binding  = bind,
    pack     = pack,
    pack_def = pack_def
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a labelframe
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_labelframe <- function(parent, spec) {
  stopifnot(identical(spec$type, 'labelframe'))
  spec$args <- handle_images(spec$args)
  container <- call_tcltk(tcltk::ttklabelframe, c(list(parent), spec$args), spec)
  objs <- eval_specs(parent = container, specs = spec$children)
  pack_specs <- lapply(spec$children, function(x) {
    x[['pack']]
  })
  
  container_pack_opts <- modify_list(
    list(side = 'left', expand = TRUE, fill = 'both', padx = 1, pady = 1),
    spec$pack_def
  )
  
  for (i in seq_along(objs)) {
    obj            <- objs[[i]]
    this_pack_opts <- pack_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      pack_opts <- modify_list(container_pack_opts, this_pack_opts)
      do.call(tcltk::tkpack, c(list(obj), pack_opts))
    }
  }
  
  
  render_binding(container, spec)
  pack_children(container, objs)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname tic_labelframe
#' @export
#' 
#' @family widgets containers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_frame <- function(..., relief, borderwidth, 
                      bind = NULL, pack = NULL) {
  
  args <- find_args(...)
  
  spec <- list(
    args     = args$named,
    type     = 'frame',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a labelframe
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_frame <- function(parent, spec) {
  stopifnot(identical(spec$type, 'frame'))
  container <- call_tcltk(tcltk::ttkframe, c(list(parent), spec$args), spec)
  objs <- eval_specs(parent = container, specs = spec$children)
  pack_specs <- lapply(spec$children, function(x) {
    x[['pack']]
  })
  
  container_pack_opts <- modify_list(
    list(side = 'left', expand = TRUE, fill = 'both', padx = 1, pady = 1),
    spec$pack_def
  )
  
  for (i in seq_along(objs)) {
    obj            <- objs[[i]]
    this_pack_opts <- pack_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      pack_opts <- modify_list(container_pack_opts, this_pack_opts)
      do.call(tcltk::tkpack, c(list(obj), pack_opts))
    }
  }
  
  
  render_binding(container, spec)
  pack_children(container, objs)
}






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a container element oriented as a row or column of elements
#' 
#' This is not a direct analogy for a single tk element
#' 
#' @inheritParams tic_button
#' @inheritParams tic_labelframe
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' 
#' @section tcl/tk:
#'
#' This is not a direct implementation for an existing tk element. It is implemented
#' as a \code{ttk::frame} element with horizontal or vertical packing by default.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_row <- function(..., bind = NULL, pack = NULL, pack_def = NULL) {
  args <- find_args(...)
  
  args$named$sizes  <- NULL
  
  spec <- list(
    args     = args$named,
    type     = 'row',
    children = args$unnamed,
    binding  = bind,
    pack     = pack,
    pack_def = pack_def
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname tic_row
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_col <- function(..., bind = NULL, pack = NULL, pack_def = NULL) {
  args <- find_args(...)
  
  args$named$sizes  <- NULL
  
  spec <- list(
    args     = args$named,
    type     = 'col',
    children = args$unnamed,
    binding  = bind,
    pack     = pack,
    pack_def = pack_def
  )
  class(spec) <- 'tic_spec'
  spec
}




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_row <- function(parent, spec) {
  stopifnot(identical(spec$type, 'row'))
  
  frame  <- call_tcltk(tcltk::ttkframe, c(list(parent), spec$args), spec)
  objs   <- eval_specs(frame, spec$children)
  
  pack_specs <- lapply(spec$children, function(x) {
    x[['pack']]
  })
  
  container_pack_opts <- modify_list(
    list(side = 'left', expand = TRUE, fill = 'both', padx = 1, pady = 1),
    spec$pack_def
  )
  
  for (i in seq_along(objs)) {
    obj            <- objs[[i]]
    this_pack_opts <- pack_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      pack_opts <- modify_list(container_pack_opts, this_pack_opts)
      do.call(tcltk::tkpack, c(list(obj), pack_opts))
    }
  }
  
  
  render_binding(frame, spec)
  pack_children(frame, objs)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_col <- function(parent, spec) {
  stopifnot(identical(spec$type, 'col'))
  
  frame   <- call_tcltk(tcltk::ttkframe, c(list(parent), spec$args), spec)
  objs    <- eval_specs(frame, spec$children)
  pack_specs <- lapply(spec$children, function(x) {
    x[['pack']]
  })
  
  container_pack_opts <- modify_list(
    list(side = 'top', expand = TRUE, fill = 'both', padx = 1, pady = 1),
    spec$pack_def
  )
  
  for (i in seq_along(objs)) {
    obj            <- objs[[i]]
    this_pack_opts <- pack_specs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      pack_opts <- modify_list(container_pack_opts, this_pack_opts)
      do.call(tcltk::tkpack, c(list(obj), pack_opts))
    }
  }
  
  
  render_binding(frame, spec)
  pack_children(frame, objs)
}




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Panedwindow:  Multi-pane container window
#' 
#' A ttk::panedwindow widget displays a number of subwindows, stacked 
#' either vertically or horizontally. The user may adjust the relative sizes 
#' of the subwindows by dragging the sash between panes. 
#' 
#' @inheritParams tic_button
#' @param sizes The relative sizes of the elements in this row or column
#' @param orient orientataion. 'horizontal' or 'vertical' (default)
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @section tcl/tk:
#' 
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_panedwindow.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_panedwindow <- function(..., sizes = NULL, orient, 
                            bind = NULL, pack = NULL) {
  args <- find_args(...)
  
  args$named$sizes  <- NULL
  
  spec <- list(
    args     = args$named,
    type     = 'panedwindow',
    children = args$unnamed,
    binding  = bind,
    sizes    = sizes,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_panedwindow <- function(parent, spec) {
  stopifnot(identical(spec$type, 'panedwindow'))
  
  pwindow <- call_tcltk(tcltk::ttkpanedwindow, c(list(parent), spec$args), spec)
  objs    <- eval_specs(pwindow, spec$children)
  sizes   <- sanitize_weights(weights = spec$sizes, N = length(objs))
  
  for (i in seq_along(objs)) {
    obj <- objs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      tcltk::tkadd(pwindow, obj, weight = sizes[[i]])
    }
  }
  
  render_binding(pwindow, spec)
  pack_children(pwindow, objs)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Notebook:  Multi-paned container window i.e. a window with multiple tabs.
#' 
#' A notebook widget manages a collection of windows and displays a single 
#' one at a time. 
#' 
#' Each content window is associated with a tab, which the user may select 
#' to change the currently-displayed window. 
#' 
#' @inheritParams tic_button
#' @param labels Labels to display at the top of each tab. Required.
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @section tcl/tk:
#' 
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_notebook.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_notebook <- function(..., labels, bind = NULL, pack = NULL) {
  args <- find_args(...)
  
  args$named$labels <- NULL
  
  if (length(labels) != length(args$unnamed)) {
    stop("Number of 'labels' and does not match number of child elements in container: ", length(labels), " != ", length(args$unnamed))
  }
  
  spec <- list(
    args     = args$named,
    type     = 'notebook',
    children = args$unnamed,
    binding  = bind,
    labels   = labels,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_notebook <- function(parent, spec) {
  stopifnot(identical(spec$type, 'notebook'))
  
  nbook   <- call_tcltk(tcltk::ttknotebook, c(list(parent), spec$args), spec)
  objs    <- eval_specs(nbook, spec$children)
  
  for (i in seq_along(objs)) {
    obj <- objs[[i]]
    
    if (!obj$type %in% c('menu', 'submenu')) {
      tcltk::tkadd(nbook, obj, text = spec$labels[[i]])
    }
  }
  
  render_binding(nbook, spec)
  pack_children(nbook, objs)
}




