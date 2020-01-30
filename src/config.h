
#ifndef CONFIG_H
#define CONFIG_H

// Choose amongst TEXTMODE, LRSMODE, HRSMODE
#define HRSMODE

/*
 *  SCREEN DIMENSION
 */

#ifdef TEXTMODE
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif

#ifdef LRSMODE
#define ANGLEONLY
#define USE_ZBUFFER
#define USE_COLLISION_DETECTION
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif

#ifdef HRSMODE
#define USE_HIRES_RASTER
#define SCREEN_WIDTH      240
#define SCREEN_HEIGHT      200
#endif

/*
 *  BUFFERS DIMENSION
 */

#define NB_MAX_POINTS 64
#define NB_MAX_SEGMENTS 64
#define NB_MAX_FACES 64

/*
 *  SCREEN BUFFER
 */
#define ADR_BASE_SCREEN 48041//BB80

/*
 *  ELEMENTS SIZE
 */

#define SIZEOF_3DPOINT 4
#define SIZEOF_SEGMENT 4
#define SIZEOF_2DPOINT 4
#define SIZEOF_FACES 4


#endif
