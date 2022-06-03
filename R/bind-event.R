


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Bind a command to a particular event
#' 
#' The bind command associates R functions with UI events. 
#' 
#' \code{bind_opts} is used to define binding events within the UI spec.
#' 
#' After the UI is created (with a call to \code{win = render_ui(ui_spec)}),
#' events can be bound with \code{bind_event(...)}.
#' 
#' 
#'
#' @param tag the \code{tic_ui} object
#' @param event the event to watch for on this object.  
#' 
#' The general form of an event is "modifiers-type-detail" 
#' 
#' @param command R function to run when this even occurs. 
#' 
#' @section examples:
#' 
#'   \describe{
#'     \item{\code{"c"}}{keyboard character 'c'}
#'     \item{\code{"Control-q"}}{Key combination CTRL+q}
#'     \item{\code{"ButtonPress"}}{Any button press}
#'     \item{\code{"KeyPress"}}{Any keypress}
#'     \item{\code{"Double-Button-1"}}{Double click on Mouse Button number 1}
#'   }
#' 
#' @section modifiers:
#' 
#' Control, Alt, Shift, Lock, Button1-Button5, Mod1-Mod5, Meta
#'            Double, Triple, Quadruple
#' 
#' @section events:           
#' 
#' Activate, ButtonPress, Button, ButtonRelease, Circulate, CirculateRequest,
#' Configure, ConfigureRequest, Create, Deactivate, Destroy, Enter, Expose, 
#' FocusIn, FocusOut, Gravity, KeyPress, Key, KeyRelease, Leave, Map, 
#' MapRequest, Motion, MouseWheel, Property, Reparent, ResizeRequest, 
#' Unmap, Visibility 
#'            
#' @section variables:
#' 
#' Variables available to the \code{command} depend upon the event.  See
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/bind.html} for the full list.         
#'            
#' some variables are listed here:
#' 
#' \describe{
#'   \item{\code{b}}{The number of the button that was pressed or released. 
#'         Valid only for ButtonPress and ButtonRelease events. }
#'   \item{\code{k}}{The keycode field from the event. Valid only for 
#'         KeyPress and KeyRelease events.}
#'   \item{\code{K}}{The keysym corresponding to the event, substituted as a 
#'         textual string. Valid only for KeyPress and KeyRelease events. }
#'   \item{\code{t}}{time stamp of the event}
#'   \item{\code{x,y}}{indicate the position of the mouse pointer relative to 
#'         the UI window. }
#'   \item{\code{X, Y}}{indicate the position of the mouse pointer in absolute
#'         screen coordinates}
#'   \item{\code{D}}{This reports the delta value of a MouseWheel event. 
#'         The delta value represents the rotation units the mouse wheel 
#'         has been moved. The sign of the value represents the direction 
#'         the mouse wheel was scrolled. }
#'   \item{\code{}}{}
#'   \item{\code{}}{}
#'   \item{\code{}}{}
#' }            
#'            
#'            
#' @examples 
#' \dontrun{
#' # Every mouse press prints coordinates
#' ui_spec <- tic_window()
#' win <- render_ui(ui_spec)
#' bind_event(win, "Button", function(t, x, y, ...) { message(t, ": ", x, ", ", y)})
#' }
#' 
#' 
#' @export
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on binding commands to events
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/bind.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bind_event <- function(tag, event, command) {
  
  # Allow the user to pass in a bare event name e.g. "Button" instead of 
  # "<Button>".
  if (!startsWith(event, "<")) {
    event <- paste0("<", event, ">")
  }
  
  spec <- list(
    type = 'bind', 
    args = list(tag, event, command)
  )
  invisible(call_tcltk(tcltk::tkbind, spec$args, spec))
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname bind_event
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bind_opts <- function(event, command) {
  
  # Allow the user to pass in a bare event name e.g. "Button" instead of 
  # "<Button>".
  if (!startsWith(event, "<")) {
    event <- paste0("<", event, ">")
  }
  
  # ToDo: Sanity check all the event names against the master list.
  
  structure(
    list(
      event   = event,
      command = command
    ),
    class = "tic_bind"
  )
  
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Render all the bindings for the given element
#'
#' @param elem a tclObj / tic_ui object.
#' @param spec a UI spec
#'
#' attach all event bindings to this element
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_binding <- function(elem, spec) {
  
  # Multiple events may be bound on a single element
  binding <- spec$binding
  
  if (inherits(binding, 'tic_bind') || !is.null(binding$event)) {
    # single binding statement
    # message("Binding ", binding$event, " to ", spec$type)
    binding$tag <- elem
    do.call(bind_event, binding)
  } else {
    # Treat it as a list of 
    for (this_args in binding) {
      # message("Binding ", this_args$event, " to ", spec$type)
      this_args$tag <- elem
      do.call(bind_event, this_args)
    }
  }
  
  elem
}





