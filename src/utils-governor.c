


#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// An 'fps_struct' holding global information  about the timing
//
// We need this idea of a 'struct' that the user initialises so that we
// can properly initialise the FPS counter over multiple runs.
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
typedef struct fps_struct {
  struct timeval *last_time;
  double ms;
} fps_struct;



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// How to finalize an external pointer holding an 'fps_struct'
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void fps_struct_finalizer(SEXP fs_) {
  // Rprintf("fps_struct finalizer called\n");
  fps_struct *fs = R_ExternalPtrAddr(fs_);
  free(fs->last_time);
  free(fs);
  R_ClearExternalPtr(fs_);
}



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Let an R user create an fps struct
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SEXP init_fps_governor_(SEXP fps_target_) {
  double fps_target = asReal(fps_target_);
  struct fps_struct *fs = calloc(1, sizeof(fps_struct));
  if (fs == NULL) {
    error("Could allocate memory for fps_struct");
  }
  fs->last_time = malloc(sizeof(struct timeval));
  gettimeofday(fs->last_time, NULL);
  
  fs->ms = 1/fps_target* 1000;

  SEXP fs_ = PROTECT(R_MakeExternalPtr(fs, R_NilValue, R_NilValue));
  R_RegisterCFinalizer(fs_, fps_struct_finalizer);
  SET_CLASS(fs_, mkString("fps_struct"));

  UNPROTECT(1);
  return fs_;
}



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// This is a "good enough" FPS governor in C
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SEXP fps_governor_ms_(SEXP fps_target_, SEXP fs_) {
  
  // const double alpha = 0.7;
  struct timeval this_time;
  double fps_target = asReal(fps_target_);
  double expected_time_ms = 1.0/fps_target * 1000;
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Unpack this external pointer
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (!inherits(fs_, "fps_struct")) {
    error("Expecting 'fs' to be an 'fps_struct' ExternalPtr as created by 'init_fps_governor()'");
  }
  
  fps_struct *fs = TYPEOF(fs_) != EXTPTRSXP ? NULL : (fps_struct *)R_ExternalPtrAddr(fs_);
  if (fs == NULL) {
    error("'fs' structure storing FPS info is invalid");
  }
  
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Get the current time and calculate difference from last time
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  gettimeofday(&this_time, NULL);
  
  double frame_time_sec =
    (this_time.tv_sec  - fs->last_time->tv_sec ) +
    (this_time.tv_usec - fs->last_time->tv_usec) / 1000000.0;
  
  double frame_time_ms = frame_time_sec * 1000;
  
  double delta_ms = frame_time_ms - expected_time_ms;
  
  fs->ms = fs->ms - delta_ms;
  
  if (fs->ms < 0) {
    fs->ms = 0;
  }

  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Reset the 'last_time'
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  gettimeofday(fs->last_time, NULL);
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Return time to wait to hit the required framerate
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  return ScalarReal(fs->ms);
}




