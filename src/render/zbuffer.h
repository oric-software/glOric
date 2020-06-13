
#ifndef ZBUFFER_H
#define ZBUFFER_H

#ifdef USE_MULTI40
extern int multi40[];
#endif

#ifdef USE_ZBUFFER


#ifdef TARGET_ORIX
char fbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
unsigned char zbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
#else
extern unsigned char zbuffer[];  // z-depth buffer SCREEN_WIDTH * SCREEN_HEIGHT
extern char          fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT
#endif

extern void glInitScreenBuffers();

extern void glBuffer2Screen(char destAdr[]); 
extern void glZPlot(signed char X, signed char Y, unsigned char dist, char char2disp);

#ifdef USE_ASM_ZLINE
extern void zline(signed char dx, signed char py, unsigned char nbpoints, unsigned char dist, char char2disp);
#endif 

#endif // USE_ZBUFFER
#endif // ZBUFFER_H

