% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tk-menu.R
\name{tic_menu}
\alias{tic_menu}
\title{Create a toplevel menu bar.}
\usage{
tic_menu(..., text, tearoff = FALSE, bind = NULL, pack = NULL)
}
\arguments{
\item{...}{Other arguments are parsed as follows:
 \describe{
   \item{\code{named arguments}}{Further options to be used during the creation 
         of this widget.  See the tcl/tk documentation for all arguments possible
         for this widget.}
   \item{\code{unnamed arguments}}{Container widgets (e.g. \code{tic_frame()}) treat any 
         unnamed arguments as child objects.   Non-container widgets 
         (e.g \code{tic_button()}) will
         raise an error if there are any unnamed widgets.}
}}

\item{text}{Specifies a text string to be displayed inside the widget.
\describe{
  \item{\code{text}}{Simple character string containing the name}
  \item{\code{textvariable}}{Reactive variable containing a string}
}}

\item{tearoff}{Can the menu be torn off?  Default: FALSE}

\item{bind}{bind commands to particular events on this element. This may be 
a single result of \code{bind_opts()} or a list of them for multiple
events.}

\item{pack}{a named list of pack options for how to incorporate this element into its 
parent container.  Default: NULL means to use the standard packing.
See \code{pack_opts()} as a way of creating a valid list of pack options.}
}
\value{
handle on the tcl/tk object
}
\description{
This element must an immediate child of the main \code{tic_window()}
}
\section{tcl/tk}{


See tcl/tk documentation for more information on this element 
\url{https://www.tcl.tk/man/tcl8.6/TkCmd/menu.htm}
}

\examples{
\dontrun{
tic_window(
  tic_menu(
    text = "Press for menu",
    tic_menuitem("Run a command", menutype = "command", command = function() {
      message("This is where a command is run")
    }),
    tic_submenu(
      label = "Sub menu here",
      tic_menuitem("Run this", "command", command = function() { message("Hello")})
    )
  )
)
}


}
\seealso{
Other widgets: 
\code{\link{tic_button}()},
\code{\link{tic_canvas}()},
\code{\link{tic_checkbutton}()},
\code{\link{tic_combobox}()},
\code{\link{tic_label}()},
\code{\link{tic_menubutton}()},
\code{\link{tic_menuitem}()},
\code{\link{tic_progressbar}()},
\code{\link{tic_radiobutton}()},
\code{\link{tic_separator}()},
\code{\link{tic_sizegrip}()},
\code{\link{tic_slider}()},
\code{\link{tic_spinbox}()},
\code{\link{tic_submenu}()},
\code{\link{tic_textbox}()},
\code{\link{tic_textentry}()}
}
\concept{widgets}
