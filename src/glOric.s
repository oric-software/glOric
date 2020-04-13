
#include "config.h"

.zero

#ifdef SAVE_ZERO_PAGE
.text
#endif

#include "camera.s"

#include "projection.s"

#include "scene.s"


#ifndef SAVE_ZERO_PAGE
.text
#endif



#include "temp.s"


#include "glProject_s.s"

#include "lrDrawLine.s"