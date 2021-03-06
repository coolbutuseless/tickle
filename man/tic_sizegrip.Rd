% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tk-widgets.R
\name{tic_sizegrip}
\alias{tic_sizegrip}
\title{Sizegrip: Bottom-right corner resize widget}
\usage{
tic_sizegrip(bind = NULL, ...)
}
\arguments{
\item{bind}{bind commands to particular events on this element. This may be 
a single result of \code{bind_opts()} or a list of them for multiple
events.}

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
}
\value{
handle on the tcl/tk object. TODO: better language needed here.
}
\description{
A sizegrip widget (also known as a grow box) allows the user to resize the 
containing toplevel window by pressing and dragging the grip.
}
\details{
On Mac OSX, toplevel windows automatically include a built-in size grip by 
default. Adding a ttk::sizegrip there is harmless, since the built-in grip 
will just mask the widget.
}
\section{tcl/tk}{


See tcl/tk documentation for more information on this element 
\url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_sizegrip.htm}
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
\code{\link{tic_menu}()},
\code{\link{tic_progressbar}()},
\code{\link{tic_radiobutton}()},
\code{\link{tic_separator}()},
\code{\link{tic_slider}()},
\code{\link{tic_spinbox}()},
\code{\link{tic_submenu}()},
\code{\link{tic_textbox}()},
\code{\link{tic_textentry}()}
}
\concept{widgets}
