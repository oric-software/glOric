#include "config.h"

#include "camera.s"

#include "math/atan2.s"
#include "math/norm.s"
#include "projectPoint.s"

#include "projection.s"

#include "scene.s"

#include "raster/angle2screen.s"
    // _angle2screen
#include "raster/prepareBresrun.s"
    // _prepare_bresrun
#include "raster/isA1Right.s"
    // _isA1Right1
    // _isA1Right3
#include "raster/reachScreen.s"
    // _reachScreen
#include "raster/hzfill.s"
#include "raster/fill8_bis.s"
    // _A1stepY
    // _A2stepY
    // _hfill
    // _fill8
    // _bresStepType1
    // _bresStepType2
    // _bresStepType3
#include "raster/fillFace.s"
    // _fillFace
#include "temp.s"
#include "render/zbuff.s"
#include "raster/raster8.s"
#include "render/face.s"
    // glDrawFaces
    // sortPoints
    // guessIfFace2BeDrawn
    // retrieveFaceData

