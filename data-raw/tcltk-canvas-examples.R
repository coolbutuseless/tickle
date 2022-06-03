
if (FALSE) {
  
  library(tcltk)
  
  ui_spec <- tic_window(
    title = "Sun Light Demo Simple",
    tic_col(
      pack_def = pack_opts(pady = 4),
      tic_button("Tab 2 contents", style = 'primary'),
      tic_canvas(width = 800, height = 600, scrollbars = TRUE)
    )
  )
  
  
  win <- render_ui(ui_spec)
  canvas <- win$col$frame$canvas
  
  
  library(ggplot2) 
  p <- ggplot(mtcars) + 
    geom_point(aes(mpg, wt))
  
  canvas_plot(canvas, plot = p, width = 800, height = 600)
  
  draw_mode <- FALSE
  last_x <- NA
  last_y <- NA
  
  bind_event(canvas, "ButtonPress"  , \(x, y) { draw_mode <<- TRUE; last_x <<- x; last_y <<- y })
  bind_event(canvas, "ButtonRelease", \(...) { draw_mode <<- FALSE })
  bind_event(canvas, "Motion", \(x, y, ...) {
    if (draw_mode) {
      canvas_line(canvas, c(last_x, x), c(last_y, y))
      last_x <<- x
      last_y <<- y
    }
  })
  
  # ggreview
  # - choose linewidth
  # - choose color
  # - save plot to postscript
  # - use {magick} to convert to desired output format/DPI.
  
  
  
  
  
  im <- load_tkimage("working/sissy2.png")
  canvas_image(canvas, 50, 50, image = im)
  
  
  canvas_line(canvas, c(0, 100), c(0, 30), width = 5, dash = c(6, 4, 2, 4))
  canvas_text(canvas, x=50, y=50, text="hello")
  canvas_polygon(canvas, c(0, 100, 50), c(0, 30, 50), width = 5, dash = c(6, 4, 2, 4), fill = '#ff0000', outline = '#00ff00')
  
  canvas_rect(canvas, 0, 0, 100, 200, width = 5, dash = c(6, 4, 2, 4), fill = '#ff0000', outline = '#00ff00')
  
  
  canvas_oval(canvas, 0, 0, 100, 200, width = 5, dash = c(6, 4, 2, 4), fill = '#ff0000', outline = '#00ff00')
  
  canvas_arc(canvas, 0, 0, 100, 200, start = 0, extent = 180, width = 1,
             fill = '#0000ff', outline = 'black')
  
  
  
  lin <- tcl(canvas, 'create', 'line', 0, 0, 50, 50, 50, 100, 100, 50, 0, 0)
  
}