


if (FALSE) {
  
  bfunc <- function() {
    message("checked!", tclvalue(bvar))
  }
  
  bvar     <- tclVar(TRUE)
  
  spin_values <- c("Hello", "There", "#RStats")
  spin_var <- tclVar(spin_values[1])
  
  txt_var <- tclVar("Hi #RStats")
  
  
  combo_values <- c("Hello", "There", "#RStats")
  combo_var <- tclVar(combo_values[1])
  
  # progress_var <- tclVar(49)  # reactive_dbl(50)
  progress_var <- reactive_dbl(50)
  
  # var1 <- reactive_dbl(10)
  # var2 <- reactive_dbl(20)
  textbox_var <- reactive_textbox()
  
  ui_spec <- tic_window(
    title = "test two",
    tic_col(
      sizes = c(1, 2, 3, 4), relief = 'raised',
      tic_label(text = "#Rstats", relief = 'groove'),
      tic_button(text = "Click", image = "working/jksimmons.png", command = function() message("Button was clicked!", width = 20)),
      tic_checkbutton(text = "Click me", image = "working/sissy.png", variable = bvar, command = bfunc),
      tic_row(
        sizes = c(1, 2), relief = 'flat',
        tic_label(text = "greg"),
        tic_label(text = "mike"),
        tic_spinbox(values = spin_values, textvariable = spin_var, 
                    command = function() { message("Spin: ", tclvalue(spin_var) )}),
        tic_textentry(textvariable = txt_var, 
                      validatecommand = function() { message("Validate textentry: ", tclvalue(txt_var)); })
      ),
      tic_combobox(values = spin_values),
      tic_progressbar(variable = progress_var),
      tic_slider(variable = progress_var),
      tic_textbox(variable = textbox_var)
    )
  )
  
  win <- render_ui(ui_spec)
  
}



if (FALSE) {
  
  library(tcltk)
  
  
  
  win <- tic_window(title = "Hello")
  
  f1 <- ttklabelframe(win, text = "Frame 1", padding = c(3, 3, 12,12))
  f2 <- ttklabelframe(win, text = "Frame 2")
  
  tkpack(f1, expand = TRUE, fill = 'both', side = 'left')
  tkpack(f2, expand = TRUE, fill = 'both', side = 'right')
  
  
  slider_var <- tclVar(50);
  slider_callback <- function(...) {
    tclvalue(slider_var) <- round(as.numeric(tclvalue(slider_var)), 1)
  }
  
  
  lab1 <- ttkbutton(f1, textvariable = slider_var  )
  lab2 <- ttkbutton(f1, text = "Two"  )
  lab3 <- ttkscale(f1, from=0, to=100, variable = slider_var, command = slider_callback)
  
  tkpack(lab1, side = 'top', expand = FALSE, fill = 'x')
  tkpack(lab2, side = 'top', expand = FALSE, fill = 'x')
  tkpack(lab3, side = 'top', expand = FALSE, fill = 'x')
  
  combo_var <- tclVar('alpha')
  txt_var <- tclVar("Hello #RStats!")
  lab4 <- ttkcombobox(f2, values = c('alpha', 'beta', 'gamma'), textvariable = combo_var)
  lab5 <- ttkentry(f2, textvariable = txt_var)
  lab6 <- ttkbutton(f2, text = "Six", command = function() message("Six"), style='Accent.TButton')
  
  tcltk::tcl("ttk::style", "configure", "Accent.TButton", foreground = 'blue')
  
  tcltk::tcl("ttk::style", "configure", "Accent.TButton")
  
  tcltk::tcl("ttk::style", "map", "Accent.TButton",
             bg = c('active', '#ff0000', 'pressed', '#00ff00'))
  
  tkgrid(lab4, lab5, lab6)
  
}


if (FALSE) {
  
  library(tcltk)
  win <- tcltk::tktoplevel()
  text <- tcltk::tktext(win)
  tkpack(text)
  
  debug <- function() {message("debug")}
  tcltk::tkbind(text, "<<Modified>>", debug)
  
  current <- tkget(text, "1.0", "end")
  tclvalue(current)
  
  # convert -strip jksimmons.png jk2.png
  jk <- tkimage.create("photo", "::img::jksimmons", file = "working/jk2.png")
  sissy <- tkimage.create("photo", "::img::sissy", file = "working/sissy2.png")
  
  butt <- ttkbutton(win, text = "hello", image = sissy, compound = 'center')
  tkpack(butt)
  
  
}

if (FALSE) {
  
  image_filename <- "working/jksimmons.png"
  tmp_filename <- "working/temp.png"
  
  env$img_count <- env$img_count + 1L
  img_tag <- tools::file_path_sans_ext(basename(image_filename))
  img_tag <- gsub("\\s", "-", img_tag)
  img_tag <- sprintf("::img::%s%04i", img_tag, env$img_count)
  
  im <- magick::image_read(image_filename, strip = TRUE)
  magick::image_write(im, path = tmp_filename, flatten = TRUE)
  
  img <- tkimage.create("photo", img_tag, file = tmp_filename)
  butt <- ttkbutton(win, text = "hello", image = img, compound = 'top')
  tkpack(butt)
}






