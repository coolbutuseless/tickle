

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Setup an idle callback to a user function at the given FPS while the window is alive
#' 
#' To stop the function: 
#' \itemize{
#'   \item{Close the window it is attached to}
#'   \item{Use a global logical value that is consulted inside the user func to determine if any action should be taken}
#' }
#'
#' 
#' 
#'
#'
#' @param win top level window object
#' @param user_func users R function.  This function will be called within the
#'        idle loop within any argumnets
#' @param fps desired frame rate. default: 30
#' @param initial_delay initial delay before running function for the first time. 
#'        In milliseconds.  Default: 1000
#' 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
launch_idle_func <- function(win, user_func, fps = 30, initial_delay = 100) {
  
  stopifnot(is.numeric(fps) && length(fps) == 1 && !is.na(fps) && fps > 0)
  
  fs <- init_fps_governor(fps)
  
  # Wrap the call to the users function, and call the wrapper
  wrapper <- function() {
    user_func()
    
    ms <- as.integer(fps_governor_ms(fps, fs))
    
    window_still_valid <- as.logical(tcltk::tkwinfo('exists', win))
    if (window_still_valid) {
      # message(ms, " ", Sys.time())
      tcltk::tcl('after', ms, wrapper)
    }  
  }
  
  window_still_valid <- as.logical(tcltk::tkwinfo('exists', win))
  if (window_still_valid) {
    # Wait a little before starting this event loop
    tcltk::tcl('after', initial_delay, wrapper)
  } else {
    stop("Window 'win' is no longer a valid open window")
  }  
  invisible(TRUE)
}




if (FALSE) {
  dot <- function() {
    cat("o")
  }

  ui_spec <- tic_window(
    idle_func = dot, idle_fps = 10,
    tic_button("hello")
  )
  
  win <- render_ui(ui_spec)
  
  
}