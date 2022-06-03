

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Activate a known theme by name
#' 
#' For advanced users, you can load a theme from a file using
#' \code{tcltk::tcl('source', theme_file)}, before calling \code{set_theme()}
#' 
#' @param theme_name name of theme. By default this will load the built-in 
#'        theme developed for R.  
#'        Use \code{list_themes()} to see what themes are available.
#' 
#' @return none
#' 
#' @examples{
#' \dontrun{
#' list_themes()
#' set_theme('default')
#' }
#' }
#' 
#' @family themes
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set_theme <- function(theme_name = 'r-sun-valley-light') {
  all_themes <- list_themes()
  if (theme_name %in% all_themes) {
    tcltk::tcl('ttk::style', 'theme', 'use', theme_name)
  } else {
    stop("Theme not found.")
  }
  invisible()
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Get a list of active themes
#' 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
list_themes <- function() {
  as.character(tcltk::tcl('ttk::style', 'theme', 'names'))
}




default_fonts <- c(
  'TkDefaultFont'      = 12,
  'TkTextFont'         = 12, 
  'TkFixedFont'        = 12, 
  'TkMenuFont'         = 12, 
  'TkHeadingFont'      = 12, 
  'TkCaptionFont'      = 14, 
  'TkSmallCaptionFont' = 10, 
  'TkIconFont'         = 12
)

heading_fonts <- c('h1', 'h2', 'h3', 'h4', 'h5')

all_font_names <- c(names(default_fonts), heading_fonts)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Globally scale the fonts in the rendered UI
#'
#' @param scale numeric scale factor. default 1.0
#' 
#' @return none.
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set_font_scale <- function(scale) {

  
  # possible font properties
  # family: sans-serif, monospace, serif, Helvetica, Courier, Times
  # size: numeric
  # weight: normal, bold
  # slant: roman, italic
  # underline: 0/1
  # overstrike: 0/1
  
  if (FALSE) {
    for (font in names(default_fonts)) {
      print(tcltk::tkfont.configure(font))
    }
  }
  
  
  
  for (i in seq_along(default_fonts)) {
    tcltk::tkfont.configure(
      names(default_fonts)[i],        # font name
      size = as.integer(round(default_fonts[i] * scale)) # property
    )
  }
  
  setup_header_fonts()
  
  invisible()
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' List all the font families present
#' 
#' @return character vector of names
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
list_font_families <- function() {
  sort(unique(as.character(tcltk::tkfont.families())))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Set the font family 
#' 
#' @param body name of font family for body text, buttons, menus etc
#' @param headings name of the font family for the h1-h5 headings for labels.
#'        by default this will be set to the same as the \code{body} font.
#' 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set_font_family <- function(body = NULL, headings = body) {
  
  for (font_name in names(default_fonts)) {
    tcltk::tkfont.configure(font_name, family = body)
  }
  
  for (font_name in heading_fonts) {
    tcltk::tkfont.configure(font_name, family = body)
  }
  
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Setup fonts h1 .. h5 for using as header labels
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
setup_header_fonts <- function() {
  default <- as.character(tcltk::tkfont.configure('TkDefaultFont'))
  default <- gsub("^-", "", default)
  default <- matrix(default, nrow = 2)
  arg_names  <- default[1, ]
  arg_values <- default[2, ]
  args <- as.list(arg_values)
  names(args) <- arg_names
  args$size <- as.integer(args$size)
  args$weight <- 'bold'
  
  h1_args <- args
  h2_args <- args
  h3_args <- args
  h4_args <- args
  h5_args <- args
  
  h1_args$size <- as.integer(round(args$size * 3.0))
  h2_args$size <- as.integer(round(args$size * 2.0))
  h3_args$size <- as.integer(round(args$size * 1.5))
  h4_args$size <- as.integer(round(args$size * 1.25))
  h5_args$size <- as.integer(round(args$size * 1.1))
  
  
  if ('h1' %in% as.character(tkfont.names())) tcltk::tkfont.delete("h1")
  if ('h2' %in% as.character(tkfont.names())) tcltk::tkfont.delete("h2")
  if ('h3' %in% as.character(tkfont.names())) tcltk::tkfont.delete("h3")
  if ('h4' %in% as.character(tkfont.names())) tcltk::tkfont.delete("h4")
  if ('h5' %in% as.character(tkfont.names())) tcltk::tkfont.delete("h5")
  
  
  h1 <- do.call(tcltk::tkfont.create, c(list("h1"), h1_args))
  h2 <- do.call(tcltk::tkfont.create, c(list("h2"), h2_args))
  h3 <- do.call(tcltk::tkfont.create, c(list("h3"), h3_args))
  h4 <- do.call(tcltk::tkfont.create, c(list("h4"), h4_args))
  h5 <- do.call(tcltk::tkfont.create, c(list("h5"), h5_args))
}




if (FALSE) {
  

  
  tcltk::tkfont.configure(h3)
}














