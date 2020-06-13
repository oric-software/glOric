/* =======================================
 * 	       glOric 3D            v1.2
 * =======================================
 *     3D graphic library for Oric 
 *			
 *			by Jean-Baptiste PERIN 
 *
 *  advised by the great Mickael POINTIER 
 *                        (a.k.a Dbug)
 *  for insane optimizations 
 * =======================================
 * 
 * Copyright 2020 Jean-Baptiste PERIN
 * Email: jbperin@gmail.com
 *
 * Website: https://github.com/oric-software/glOric
 * 
 * =======================================
 */

#ifndef GLORIC_H
#define GLORIC_H

#define GLORIC_V12

#define SCREEN_WIDTH            40
#define SCREEN_HEIGHT           26
#define ADR_BASE_SCREEN         48000 
#define HIRES_SCREEN_ADDRESS    0xA000

#define SIZEOF_3DPOINT          4
#define SIZEOF_SEGMENT          4
#define SIZEOF_PARTICLE         2
#define SIZEOF_2DPOINT          4
#define SIZEOF_FACE             4

#define NB_LESS_LINES_4_COLOR   4

 // Camera Position use only low bytes
extern int              glCamPosX;
extern int              glCamPosY;
extern int              glCamPosZ;

 // Camera Orientation
extern char             glCamRotZ;  // -128 -> 127 unit : 2PI/(2^8 - 1)
extern char             glCamRotX;

 // Geometry size
extern unsigned char    nbPoints;
extern unsigned char    nbFaces;
extern unsigned char    nbSegments;
extern unsigned char    nbParticles;

 // Geometry buffers
extern signed char      points3dX[];
extern signed char      points3dY[];
extern signed char      points3dZ[];

extern unsigned char    particlesPt[];
extern unsigned char    particlesChar[];

extern unsigned char    segmentsPt1[];
extern unsigned char    segmentsPt2[];
extern unsigned char    segmentsChar[];

extern unsigned char    facesPt1[];
extern unsigned char    facesPt2[];
extern unsigned char    facesPt3[];
extern unsigned char    facesChar[];

// Render buffer
extern char             fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT

extern void glProjectArrays();
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
extern void initScreenBuffers();
extern void buffer2screen(char *);
extern void zplot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void projectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
#endif