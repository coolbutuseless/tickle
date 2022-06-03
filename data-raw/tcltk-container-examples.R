
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
  
  
  ui_spec <- tic_window(
    title = "test two",
    tic_notebook(
      labels = c('one', 'two', 'three'),
      tic_label(text = "#Rstats", relief = 'groove'),
      tic_button(text = "Click", command = function() message("Button was clicked!", width = 20)),
      tic_checkbutton(text = "Click me", variable = bvar, command = bfunc)
    )
  )
  
  ui <- render_ui(ui_spec)
  
}