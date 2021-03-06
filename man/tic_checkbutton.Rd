% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tk-widgets.R
\name{tic_checkbutton}
\alias{tic_checkbutton}
\title{A button which toggles between two states}
\usage{
tic_checkbutton(
  text,
  variable,
  command,
  textvariable,
  width,
  style,
  bind = NULL,
  pack = NULL,
  ...
)
}
\arguments{
\item{text}{Specifies a text string to be displayed inside the widget.
\describe{
  \item{\code{text}}{Simple character string containing the name}
  \item{\code{textvariable}}{Reactive variable containing a string}
}}

\item{variable}{The variable containing the state of the button. Create this 
variable with \code{reactive_lgl}.}

\item{command}{Function to evaluate when the widget is invoked.}

\item{textvariable}{Specifies a text string to be displayed inside the widget.
\describe{
  \item{\code{text}}{Simple character string containing the name}
  \item{\code{textvariable}}{Reactive variable containing a string}
}}

\item{width}{If greater than zero, specifies how much space, in character 
widths, to allocate for the text label. If less than zero, specifies 
a minimum width. If zero or unspecified, the natural width of the 
text label is used.}

\item{style}{Default behaviour is to use a checkbox stye button.  With the
       build in theme in this package, two other styles are possible:
\describe{
  \item{\code{''toggle}}{The button will look like a regular button but will 
        alternate between 'on' and 'off' states with each press}
  \item{\code{'switch'}}{The button will look like a sliding switch which
        slides from one side to the other with each press}
}}

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
handle on the tcl/tk object
}
\description{
A checkbutton is used to show or change a setting. It has two states, 
\code{selected} and \code{deselected}.
}
\details{
The state of the checkbutton should be linked to a \code{reactive_lgl} logical variable using
\code{variable} argument.
}
\section{tcl/tk}{


See tcl/tk documentation for more information on this element 
\url{https://www.tcl.tk/man/tcl8.6/TkCmd/ttk_checkbutton.htm}
}

\examples{
alert = reactive_lgl(FALSE)
tic_window(
  title = "demo",
  tic_checkbutton(text = "Click for Alert", variable = alert)
)


}
\seealso{
Other widgets: 
\code{\link{tic_button}()},
\code{\link{tic_canvas}()},
\code{\link{tic_combobox}()},
\code{\link{tic_label}()},
\code{\link{tic_menubutton}()},
\code{\link{tic_menuitem}()},
\code{\link{tic_menu}()},
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
