



# Create an indentation appropriate to a given depth
# with 2 spaces per depth level
ind <- function(depth) {
  paste(rep("  ", depth), collapse = "")
}


as_tic_ui <- function(x) {
  stopifnot(inherits(x, 'tkwin'))
  
  class(x) <- union('tic_ui', class(x))
  x
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Extract a nide from a \code{tic_ui} tree
#'
#' @param ui a \code{tic_ui} object representing a UI
#' @param id the id of the path. An ID string of the \code{tkwin} object.
#'        e.g. ".1.2.2.3.1".  See the output of printing a \code{tic_ui}
#'        object to see the list of all ID in this UI.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extract_node_by_id <- function(ui, id) {
  
  if (ui$ID == id) {
    return(ui)
  }
  
  child_names <- setdiff(names(ui), c('ID', 'env', 'type'))
  for (nm in child_names) {
    child <- ui[[nm]]
    res <- extract_node_by_id(child, id)
    if (!is.null(res)) {
      return(res)
    }
  }
  return(NULL)
}
                         
 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a character representation of a \code{tic_ui} object
#' 
#' @param x tic_ui object
#' @param depth recusive depth
#' @param ... ignored
#" 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.character.tic_ui <- function(x,  depth=0L,  ...) {
  
  head <- paste0(ind(depth), x$type, " ", x$ID, "")
  
  child_names <- setdiff(names(x), c('ID', 'env', 'type'))
  
  children <- lapply(child_names, function(nm) {
    as.character.tic_ui(x[[nm]], depth = depth + 1L)
  })
  
  if (length(children) == 0) {
    children <- NULL
  } else {
    children <- unlist(children)
  }
  
  res <- paste(c(
    head, 
    children
  ), collapse = "\n")
  
  res
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Print a \code{tic_ui} object
#' 
#' @param x \code{tic_ui} object
#' @param ... ignored
#" 
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.tic_ui <- function(x, ...) {
  cat("[tic_ui]\n")
  cat(as.character.tic_ui(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Autocomplete helper for \code{tic_ui} objects
#'
#' This autocomplete helper removes 'type' and 'env' from the suggestions,
#' and moves the suggestion of 'ID' to last in the list.
#' 
#' This is because the user is most often going to be using this object
#' to havigate the element tree, and will rarely need to access anything
#' other than the named child nodes.
#'
#' @param x object
#' @param pattern current pattern to match
#'
#' @importFrom utils .DollarNames
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.DollarNames.tic_ui <- function(x, pattern) {
  res <- setdiff(names(x), c('ID', 'env', 'type'))
  res <- c(res, 'ID')
  grep(pattern, res, value = TRUE)
}




if (FALSE) {
  
  
  library(tcltk)
  
  
  
  ui_spec <- tic_window(
    title = "Sun Light Demo Simple",
    tic_col(
      pack_def = pack_opts(pady = 4),
      tic_button("Tab 2 contents", style = 'primary'),
      tic_button("Tab 3 contents", style = 'Accent.TButton'),
      tic_label("Hello Label", style = "h1.TLabel")
    )
  )
  
  win <- render_ui(ui_spec)
  
  
  
  
}