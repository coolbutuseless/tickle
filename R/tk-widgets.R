
is_missing_arg <- function(x) {
  identical(x, quote(expr = ))
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find all given arguments of the caller
#' 
#' This function drops formal arguments that have not been given an actual 
#' value.
#' 
#' This idea is borrowed from \code{ggplot2:::find_args()}
#' 
#' @param ... The dots passed in from the actual function call
#' @param ignore extra named arguments to ignore
#'
#' @return list of different argument types
#' 
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
find_args <- function (..., ignore = c())  {
  env <- parent.frame()
  args <- names(formals(sys.function(sys.parent(1))))
  vals <- mget(args, envir = env)
  vals <- vals[!vapply(vals, is_missing_arg, logical(1))]
  
  named_args   <- modify_list(vals, list(..., ... = NULL))
  unnamed_args <- Filter(\(x) {inherits(x, 'tic_spec')}, list(...))
  
  extra_args <- Filter(\(x) {!inherits(x, 'tic_spec') && !inherits(x, 'tic_bind')}, list(...))
  if (length(extra_args) > 0) {
    if (!is.null(names(extra_args))) {
      extra_args <- extra_args[names(extra_args) == '']
    }
    if (length(extra_args) > 0) {
      message("Got useless args: ", deparse1(unname(extra_args)))
    }
  }
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Ignore some specific named arguments as they are not captured arguments
  # for the tcltk call to build the widget
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  always_ignore <- c('pack', 'pack_def', 'bind')
  ignore <- union(ignore, always_ignore)
  named_args <- named_args[setdiff(names(named_args), ignore)]
  
  list(
    named   = unpack_reactives(named_args),
    unnamed = unnamed_args,
    extra   = extra_args
  )
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Recursively evaluate a single tic_spec objects in the context of a parent object
#' 
#' @param parent tcl object
#' @param spec single \code{tic_spec}. This may have its own child elements
#'        
#' @return None.  This code creates the tcl objects for the GUI and adds them
#'         to the parent node for immediate display.
#' 
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
eval_spec <- function(parent, spec) {
  # message("eval_spec: ", spec$type, "  N children: ", length(spec$children))
  this_obj <- switch(
    spec$type,
    window      = render_tic_window     (parent, spec),
    labelframe  = render_tic_labelframe (parent, spec),
    frame       = render_tic_frame      (parent, spec),
    
    row         = render_tic_row        (parent, spec),
    col         = render_tic_col        (parent, spec),
    panedwindow = render_tic_panedwindow(parent, spec),
    notebook    = render_tic_notebook   (parent, spec),
    
    
    label       = render_tic_label      (parent, spec),
    button      = render_tic_button     (parent, spec),
    checkbutton = render_tic_checkbutton(parent, spec),
    radiobutton = render_tic_radiobutton(parent, spec),
    
    menubutton  = render_tic_menubutton (parent, spec),
    menu        = render_tic_menu       (parent, spec),
    
    canvas      = render_tic_canvas     (parent, spec),
    
    spinbox     = render_tic_spinbox    (parent, spec),
    combobox    = render_tic_combobox   (parent, spec),
    textentry   = render_tic_textentry  (parent, spec),
    textbox     = render_tic_textbox    (parent, spec),
    progressbar = render_tic_progressbar(parent, spec),
    slider      = render_tic_slider     (parent, spec),
    
    separator   = render_tic_separator  (parent, spec),
    sizegrip    = render_tic_sizegrip   (parent, spec),
    stop("Unknown spec type: ", spec$type)
  )
  
  this_obj
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Recursively evaluate a list of tic_spec objects in the context of a parent object
#' 
#' @param parent tcl object
#' @param specs list of \code{tic_spec} options for child elements of this parent.
#'        Each spec can further have its own child elements
#'        
#' @return None.  This code creates the tcl objects for the GUI and adds them
#'         to the parent node for immediate display.
#' 
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
eval_specs <- function(parent, specs) {
  lapply(specs, function(spec) { eval_spec(parent, spec) })
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Render a complete UI given a spec for a window with child elements
#' 
#' @param spec UI spec as created using \code{tic_window()}, 
#'        \code{tic_button()} etc
#' @param parent parent object.  The default 'NULL' value is only allowed
#'        for \code{tic_window()} objects. Otherwise this should be a 
#'        \code{tclObj} holding a reference to a window.
#'        TODO: parent could also be something else done by a render_ui call?
#'        
#' @return a nested named list of tcl objects making up the UI.  For advanced users
#'         that want to do low-level manipulation of the window, these 
#'         \code{tclObj} objects are a key argument to functions in 
#'         the \code{tcltk} package.
#' 
#'         The key side
#'         effect of this function is that a tcl/tk window will be opened and
#'         rendered to this specficiation.
#'         
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_ui <- function(spec, parent = NULL) {
  res <- eval_specs(parent, list(spec))[[1]]
  
  class(res) <- union('tic_ui', class(res))
  res
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Render a widget with error trapping and standard post-processing
#'
#' @param func function e.g. \code{tcltk::ttkbutton}
#' @param args list of args 
#' @param spec the original specification for this object
#'
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
call_tcltk <- function(func, args, spec) {
  obj <- tryCatch({
    # Render widget
    do.call(func, args)
  },
  error = function(e) {
    # If there was an error creating, then reparse the error into something
    # not quite as awful as the tcltk default.
    # Also tell the user what they were trying to create when the error 
    # occurred
    msg <- sprintf("Could not create '%s' with specification:\n%s\n\n%s", 
                   spec$type, deparse1(spec$args), e$message)
    stop(msg, call. = FALSE)
  })
  
  if (spec$type %in% c('open file', 'save file', 'bind')|| 
      startsWith(spec$type, "canvas ")) {
    obj
  } else if (spec$type %in% c('menuitem', 'submenu') ) {
    class(obj) <- union('tic_ui', class(obj))
    obj
  } else {
    obj$type <- spec$type
    as_tic_ui(obj)
  }
  
}




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Button that runs a command when pressed 
#' 
#' A button widget displays a textual label and/or image, and evaluates a 
#' command when pressed. 
#' 
#' @param ... Other arguments are parsed as follows:
#'   \describe{
#'     \item{\code{named arguments}}{Further options to be used during the creation 
#'           of this widget.  See the tcl/tk documentation for all arguments possible
#'           for this widget.}
#'     \item{\code{unnamed arguments}}{Container widgets (e.g. \code{tic_frame()}) treat any 
#'           unnamed arguments as child objects.   Non-container widgets 
#'           (e.g \code{tic_button()}) will
#'           raise an error if there are any unnamed widgets.}
#'  }
#' @param text,textvariable Specifies a text string to be displayed inside the widget.
#' \describe{
#'   \item{\code{text}}{Simple character string containing the name}
#'   \item{\code{textvariable}}{Reactive variable containing a string}
#' }
#' @param command Function to evaluate when the widget is invoked. 
#' @param image pathname of image to display
#' @param compound Specifies how to display the image relative to the text, 
#'       in the case both \code{text} and \code{image} are present.
#'       Possible values: 
#' \describe{
#'   \item{\code{text}}{Display text only}
#'   \item{\code{image}}{Display image only}
#'   \item{\code{top,bottom,left,right,center}}{Display image with this position relative
#'               to the text}
#'   \item{\code{none}}{Display the image if present, otherwise the text}
#' }
#' @param width If greater than zero, specifies how much space, in character 
#'        widths, to allocate for the text label. If less than zero, specifies 
#'        a minimum width. If zero or unspecified, the natural width of the 
#'        text label is used. 
#' @param pack a named list of pack options for how to incorporate this element into its 
#'        parent container.  Default: NULL means to use the standard packing.
#'        See \code{pack_opts()} as a way of creating a valid list of pack options.
#' @param bind bind commands to particular events on this element. This may be 
#'        a single result of \code{bind_opts()} or a list of them for multiple
#'        events.
#'  
#' @return A \code{tic_spec} object containing the widget specification.
#' @export
#' 
#' @family widgets
#' 
#' @examples 
#' \dontrun{
#'   tic_window(
#'     title = "Hello",
#'     tic_button(text = "Button", command = function() { message("Button clicked") })
#'   )
#' }
#' 
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_button.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_button <- function(text, command, textvariable, image, compound, width, bind = NULL,
                       pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_button()'` = length(args$unnamed) == 0)
  
  # Augment style with ".TButton" suffix if not given
  if (!is.null(args$named$style)) {
    if (!endsWith(args$named$style, ".TButton")) {
      args$named$style <- paste0(args$named$style, ".TButton")
    }
  }
  
  spec <- list(
    args     = args$named,
    type     = 'button',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a button
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_button <- function(parent, spec) {
  stopifnot(identical(spec$type, 'button'))
  
  spec$args <- handle_images(spec$args)
  
  obj <- call_tcltk(
    func = tcltk::ttkbutton,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a text label
#' 
#' @inheritParams tic_button
#' @param style specify the style for this label. Possible values are "h1" 
#'        through "h5" which are analogues to the h1 to h5 headings in HTML, with
#'        "h1" being the largest heading size, down to "h5" being the smallest.
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_label.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_label <- function(text, textvariable, width, style, bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_label()'` = length(args$unnamed) == 0)
  
  # Augment style with ".TLabel" suffix if not given
  if (!is.null(args$named$style)) {
    if (!endsWith(args$named$style, ".TLabel")) {
      args$named$style <- paste0(args$named$style, ".TLabel")
    }
  }
  
  
  spec <- list(
    args     = args$named,
    type     = 'label',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a label
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_label <- function(parent, spec) {
  stopifnot(identical(spec$type, 'label'))
  
  obj <- call_tcltk(
    func = tcltk::ttklabel,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' A button which toggles between two states
#' 
#' A checkbutton is used to show or change a setting. It has two states, 
#' \code{selected} and \code{deselected}. 
#' 
#' The state of the checkbutton should be linked to a \code{reactive_lgl} logical variable using
#' \code{variable} argument.
#' 
#' @inheritParams tic_button
#' @param variable The variable containing the state of the button. Create this 
#'        variable with \code{reactive_lgl}.
#' @param style Default behaviour is to use a checkbox stye button.  With the
#'        build in theme in this package, two other styles are possible:
#' \describe{
#'   \item{\code{''toggle}}{The button will look like a regular button but will 
#'         alternate between 'on' and 'off' states with each press}
#'   \item{\code{'switch'}}{The button will look like a sliding switch which
#'         slides from one side to the other with each press}
#' }
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples 
#' alert = reactive_lgl(FALSE)
#' tic_window(
#'   title = "demo",
#'   tic_checkbutton(text = "Click for Alert", variable = alert)
#' )
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_checkbutton.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_checkbutton <- function(text, variable, command, textvariable, width, style,
                            bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_checkbutton()'` = length(args$unnamed) == 0)
  
  # Allow 'switch' and 'toggle' as short version of the complete style name
  if (!is.null(args$named$style)) {
    args$named$style <- switch(
      args$named$style,
      switch = 'Switch.TCheckbutton',
      toggle = 'Toggle.TButton',
      args$named$style
    )
  }
  
  
  spec <- list(
    args     = args$named,
    type     = 'checkbutton',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a checkbutton
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_checkbutton <- function(parent, spec) {
  stopifnot(identical(spec$type, 'checkbutton'))
  spec$args <- handle_images(spec$args)
  # obj <- do.call(tcltk::ttkcheckbutton, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkcheckbutton,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Radiobutton: Mutually exclusive option widget
#' 
#' Radiobutton widgets are used in groups to show or change a set of 
#' mutually-exclusive options. 
#'
#' Radiobuttons are linked to a reactive variable, and have an associated value; 
#' when a radiobutton is clicked, it sets the variable to its associated value. 
#' 
#' @inheritParams tic_button
#' @param value The value to store in the associated \code{variable} when the widget is selected.
#' @param variable The reactive variable holding the state for a set of 
#'        radiobuttons. 
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples 
#' choices <- c('alpha', 'bravo', 'charlie')
#' state <- reactive_chr(choices[1])
#' tic_window(
#'   title = "demo",
#'   tic_radiobutton(text = choices[1], value = choices[1], variable = state),
#'   tic_radiobutton(text = choices[2], value = choices[2], variable = state),
#'   tic_radiobutton(text = choices[3], value = choices[3], variable = state)
#' )
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_radiobutton.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_radiobutton <- function(text, value, variable, command, textvariable, width, 
                            bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_radiobutton()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'radiobutton',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a radiobutton
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_radiobutton <- function(parent, spec) {
  stopifnot(identical(spec$type, 'radiobutton'))
  spec$args <- handle_images(spec$args)
  # obj <- do.call(tcltk::ttkradiobutton, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkradiobutton,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Textentry: Editable text field widget
#' 
#' A textentry widget displays a one-line text string and allows that string
#' to be edited by the user. 
#' 
#' The value of the string is linked to a reacive variaable with the \code{textvariable}
#' argument. 
#' 
#' Note: in tcl/tk this object is known as \code{entry} widget, rather than 
#' \code{textentry}.
#' 
#' @inheritParams tic_button
#' @param textvariable Reactive value for the value displayed in this widget
#' @param validate when to vdlidate the contents of this text box. Possible 
#'        values: none, key, focus, focusin, focusout, all.  If this is not
#'        set then the \code{validatecommand} function will never be run.
#' @param validatecommand function to call when validation event occurs. This
#'        function must return a non-NA boolean value.
#' 
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_entry.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_textentry <- function(textvariable, validate, validatecommand, width, 
                          bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_textentry()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'textentry',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a textentry box
# Note that 'entry' widget expects a tclobject with TRUE/FALSE, not an 
# R logical vector. So take this out of the hands of the user, and just
# auto convert from R logical to tclObject by wrapping the user function.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_textentry <- function(parent, spec) {
  stopifnot(identical(spec$type, 'textentry'))
  
  # Augment the users supplied 'validatecommand' (if any), such 
  # that it returns a tclObj with 0/1
  if (!is.null(spec$args$validatecommand)) {
    wrap <- function(user_func) {
      force(user_func)
      function() {
        res <- user_func()
        as.tclObj(is.null(res) || isTRUE(res))
      }
    }
    spec$args$validatecommand <- wrap(spec$args$validatecommand)
  }
  
  # obj <- do.call(tcltk::ttkentry, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkentry,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Spinbox: Selecting text field widget
#' 
#' A spinbox widget is a text-entry widget with built-in up and down buttons 
#' that are used to either
#' \itemize{
#'    \item{modify a numeric value by setting \code{from, to, increment} arguments}
#'    \item{select among a set of values by using the \code{values} argument}
#' }
#' 
#' The widget implements all the features of the \code{tic_entry()} widget.
#' 
#' @inheritParams tic_button
#' @param textvariable Reactive value for the value displayed in this widget
#' @param values  Specifies the list of values to display in the spinbox. 
#' @param from,to,increment numeric values for the low value, high value and
#'        change in value when the up and down buttons are pressed.  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples
#' opts <- c('alpha', 'bravo', 'charlie')
#' selected <- reactive_chr(opts[1])
#' tic_window(
#'   title = "Demo",
#'   tic_spinbox(values = opts, textvariable = selected)
#' )
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_spinbox.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_spinbox <- function(values, textvariable, command, from, to, increment, 
                        width, bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_spinbox()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'spinbox',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_spinbox <- function(parent, spec) {
  stopifnot(identical(spec$type, 'spinbox'))
  # obj <- do.call(tcltk::ttkspinbox, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkspinbox,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Combobox: text field with popdown selection list
#' 
#' A combobox combines a text field with a pop-down list of values; 
#' the user may select the value of the text field from among the values in the list. 
#' 
#' @inheritParams tic_button
#' @param textvariable Reactive value for the current selected value in this widget
#' @param values  Specifies the list of values to display in the drop-down listbox. 
#' @param justify one of \code{left, center, right}
#' @param state one of \code{normal, readonly, disabled}. Default: normal
#' 
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples
#' opts <- c('alpha', 'bravo', 'charlie')
#' selected <- reactive_chr(opts[1])
#' tic_window(
#'   title = "Demo",
#'   tic_combobox(values = opts, textvariable = selected)
#' )
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_combobox.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_combobox <- function(values, textvariable, justify, state, width, 
                         bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_combobox()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'combobox',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_combobox <- function(parent, spec) {
  stopifnot(identical(spec$type, 'combobox'))
  # obj <- do.call(tcltk::ttkcombobox, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkcombobox,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Progressbar: Provide progress feedback
#' 
#' A progressbar widget shows the status of a long-running operation. 
#' 
#' They can operate in two modes: determinate mode shows the amount completed 
#' relative to the total amount of work to be done, and indeterminate mode 
#' provides an animated display to let the user know that something is happening. 
#' 
#' @inheritParams tic_button
#' @param mode 'determinate' or 'indeterminate'.
#' @param variable reactive variable holding the progress value
#' @param maximum maximum value when in 'determinate' mode
#' 
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_progressbar.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_progressbar <- function(variable, mode, maximum, 
                            bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_progressbar()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'progressbar',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_progressbar <- function(parent, spec) {
  stopifnot(identical(spec$type, 'progressbar'))
  # obj <- do.call(tcltk::ttkprogressbar, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkprogressbar,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Slider: Create and manipulate a slider widget
#' 
#' A slider widget is used to control the numeric value of a 
#' reactive variable that varies uniformly over some range. 
#' 
#' The widget displays a slider that can be moved along over a trough, 
#' with the relative position of the slider over the trough indicating the 
#' value of the variable. 
#' 
#' Note: In tcl/tk this widget is known as a \code{ttk::scale} widget.
#' 
#' @inheritParams tic_button
#' @param variable reactive variable holding the slider value.
#' @param from,to numerical limits of the slider
#' @param command function to be invoked when slider value changes
#' 
#' @return handle on the tcl/tk object. TODO: better language needed here.
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_scale.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_slider <- function(variable, command, from = 0, to = 100, 
                       bind = NULL, pack = list(fill='x'), ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_slider()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'slider',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_slider <- function(parent, spec) {
  stopifnot(identical(spec$type, 'slider'))
  # obj <- do.call(tcltk::ttkscale, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkscale,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Separator: Separator bar
#' 
#' A separator widget displays a horizontal or vertical separator bar. 
#' 
#' @inheritParams tic_button
#' @param orient 'horizontal' or 'vertical'. 
#' 
#' @return handle on the tcl/tk object. TODO: better language needed here.
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_separator.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_separator <- function(orient, bind = NULL, pack = list(fill='x'), ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_separator()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'separator',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_separator <- function(parent, spec) {
  stopifnot(identical(spec$type, 'separator'))
  # obj <- do.call(tcltk::ttkseparator, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttkseparator,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Sizegrip: Bottom-right corner resize widget
#' 
#' A sizegrip widget (also known as a grow box) allows the user to resize the 
#' containing toplevel window by pressing and dragging the grip. 
#' 
#' On Mac OSX, toplevel windows automatically include a built-in size grip by 
#' default. Adding a ttk::sizegrip there is harmless, since the built-in grip 
#' will just mask the widget. 
#' 
#' @inheritParams tic_button
#' 
#' @return handle on the tcl/tk object. TODO: better language needed here.
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_sizegrip.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_sizegrip <- function(bind = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_sizegrip()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args     = args$named,
    type     = 'sizegrip',
    children = args$unnamed,
    binding  = bind,
    pack     = NULL
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_sizegrip <- function(parent, spec) {
  stopifnot(identical(spec$type, 'sizegrip'))
  # obj <- do.call(tcltk::ttksizegrip, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::ttksizegrip,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  render_binding(obj, spec)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' textbox: multi-line text input
#' 
#' Note: The interface to this widget differs from the core tcl/tk widget in 
#' that 
#' 
#' @inheritParams tic_button
#' @param variable reactive variable which reads the contents of the textbox.
#'        This must be a \code{reactive_textbox()} variable.
#' 
#' @return handle on the tcl/tk object. TODO: better language needed here.
#' @export
#' 
#' @family widgets
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/text.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_textbox <- function(variable, bind = NULL, pack = NULL, ...) {
  
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_textbox()'` = length(args$unnamed) == 0)
  
  args$named$variable <- NULL
  
  stopifnot(inherits(variable, 'reactive_textbox'))
  
  spec <- list(
    args     = args$named,
    type     = 'textbox',
    children = args$unnamed,
    binding  = bind,
    variable = variable,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_textbox <- function(parent, spec) {
  stopifnot(identical(spec$type, 'textbox'))
  # obj <- do.call(tcltk::tktext, c(list(parent), spec$args))
  
  obj <- call_tcltk(
    func = tcltk::tktext,
    args = c(list(parent), spec$args),
    spec = spec
  )
  
  # Stash the ID of this textbox into a reactive variable
  # Later, when accessing this reactive variable, the latest text in the
  # textbox will be fetched.
  tcl_obj <- attr(spec$variable, '.impl')
  tclvalue(tcl_obj) <- obj$ID 
  
  render_binding(obj, spec)
}







#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create drawing surface widget
#' 
#' This command will create a canvas widget as part of UI creation, but 
#' all the interesting things the user would want to do with a canvas are interactive things
#' \emph{after} the UI is available to the user.
#' 
#' So to make actual use of canvas at the moment, you'll have to 
#' be prepared to write some code with the `{tcltk}` package and 
#' read lots of documentation!
#' 
#' @inheritParams tic_button
#' @param background Background colour. Default: '#fafafa'
#' @param scrollbars include scrollbars on the canvas?  Default: FALSE.
#'        This option has not really been tested.  Scrollbars still look funky.
#' 
#' @return handle on the tcl/tk object. TODO: better language needed here.
#' @export
#' 
#' @family widgets
#' @family canvas
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/canvas.html}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_canvas <- function(background = '#fafafa', scrollbars = FALSE, 
                       bind = NULL, pack = NULL, ...) {
  
  args <- find_args(..., ignore = 'scrollbars')
  stopifnot(`No child elements allowed for 'tic_canvas()'` = length(args$unnamed) == 0)
  
  spec <- list(
    args       = args$named,
    type       = 'canvas',
    children   = args$unnamed,
    binding    = bind,
    pack       = pack,
    scrollbars = scrollbars
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a spinbox
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_canvas <- function(parent, spec) {
  stopifnot(identical(spec$type, 'canvas'))
  
  frame <- tcltk::tkframe(parent)
  
  
  obj <- call_tcltk(
    func = tcltk::tkcanvas,
    args = c(list(frame), spec$args),
    spec = spec
  )
  
  if (isTRUE(spec$scrollbars)) {
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Make scrollbars
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    xscr <- tcltk::ttkscrollbar(frame, orient = 'horizontal', command = function(...) {
      tcltk::tkxview(obj, ...)
    })
    yscr <- tcltk::ttkscrollbar(frame, orient = 'vertical', command = function(...) {
      tcltk::tkyview(obj, ...)
    })
    
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Attach to parent
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tcltk::tkconfigure(obj, 
                       xscrollcommand = function(...) tcltk::tkset(xscr, ...), 
                       yscrollcommand = function(...) tcltk::tkset(yscr, ...))
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Setup a grid layout in the frame
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tcltk::tkgrid(obj, row = 0, column = 0, sticky = 'news')
    tcltk::tkgrid(yscr, row = 0, column = 1, sticky = 'ns')
    tcltk::tkgrid(xscr, row = 1, column = 0, sticky = 'ew')
    tcltk::tkgrid.columnconfigure(frame, 0, weight = 1)
    tcltk::tkgrid.rowconfigure(frame, 0, weight = 1)
  } else {
    # Just back it into the frame to take up all the space
    tcltk::tkpack(obj, expand = TRUE, fill = 'both')
  }
  
  
  render_binding(obj, spec)
  
  frame$type   <- 'canvas_frame'
  frame$canvas <- obj
  as_tic_ui(frame)
}






