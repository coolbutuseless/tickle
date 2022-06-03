

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Manual Menu creation and experimentation area
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if (FALSE) {
  window <- tktoplevel ( )
  tkwm.title( window , "File menu example" ) 
  
  menu_bar <- tkmenu ( window )
  
  tkconfigure ( window , menu = menu_bar )
  
  
  
  tkadd(menu_bar, "command", label = "Hello", command = function() { message("Menu hello")})
  tkadd(menu_bar, "command", label = "#Rstats", command = function() { message("Menu #RStats!")})
  
  file_menu <- tkmenu(menu_bar)
  tkadd(menu_bar, "cascade", label = "File", menu = file_menu)
  
  tkadd(file_menu, "command", label = "#Rstats", command = function() { message("File bar #RStats!")})
  
  # tkadd
  # 
  # cascade, checkbutton, command, radiobutton, separator
  
  mbutt <- ttkmenubutton(window, text = "MenuButton")
  actual <- tkmenu ( mbutt )
  tkpack(mbutt)
  tkconfigure(mbutt, menu = actual)
  tkadd(actual, "command", label = "Hello", command = function() { message("MenuButton hello")})
  
  
  
  img <- tkimage.create("photo", "::img::crap001", file = "working/jk2.png")
  tkadd(menu_bar, "command", image = img, command = function() { message("Menu #RStats!")})
  
  
  
  
  ui_spec <- tic_window(
    title = "test two",
    tic_button(text = "Click", image = "working/jksimmons.png", command = function() message("Button was clicked!", width = 20)),
    tic_menubutton(
      text = "MenuHello",
      tic_menuitem(label = "Greg", menutype = "command", command = function() {message("Hi Greg")}),
      tic_submenu(
        label = "MikeSub2", 
        tic_menuitem(label = "YYYYYY", menutype = "command", command = function() {message("Hi YYYYYY")})
      )
    ),
    tic_menu(
      tic_menuitem(label = "Henry", menutype = "command", command = function() {message("Hi Henry")}),
      tic_submenu(
        label = "MikeSub",
        tic_menuitem(label = "xxxxxx", menutype = "command", command = function() {message("Hi xxxxx")})
      )
    )
  )
  
  win <- render_ui(ui_spec)
  
}  

