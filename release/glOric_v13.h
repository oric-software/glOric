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
extern signed char              glCamPosX;
extern signed char              glCamPosY;
extern signed char              glCamPosZ;

 // Camera Orientation
extern char             glCamRotZ;  // -128 -> 127 unit : 2PI/(2^8 - 1)
extern char             glCamRotX;

 // Geometry size
extern unsigned char    glNbVertices;
extern unsigned char    glNbFaces;
extern unsigned char    glNbSegments;
extern unsigned char    glNbParticles;

 // Geometry buffers
extern signed char      glVerticesX[];
extern signed char      glVerticesY[];
extern signed char      glVerticesZ[];

extern unsigned char    glParticlesPt[];
extern unsigned char    glParticlesChar[];

extern unsigned char    glSegmentsPt1[];
extern unsigned char    glSegmentsPt2[];
extern unsigned char    glSegmentsChar[];

extern unsigned char    glFacesPt1[];
extern unsigned char    glFacesPt2[];
extern unsigned char    glFacesPt3[];
extern unsigned char    glFacesChar[];

// Render buffer
extern char             fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT

extern void glProjectArrays();
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
extern void glInitScreenBuffers();
extern void glBuffer2Screen();
extern void glZPlot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void glProjectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
#endif