
#ifndef CONFIG_H
#define CONFIG_H

// Choose amongst TEXTDEMO, LRSDEMO, HRSDEMO, COLORDEMO, RTDEMO
#define RTDEMO

/*
 *  SCREEN DIMENSION
 */

#ifdef TEXTDEMO
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif

#ifdef LRSDEMO
#define ANGLEONLY
#define USE_ZBUFFER
#define USE_COLLISION_DETECTION
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif

#ifdef COLORDEMO
#define ANGLEONLY
#define USE_ZBUFFER
#define USE_COLOR
#define USE_COLLISION_DETECTION
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif


#ifdef HRSDEMO
#define USE_HIRES_RASTER
#define SCREEN_WIDTH 240
#define SCREEN_HEIGHT 200
#endif

#ifdef RTDEMO

// #define ALL_C

#define ANGLEONLY
#define USE_ZBUFFER
#define USE_COLLISION_DETECTION
#undef USE_COLOR
#define USE_REWORKED_BUFFERS
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#endif // RTDEMO

/*
 *  BUFFERS DIMENSION
 */

#define NB_MAX_POINTS 64
#define NB_MAX_SEGMENTS 64
#define NB_MAX_FACES 64
#define NB_MAX_PARTICULES 64
/*
 *  SCREEN MEMORY
 */
#define ADR_BASE_LORES_SCREEN 48040  //BB80

/*
 *  ELEMENTS SIZE
 */

#define SIZEOF_3DPOINT 4
#define SIZEOF_SEGMENT 4
#define SIZEOF_PARTICULE 2
#define SIZEOF_2DPOINT 4
#define SIZEOF_FACE 4

#define COLUMN_OF_COLOR_ATTRIBUTE 2
#define NB_LESS_LINES_4_COLOR 4


#define USE_C_DRAWLINE
#undef USE_ASM_DRAWLINE

#ifdef TARGET_ORIX
#undef USE_ASM_HFILL
#define USE_C_HFILL
#define USE_C_INITFRAMEBUFFER
#undef USE_ASM_INITFRAMEBUFFER
#define USE_C_ZPLOT
#undef  USE_ASM_ZPLOT
#define USE_C_ZLINE
#undef USE_ASM_ZLINE
#define USE_C_BRESFILL
#undef USE_ASM_BRESFILL
#define USE_C_ZBUFFER
#undef USE_ASM_ZBUFFER
#undef USE_ASM_BUFFER2SCREEN
#define USE_C_ARRAYSPROJECT
#undef  USE_ASM_ARRAYSPROJECT
#define USE_C_DRAWLINE
#undef USE_ASM_DRAWLINE
#else
#ifdef ALL_C
#define USE_C_HFILL
#undef USE_ASM_HFILL
#define USE_C_INITFRAMEBUFFER
#undef USE_ASM_INITFRAMEBUFFER
#define USE_C_ZPLOT
#undef  USE_ASM_ZPLOT
#define USE_C_ZLINE
#undef USE_ASM_ZLINE
#define USE_C_BRESFILL
#undef USE_ASM_BRESFILL
#define USE_C_ZBUFFER
#undef USE_ASM_ZBUFFER
#define USE_C_BUFFER2SCREEN
#undef USE_ASM_BUFFER2SCREEN
#define USE_C_ARRAYSPROJECT
#undef  USE_ASM_ARRAYSPROJECT
#define USE_C_DRAWLINE
#undef USE_ASM_DRAWLINE
#else 
#ifdef ALL_ASM
#undef USE_C_HFILL
#define USE_ASM_HFILL
#undef USE_C_INITFRAMEBUFFER
#define USE_ASM_INITFRAMEBUFFER
#undef USE_C_ZPLOT
#define  USE_ASM_ZPLOT
#undef USE_C_ZLINE
#define USE_ASM_ZLINE
#undef USE_C_BRESFILL
#define USE_ASM_BRESFILL
#undef USE_C_ZBUFFER
#define USE_ASM_ZBUFFER
#undef USE_C_BUFFER2SCREEN
#define USE_ASM_BUFFER2SCREEN
#undef USE_C_ARRAYSPROJECT
#define  USE_ASM_ARRAYSPROJECT
#undef USE_C_DRAWLINE
#define USE_ASM_DRAWLINE
#else

#undef USE_C_HFILL
#define USE_ASM_HFILL
#undef USE_C_INITFRAMEBUFFER
#define USE_ASM_INITFRAMEBUFFER
#undef USE_C_ZPLOT
#define  USE_ASM_ZPLOT
#undef USE_C_ZLINE
#define USE_ASM_ZLINE
#undef USE_C_BRESFILL
#define USE_ASM_BRESFILL
#undef USE_C_ZBUFFER
#define USE_ASM_ZBUFFER
#undef USE_C_BUFFER2SCREEN
#define USE_ASM_BUFFER2SCREEN
#undef USE_C_ARRAYSPROJECT
#define  USE_ASM_ARRAYSPROJECT
#undef USE_C_DRAWLINE
#define USE_ASM_DRAWLINE

#endif // ALL_ASM
#endif // ALL_C
#endif


#undef USE_16BITS_PROJECTION
#define USE_8BITS_PROJECTION


#define KEY_UP			1
#define KEY_LEFT		2
#define KEY_DOWN		3
#define KEY_RIGHT		4

#define KEY_LCTRL		5
#define KET_RCTRL		6
#define KEY_LSHIFT		7
#define KEY_RSHIFT		8
#define KEY_FUNCT		9


// This keys do have ASCII values, let s use them 

#define KEY_RETURN		$0d
#define KEY_ESC			$1b
#define KEY_DEL			$7f

#undef USE_MULTI40

#endif
