
#ifndef ZBUFFER_H
#define ZBUFFER_H

extern int multi40[];

#ifdef USE_ZBUFFER
// TEXT SCREEN TEMPORARY BUFFERS
// z-depth buffer
//unsigned char zbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
// frame buffer

extern void initScreenBuffers();

extern void buffer2screen(char destAdr[]); 


extern void zplot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void zline(signed char dx, signed char py, unsigned char nbpoints, unsigned char dist, char char2disp);

#endif // USE_ZBUFFER
#endif // ZBUFFER_H

