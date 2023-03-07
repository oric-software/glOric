/* =======================================
 * 	       glOric 3D            v1.3
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

#define GLORIC_VERSION 14

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
extern unsigned char    glNbSprites;

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


 // Geometry buffers
// extern signed char      glSpriteX[];
// extern signed char      glSpriteY[];
// extern signed char      glSpriteZ[];


// Render buffer
extern char             fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT

extern void glProjectArrays();
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
extern void glAddSprite(signed char X, signed char Y, signed char Z, signed char *sprite);
extern void glDrawSprites();
extern void glInitScreenBuffers();
extern void glBuffer2Screen();
extern void glZPlot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void glProjectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
extern void glProject (char points2D[], char points3D[], unsigned char nbVertices, unsigned char options);
extern void glLoadShape(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char orientation,
    signed char          geom[]);


extern unsigned char sl_ori;
extern signed char          *sl_geom;
extern signed char sl_X, sl_Y, sl_Z;

void glLoadShape(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char orientation,
    signed char          geom[]) {

    sl_X = X;
    sl_Y = Y;
    sl_Z = Z;
    sl_geom = geom;
    sl_ori = orientation;

    loadShape();
}

#endif