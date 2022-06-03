

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Governor for frame rate
#'
#' Given a target FPS, this function will insert pauses to ensure it can
#'
#' @param fps target frames per second i.e. the desired frrame rate
#' @param fs an FPS Structure storing global information for the FPS governor.
#'        Create this object initially with \code{fs = init_fps_governor()}
#' @return The current actual framerate
#'
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fps_governor_ms <- function(fps, fs) {
  .Call(fps_governor_ms_, fps, fs)
}


init_fps_governor <- function(fps) {
  .Call(init_fps_governor_, fps)
}

if (FALSE) {

  system.time({
    fs <- init_fps_governor()

    # 300 frames at 60fps should take 5 seconds
    system.time({
      for (i in seq(300)) {
        fps_governor(60, fs)
      }
    })
  })
}
