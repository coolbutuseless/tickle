% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-tic-ui.R
\name{extract_node_by_id}
\alias{extract_node_by_id}
\title{Extract a nide from a \code{tic_ui} tree}
\usage{
extract_node_by_id(ui, id)
}
\arguments{
\item{ui}{a \code{tic_ui} object representing a UI}

\item{id}{the id of the path. An ID string of the \code{tkwin} object.
e.g. ".1.2.2.3.1".  See the output of printing a \code{tic_ui}
object to see the list of all ID in this UI.}
}
\description{
Extract a nide from a \code{tic_ui} tree
}
