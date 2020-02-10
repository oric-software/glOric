
#ifndef ZBUFFER_H
#define ZBUFFER_H

#ifdef USE_MULTI40
extern int multi40[];
#endif

#ifdef USE_ZBUFFER

extern void initScreenBuffers();

extern void buffer2screen(char destAdr[]); 


extern void zplot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void zline(signed char dx, signed char py, unsigned char nbpoints, unsigned char dist, char char2disp);

#endif // USE_ZBUFFER
#endif // ZBUFFER_H

