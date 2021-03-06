% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tk-widgets.R
\name{tic_slider}
\alias{tic_slider}
\title{Slider: Create and manipulate a slider widget}
\usage{
tic_slider(
  variable,
  command,
  from = 0,
  to = 100,
  bind = NULL,
  pack = list(fill = "x"),
  ...
)
}
\arguments{
\item{variable}{reactive variable holding the slider value.}

\item{command}{function to be invoked when slider value changes}

\item{from, to}{numerical limits of the slider}

\item{bind}{bind commands to particular events on this element. This may be 
a single result of \code{bind_opts()} or a list of them for multiple
events.}

\item{pack}{a named list of pack options for how to incorporate this element into its 
parent container.  Default: NULL means to use the standard packing.
See \code{pack_opts()} as a way of creating a valid list of pack options.}

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
A slider widget is used to control the numeric value of a 
reactive variable that varies uniformly over some range.
}
\details{
The widget displays a slider that can be moved along over a trough, 
with the relative position of the slider over the trough indicating the 
value of the variable. 

Note: In tcl/tk this widget is known as a \code{ttk::scale} widget.
}
\section{tcl/tk}{


See tcl/tk documentation for more information on this element 
\url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_scale.htm}
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
\code{\link{tic_sizegrip}()},
\code{\link{tic_spinbox}()},
\code{\link{tic_submenu}()},
\code{\link{tic_textbox}()},
\code{\link{tic_textentry}()}
}
\concept{widgets}
