if (FALSE) {
  
  
  library(tcltk)
  
  image_filename <- "working/jksimmons.png"
  win <- tcltk::tktoplevel()
  img <- load_tkimage(image_filename)
  butt <- ttkbutton(win, text = "hello", image = img, compound = 'top')
  tkpack(butt)
  
  f <- \() {message("Hello 30")}
  tcl("after", 300, f)
  
  tcl(win, "tk::chooseColor")
  
  
  subw <- .Tk.subwin(win)
  tcl("tk_chooseColor", parent = win)
}