

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load the themes when starting up
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.onLoad <- function(...) {

  # Ensure there's a DISPLAY to operate on before initialising stuff.
  # E.g. github actions ci doesn't have a display, so it can't start Tk
  if (base::Sys.getenv('DISPLAY') != "") {
    all_themes <- as.character(tcltk::tcl('ttk::style', 'theme', 'names'))
    
    if (!'r-sun-valley-light' %in% all_themes) {
      theme_file <- system.file("r-sun-valley/r-sun-valley.tcl", package = "tickle", mustWork = TRUE)
      tcltk::tcl('source', theme_file)
    }
    
    tcltk::tcl('ttk::style', 'theme', 'use', 'r-sun-valley-light')
    
    set_font_scale(1)
  }
}