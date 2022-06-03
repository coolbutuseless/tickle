

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a popup window for choosing a colour
#' 
#' @param title Title to display on popup window
#' @param ... other named arguments used to initialise this widget
#'        
#' @export
#' 
#' @examples 
#' \dontrun{
#' popup_color_picker(message = 'hello')
#' }
#'
#" 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/chooseColor.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
popup_color_picker <- function(title = "Choose colourr", ...) {
  res <- tcl("tk_chooseColor", ...)
  tcltk::tclvalue(res)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Display a popup message box
#' 
#' @param message message to display. Required.
#' @param title window title 
#' @param type one of 'abortretryignore', 'ok', 'okcancel', 'retrycancel',
#'        'yesno', 'yesnocancel'
#' @param ... other options (experts)
#" 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/messageBox.html}
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' popup_messagebox(message = 'hello')
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
popup_messagebox <- function(message, type, title, ...) {
  
  args <- find_args_simple(...)
  
  res <- do.call(tcltk::tkmessageBox, args)

  tcltk::tclvalue(res)
}




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Dialogs for choosing a file to open and save
#' 
#' @param multiple allow the user to choose multiple files? default: FALSE
#' @param ... other arguments. See tcltk documentation for all possible options
#' 
#' @export
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/getOpenFile.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
popup_open_file <- function(multiple, ...) {
  
  spec      <- list(type = 'open file')
  spec$args <- find_args_simple(...)
  
  res <- call_tcltk(tcltk::tkgetOpenFile, spec$args, spec)
  
  as.character(res)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname popup_open_file
#' @param confirmoverwrite If user selects a filename which already exists,
#'        then show another popup to confirm overwriting this file. 
#'        Default: TRUE.
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
popup_save_file <- function(confirmoverwrite, ...) {
  
  spec      <- list(type = 'save file')
  spec$args <- find_args_simple(...)
  
  res <- call_tcltk(tcltk::tkgetSaveFile, spec$args, spec)
  
  as.character(res)
}



