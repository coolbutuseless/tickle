

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Load an image as a \code{tikimage}
#' 
#' imagemagick is needed here to convert any image input into a PNG.  And 
#' to also create a simple PNG that tcltk can parse - it seems a bit picky
#' about unknown chunks rather than just ignoring them.
#'
#' @param image_filename path to image
#' 
#' @return a \code{tkimage} objectwhich can be used as the \code{image} 
#'         argument of many widgets e.g. \code{tic_button()}
#'
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
load_tkimage <- function(image_filename) {
  
  if (!requireNamespace('magick', quietly = TRUE)) {
    message("The {magick} package is not installed. Attempting to load directly.\n", 
            "For greatest image compatability please install {magick}")
    tmp_filename <- image_filename
  } else {
    # Write the file to a known good PNG file that tcl/tk can read natively
    tmp_filename <- tempfile(fileext = ".png")
    
    env$img_count <- env$img_count + 1L
    img_tag <- tools::file_path_sans_ext(basename(image_filename))
    img_tag <- gsub("\\s", "-", img_tag)
    img_tag <- sprintf("::img::%s%04i", img_tag, env$img_count)
    # message(img_tag)
    im <- magick::image_read(image_filename, strip = TRUE)
    magick::image_write(im, path = tmp_filename, flatten = TRUE)
  }
  
  obj <- tcltk::tkimage.create("photo", img_tag, file = tmp_filename)
  
  obj
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Sanitize an argument list to replace any image paths with a tkimage object
#' 
#' @param args list of args as part of a \code{tic_spec}
#' 
#' @return list of args with any \code{image} arguments replaced by a \code{tkimage} object
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
handle_images <- function(args) {
  if (!is.null(args[['image']])) {
    # The 'image' argument in a 'tic_spec' is assumed to refer to a file.
    if (!(file.exists(args[['image']]))) {
      stop("'image' file not found: ", args[['image']])
    }
    args[['image']] <- load_tkimage(args[['image']])
  }
  
  args
}



