

all_valid_children_for_menu <- function(objs) {
  res <- vapply(objs, function(x) {
    x$type %in% c('menuitem', 'submenu')
  }, logical(1))
  
  res
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Button that pops down a menu when pressed
#' 
#' A menubutton widget displays a textual label and/or image, and displays a 
#' menu when pressed. 
#' 
#' Include items in this menu using \code{tic_menuitem()} and \code{tic_submenu()}
#' 
#' @inheritParams tic_button
#' @param pack how this object should be packed into its parent.  \code{pack} has
#'        no effect for \code{tic_menu()} or \code{tic_menu_item()}.
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples 
#' tic_menubutton(
#'   text = "Press for menu",
#'   tic_menuitem("Run a command", menutype = "command", command = function() {
#'     message("This is where a command is run")
#'   }),
#'   tic_submenu(
#'     label = "Sub menu here",
#'     tic_menuitem("Run this", "command", command = function() { message("Hello")})
#'   )
#' )
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_menubutton.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_menubutton <- function(..., text, 
                           bind = NULL, pack = NULL) {
  
  args <- find_args(...)
  
  check <- all_valid_children_for_menu(args$unnamed)
  if (any(!check)) {
    stop("All child objects to a 'tic_menubutton()' must be 'tic_menuitem()' or 'tic_submenu()'")
  }
  
  spec <- list(
    args     = args$named,
    type     = 'menubutton',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a menubutton
#
# mbutt <- ttkmenubutton(window, text = "MenuButton")
# actual <- tkmenu ( mbutt )
# tkpack(mbutt)
# tkconfigure(mbutt, menu = actual)
# tkadd(actual, "command", label = "Hello", command = function() { message("MenuButton hello")})
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_menubutton <- function(parent, spec) {
  stopifnot(identical(spec$type, 'menubutton'))
  spec$args <- handle_images(spec$args)
  container <- do.call(tcltk::ttkmenubutton, c(list(parent), spec$args))
  
  menu <- tcltk::tkmenu(container)
  tcltk::tkconfigure(container, menu = menu)
  
  for (item in spec$children) {
    stopifnot(item$type %in% c('menuitem', 'submenu'))
    if (identical(item$type, 'menuitem')) {
      call_tcltk(
        tcltk::tkadd, 
        c(list(menu), list(item$menutype), item$args),
        item
      )
    } else if (identical(item$type, 'submenu')) {
      render_tic_submenu(menu, item)
    }
  }
  
  container$type <- spec$type
  render_binding(container, spec)
  as_tic_ui(container)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a toplevel menu bar.  
#' 
#' This element must an immediate child of the main \code{tic_window()}
#' 
#' @inheritParams tic_button
#' @param tearoff Can the menu be torn off?  Default: FALSE
#'  
#' @return handle on the tcl/tk object
#' @export
#' 
#' @family widgets
#' 
#' @examples 
#' \dontrun{
#' tic_window(
#'   tic_menu(
#'     text = "Press for menu",
#'     tic_menuitem("Run a command", menutype = "command", command = function() {
#'       message("This is where a command is run")
#'     }),
#'     tic_submenu(
#'       label = "Sub menu here",
#'       tic_menuitem("Run this", "command", command = function() { message("Hello")})
#'     )
#'   )
#' )
#' }
#' 
#' 
#' @section tcl/tk:
#'
#' See tcl/tk documentation for more information on this element 
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/menu.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_menu <- function(..., text, tearoff = FALSE, 
                     bind = NULL, pack = NULL) {
  
  args <- find_args(...)
  
  check <- all_valid_children_for_menu(args$unnamed)
  if (any(!check)) {
    stop("All child objects to a 'tic_menu()' must be 'tic_menuitem()' or 'tic_submenu()'")
  }
  
  args$named$background <- args$named$background %||% 'white'
  
  spec <- list(
    args     = args$named,
    type     = 'menu',
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a menu
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_menu <- function(parent, spec) {
  stopifnot(identical(spec$type, 'menu'))
  spec$args <- handle_images(spec$args)
  menu_bar <- do.call(tcltk::tkmenu, c(list(parent), spec$args))
  
  tcltk::tkconfigure(parent, menu = menu_bar)
  
  for (item in spec$children) {
    stopifnot(item$type %in% c('menuitem', 'submenu'))
    if (identical(item$type, 'menuitem')) {
      call_tcltk(
        tcltk::tkadd, 
        c(list(menu_bar), list(item$menutype), item$args),
        item
      )
    } else if (identical(item$type, 'submenu')) {
      render_tic_submenu(menu_bar, item)
    }
  }
  
  menu_bar$type <- spec$type
  render_binding(menu_bar, spec)
  as_tic_ui(menu_bar)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a submenu under a menubutton or menu  
#' 
#' @inheritParams tic_button
#' @param label submenu label
#' @param tearoff FALSE
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
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/menu.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_submenu <- function(..., label, tearoff = FALSE, 
                        bind = NULL, pack = NULL) {
  
  args <- find_args(...)
  
  check <- all_valid_children_for_menu(args$unnamed)
  if (any(!check)) {
    stop("All child objects to a 'tic_submenu' must be 'tic_menuitem()' or 'tic_submenu()'")
  }
  
  args$named$label <- NULL
  args$named$background <- args$named$background %||% 'white'
  
  spec <- list(
    args     = args$named,
    type     = 'submenu',
    children = args$unnamed,
    binding  = bind,
    label    = label,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render a submenu.
# submenus can have submenus
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
render_tic_submenu <- function(parent, spec) {
  stopifnot(identical(spec$type, 'submenu'))
  spec$args <- handle_images(spec$args)
  submenu <- do.call(tcltk::tkmenu, c(list(parent), spec$args))
  
  # tcltk::tkconfigure(parent, menu = submenu)
  tkadd(parent, "cascade", label = spec$label, menu = submenu, background = 'white')
  
  for (item in spec$children) {
    stopifnot(item$type %in% c('menuitem', 'submenu'))
    if (identical(item$type, 'menuitem')) {
      call_tcltk(
        tcltk::tkadd, 
        c(list(submenu), list(item$menutype), item$args),
        item
      )
    } else if (identical(item$type, 'submenu')) {
      render_tic_submenu(submenu, item)
    }
  }
  
  submenu$type <- spec$type
  render_binding(submenu, spec)
  as_tic_ui(submenu)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a menu item  
#' 
#' This element must an immediate child of a \code{tic_menubuton}, 
#' \code{tic_menu} or \code{tic_submenu}
#' 
#' @inheritParams tic_button
#' @param label text to display
#' @param menutype one of the following:
#'   \describe{
#'     \item{\code{command}}{When menu item is selected, run the function given
#'           by the \code{command} argument}
#'     \item{\code{cascade}}{Do not use.  Use \code{tic_submenu()}} to create
#'           a submenu.
#'     \item{\code{separator}}{Horizontal separato between menu items}
#'     \item{\code{checkbutton}}{A menuitem which functions as a checkbutton.
#'           Use this in conjunction with \code{variable} to specify the 
#'           \code{reactive_lgl} variable to store the state of the button 
#'           (i.e. TRUE/FALSE)}.  Use in conjunctionwith \code{command} argument
#'           to run a function each time the button is selected.
#'     \item{\code{radiobutton}}{Same as the \code{checkbutton} menu item, but
#'           fo defining a mutually exclusive set of selection options. 
#'           See \code{tic_radiobutton()} for more information and examples}
#'   } 
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
#' \url{https://www.tcl.tk/man/tcl8.6/TkCmd/menu.htm}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tic_menuitem <- function(label, menutype, command, image, 
                         bind = NULL, pack = NULL, ...) {
  args <- find_args(...)
  stopifnot(`No child elements allowed for 'tic_menuitem()'` = length(args$unnamed) == 0)
  
  args$named$menutype <- NULL
  args$named$background <- args$named$background %||% 'white'
  
  spec <- list(
    args     = args$named,
    type     = 'menuitem',
    menutype = menutype, 
    children = args$unnamed,
    binding  = bind,
    pack     = pack
  )
  class(spec) <- 'tic_spec'
  spec
}


