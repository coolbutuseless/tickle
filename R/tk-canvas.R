


# tcl(canvas, 'create', 'line', 0, 0, 50, 50, 50, 100, 100, 50)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw a line on a canvas
#'
#' @param canvas a \code{tic_ui} 'canvas' element.
#' @param xs,ys vectors of coordinates
#' @param fill line colour
#' @param width line width e.g. \code{width = 2}
#' @param arrow where are arrowheads to be drawn?  Default: 'none'.  Possible
#'        values: 'none', 'first', 'last', 'both'
#' @param smooth should the line be draw as quadratic beziers instead of line segements?
#'        logical. default: FALSE
#' @param capstyle Specifies the ways in which caps are to be drawn at the 
#'        endpoints of the line: Possible values: butt, projecting, or round. 
#'        If this option is not specified then it defaults to butt. 
#'        Where arrowheads are drawn the cap style is ignored. 
#' @param joinstyle Specifies the ways in which joints are to be drawn at 
#'        the vertices of the line. Possible values: bevel, miter, or round). 
#'        If this option is not specified then it defaults to round. 
#' @param dash Specifies the line's dash pattern. This should be a numeric
#'        vector with alternating lengths of "dash" and "space-between-dash".
#'        E.g. \code{dash = c(6, 4, 2, 4)} produces a dotted-dashed line
#' @param ... other line creation options. See 
#'        \url{https://www.tcl.tk/man/tcl8.6/TkCmd/canvas.html#M26}
#'        
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_line <- function(canvas, xs, ys, fill, width, arrow, smooth, capstyle, 
                      joinstyle, dash, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$xs <- NULL
  args$ys <- NULL
  
  stopifnot(length(xs) == length(ys))
  
  # zip the x,y coords into pairs
  coords <- as.vector(rbind(xs, ys))
  
  spec <- list(type = 'canvas line')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("line"),
    coords,
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw a polygon on a canvas
#'
#' @inheritParams canvas_line
#' @param outline outline colour
#' 
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_polygon <- function(canvas, xs, ys, fill, outline, width, smooth, 
                         joinstyle, dash, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$xs <- NULL
  args$ys <- NULL
  
  stopifnot(length(xs) == length(ys))
  
  # zip the x,y coords into pairs
  coords <- as.vector(rbind(xs, ys))
  
  spec <- list(type = 'canvas polygon')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("polygon"),
    coords,
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw a polygon on a canvas
#'
#' @inheritParams canvas_polygon
#' @param x1,y1,x2,y2 corners of rectangle
#' 
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_rect <- function(canvas, x1, y1, x2, y2, fill, outline, width, 
                      dash, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$x1 <- NULL
  args$y1 <- NULL
  args$x2 <- NULL
  args$y2 <- NULL
  
  spec <- list(type = 'canvas rect')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("rectangle"),
    list(x1),
    list(y1),
    list(x2),
    list(y2),
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw an oval on a canvas
#'
#' @inheritParams canvas_rect
#' @param x1,y1,x2,y2 corners of rectangle enclosing the oval
#' 
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_oval <- function(canvas, x1, y1, x2, y2, fill, outline, width, 
                      dash, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$x1 <- NULL
  args$y1 <- NULL
  args$x2 <- NULL
  args$y2 <- NULL
  
  spec <- list(type = 'canvas oval')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("oval"),
    list(x1),
    list(y1),
    list(x2),
    list(y2),
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw an arc on a canvas
#'
#' @inheritParams canvas_oval
#' @param x1,y1,x2,y2 he coordinates of two diagonally opposite corners of a 
#'        rectangular region enclosing the oval that defines the arc
#' @param start starting angle of arc in degrees measured counter-clockwise 
#'        from the "3 o'clock" position. Value in range [-360, 360]
#' @param extent Size of te angle range occupied by the arc. Value in range [-360, 360]
#' @param style how to draw the arc. One of: pieslice (default), chord, fill
#'   \describe{
#'     \item{\code{pieslice}}{the arc's region is defined by a section of the 
#'           oval's perimeter plus two line segments, one between the center
#'            of the oval and each end of the perimeter section}
#'     \item{\code{chord}}{the arc's region is defined by a section of the 
#'           oval's perimeter plus a single line segment connecting the two 
#'           end points of the perimeter section}
#'     \item{\code{arc}}{the arc's region consists of a section of the perimeter 
#'           alone. In thiscase the \code{fill} option is ignored. }
#'   }
#' 
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_arc <- function(canvas, x1, y1, x2, y2, start, extent, style, fill, outline, width, 
                      dash, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$x1 <- NULL
  args$y1 <- NULL
  args$x2 <- NULL
  args$y2 <- NULL
  
  spec <- list(type = 'canvas arc')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("arc"),
    list(x1),
    list(y1),
    list(x2),
    list(y2),
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw text on a canvas
#'
#' @inheritParams canvas_line
#' @param x,y coorindates for text
#' @param text string to display
#' @param fill text colour
#' @param justify one of 'left', 'right', 'center'.  Default: left
#' @param angle default: 0
#'        
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_text <- function(canvas, x, y, text, fill, justify,  angle, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$x <- NULL
  args$y <- NULL
  
  spec <- list(type = 'canvas text')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("text"),
    list(x),
    list(y),
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Render an image a canvas
#'
#' @inheritParams canvas_text
#' @param x,y coorindates for image
#' @param image as loaded by \code{load_tkimage()} or otherwise manually created 
#'        with \code{tcltk}
#' @param anchor anchor point within image for positioning. default: center
#'        Possible values: n, s, e, w, ne, nw, se, sw, center
#'        
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_image <- function(canvas, x, y, image, anchor, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  args <- find_args_simple(...)
  args$canvas <- NULL
  args$x <- NULL
  args$y <- NULL
  
  spec <- list(type = 'canvas image')
  spec$args <- c(
    list(canvas),
    list("create"),
    list("image"),
    list(x),
    list(y),
    args
  )
  
  
  invisible(call_tcltk(tcltk::tcl, spec$args, spec))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Render a plot to the canvas
#'
#' @inheritParams canvas_text
#' @param plot object to be plotted.  Anything support by \code{ggplot2::ggsave()}
#' @param width,height size of plot in pizels
#' @param x,y coorindates for image. default (0, 0)
#' @param anchor anchor point within image for positioning. default: nw
#'        Possible values: n, s, e, w, ne, nw, se, sw, center
#'        
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_plot <- function(canvas, plot, width, height, x = 0, y = 0, anchor = 'nw') {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  temp <- tempfile(fileext = ".png")
  
  if (requireNamespace('ggplot2', quietly = TRUE)) {
    ggplot2::ggsave(
      filename = temp,
      plot     = plot,
      width    = width,
      height   = height,
      units    = 'px'
    )
  } else {
    stop("Need 'ggplot2' for rendering to a canvas.")
  }
  
  im <- load_tkimage(temp)
  invisible(canvas_image(canvas, x = x, y = y, image = im, anchor = anchor))
}




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Clear the canvas of all objects
#' 
#' @inheritParams canvas_text
#' 
#' @export
#' @family canvas
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_clear <- function(canvas) {
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  tags <- tcltk::tcl(canvas, "find", 'all')
  
  for (tag in as.character(tags)) {
    tcltk::tcl(canvas, 'delete', tag)
  }
  
  invisible()
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Save the contents of the canvas to file
#' 
#' tcl/tk only exports the canvas as a PS (Postscript) file.  In this function,
#' the \code{magick} package is used to read the postscript file and render it
#' to an image file based upon the suffix supplied in the \code{filename} argument.
#' 
#' @inheritParams canvas_text
#' @param filename where the image should be saved.  The image suffix will be 
#'        used as the \code{format} argument to the call to \code{magick::image_write()} 
#' @param ps_density DPI. Resolution to postscript document. This corresponds to 
#'        the \code{density} argument in {magick::image_read()}.  Default: NULL
#'        means to use whatever \code{magick} package defaults to.  
#' @param ... all other arguments passed to \code{magick::image_write()}
#' 
#' @export
#' 
#' @family canvas
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
canvas_save <- function(canvas, filename, ps_density = NULL, ...) {
  
  if (!(inherits(canvas, "tic_ui") && identical(canvas$type, 'canvas'))) {
    warning("Really expecting a tic_ui object of type 'canvas' here")
  }
  
  if (!requireNamespace('magick', quietly = TRUE)) {
    stop("Need 'magick' package installed to export canvas as an image")
  } else {
    psfile <- tempfile(fileext = ".ps")
    tcltk::tcl(canvas, 'postscript', file = psfile)
    im <- magick::image_read(psfile, density = ps_density)
    format <- tolower(tools::file_ext(filename))
    magick::image_write(im, filename, format = format, ...)
  }  
  
  invisible(filename)
}



