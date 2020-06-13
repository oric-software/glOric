/*
 * glOric by Jean-Baptiste PERIN 
 * 
 */
#ifndef GLORIC_H
#define GLORIC_H

#include "config.h"

/*    ___                                      
 *   / __\  __ _  _ __ ___    ___  _ __   __ _ 
 *  / /    / _` || '_ ` _ \  / _ \| '__| / _` |
 * / /___ | (_| || | | | | ||  __/| |   | (_| |
 * \____/  \__,_||_| |_| |_| \___||_|    \__,_|
 */                                            

 // Camera Position
extern int glCamPosX;
extern int glCamPosY;
extern int glCamPosZ;

 // Camera Orientation
extern signed char glCamRotZ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
extern signed char glCamRotX;

/*    ___                 _              _    _               
 *   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
 *  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
 * / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
 * \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
 *                     |__/                                   
 */

extern unsigned char projOptions;
extern unsigned char glNbVertices;

extern signed char glVerticesX [NB_MAX_POINTS];
extern signed char glVerticesY [NB_MAX_POINTS];
extern signed char glVerticesZ [NB_MAX_POINTS];

extern signed char points2aH [NB_MAX_POINTS];
extern signed char points2aV [NB_MAX_POINTS];
extern unsigned char points2dH [NB_MAX_POINTS];
extern unsigned char points2dL [NB_MAX_POINTS];

extern void glProjectArrays();

extern void glProjectPoint(signed char x, signed char y, signed char z, signed char options, signed char *ah, signed char *av, unsigned int *dist);

/*  __                             
 * / _\   ___   ___  _ __    ___ 
 * \ \   / __| / _ \| '_ \  / _ \
 * _\ \ / (__ |  __/| | | ||  __/
 * \__/ \___| \___||_| |_| \___|
 */                        

extern unsigned char glNbParticles;
extern unsigned char glNbSegments;
extern unsigned char glNbFaces;

extern unsigned char glParticlesPt   [NB_MAX_PARTICLES];
extern unsigned char glParticlesChar [NB_MAX_PARTICLES];

extern unsigned char glSegmentsPt1 [NB_MAX_SEGMENTS];
extern unsigned char glSegmentsPt2 [NB_MAX_SEGMENTS];
extern unsigned char glSegmentsChar[NB_MAX_SEGMENTS];

extern unsigned char glFacesPt1       [NB_MAX_FACES];
extern unsigned char glFacesPt2       [NB_MAX_FACES];
extern unsigned char glFacesPt3       [NB_MAX_FACES];
extern unsigned char glFacesChar      [NB_MAX_FACES];

extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
extern void glInitScreenBuffers();
extern void glBuffer2Screen();
#endif // GLORIC_H
