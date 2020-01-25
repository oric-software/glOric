#ifndef CONFIG_H
#define CONFIG_H

#define TEXTMODE
#define ANGLEONLY
/*
 *  SCREEN DIMENSION
 */
#ifdef TEXTMODE
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#else
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


#endif
