
library(grid)
library(colorspace)

if (FALSE) {
  demo <- png::readPNG("./inst/sun-valley/theme/light/button-accent-rest.png")
  grid.raster(as.raster(demo), interpolate = FALSE)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4x4 matrix of the approximate coverate of each pixel by a circle of radius = 4
# manually calculated with pencil and paper
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rounded_corner <- matrix(c(
  15.5, 11,  3.5,  0  ,
  16  , 16, 15.5,  3.5,
  16  , 16, 16  , 11  ,
  16  , 16, 16  , 15.5
), 4, 4, byrow = TRUE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 20x20 lightness matrix
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lmat <- matrix(0, 20, 20)
ne <- 1 - rounded_corner/16
lmat[1:4, 17:20] <- ne
lmat[1:4, 4:1] <- ne
lmat[20:17, 17:20] <- ne
lmat[20:17, 4:1] <- ne

create_button_image <- function(col) {
  
  # Create button matrix of solid colour
  butt <- matrix(col, 20, 20)
  
  # Lighten the corners
  butt <- lighten(butt, lmat)
  dim(butt) <- c(20, 20)
  
  # Lighten the top, left and right edges
  butt[1,  ] <- lighten(butt[1,  ], 0.05)
  butt[ , 1] <- lighten(butt[ , 1], 0.05)
  butt[ ,20] <- lighten(butt[ ,20], 0.05)
  
  # Darken the bottom edge and some bottom corner pixels
  butt[20,  4:17] <- darken(butt[20,  4:17], 0.2 , method = 'relative')
  butt[19,   2:3] <- darken(butt[19,   2:3], 0.15, method = 'relative')
  butt[19, 18:19] <- darken(butt[19, 18:19], 0.15, method = 'relative')
  
  butt
}

butt <- create_button_image('#0655AD') # Accent theme from sun-valley-light

butt <- create_button_image('#FFB908')

grid.raster(as.raster(butt), interpolate = FALSE)







cols   <- c('#0070FF', '#616A72', '#249D3C', '#D72F3C', '#FFB908', '#1798AF', '#F7F8F9', '#2E3338')
types  <- tolower(c("Primary", "Secondary", "Success", "Danger", "Warning", "Info", "Light", "Dark"))
states <- c('disabled', 'hover', 'pressed', 'rest')


for (i in seq_along(cols)) {
  type <- types[i]
  for (state in states) {
    col <- cols[i]
    fname <- glue::glue("./inst/sun-valley/theme/light/button-{type}-{state}.png")
    print(fname)
    
    if (state == 'hover') {
      col <- colorspace::lighten(col, 0.1)
    } else if (state == 'pressed') {
      col <- colorspace::lighten(col, 0.2)
    }
    
    # mat <- matrix(col, 20, 20)
    mat <- create_button_image(col)
    mat <- col2rgb(mat)/255
    r <- mat[1,]
    g <- mat[2,]
    b <- mat[3,]
    
    mat <- array(c(r, g, b), dim = c(20, 20, 3))
    png::writePNG(mat, fname)
  }
}


template <- '
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # success.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout success.TButton {
            successButton.button -children {
                successButton.padding -children {
                    successButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure success.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map success.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create successButton.button image \\
            [list $images(button-success-rest) \\
                {selected disabled} $images(button-success-disabled) \\
                disabled $images(button-success-disabled) \\
                selected $images(button-success-rest) \\
                pressed $images(button-success-pressed) \\
                active $images(button-success-hover) \\
            ] -border 4 -sticky nsew
'


res <- lapply(types, function(type) {
  gsub("success", type, template)
})

cat(unlist(res), sep = "\n")
clipr::write_clip(paste(res, collapse = "\n\n\n"))



