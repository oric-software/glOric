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
extern int CamPosX;
extern int CamPosY;
extern int CamPosZ;

 // Camera Orientation
extern signed char CamRotZ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
extern signed char CamRotX;

/*    ___                 _              _    _               
 *   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
 *  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
 * / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
 * \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
 *                     |__/                                   
 */

extern unsigned char projOptions;
extern unsigned char nbPoints;

extern signed char points3dX [NB_MAX_POINTS];
extern signed char points3dY [NB_MAX_POINTS];
extern signed char points3dZ [NB_MAX_POINTS];

extern signed char points2aH [NB_MAX_POINTS];
extern signed char points2aV [NB_MAX_POINTS];
extern unsigned char points2dH [NB_MAX_POINTS];
extern unsigned char points2dL [NB_MAX_POINTS];

extern void glProjectArrays();

extern void projectPoint(signed char x, signed char y, signed char z, signed char options, signed char *ah, signed char *av, unsigned int *dist);

/*  __                             
 * / _\   ___   ___  _ __    ___ 
 * \ \   / __| / _ \| '_ \  / _ \
 * _\ \ / (__ |  __/| | | ||  __/
 * \__/ \___| \___||_| |_| \___|
 */                        

extern unsigned char nbParticles;
extern unsigned char nbSegments;
extern unsigned char nbFaces;

extern unsigned char particlesPt   [NB_MAX_PARTICLES];
extern unsigned char particlesChar [NB_MAX_PARTICLES];

extern unsigned char segmentsPt1 [NB_MAX_SEGMENTS];
extern unsigned char segmentsPt2 [NB_MAX_SEGMENTS];
extern unsigned char segmentsChar[NB_MAX_SEGMENTS];

extern unsigned char facesPt1       [NB_MAX_FACES];
extern unsigned char facesPt2       [NB_MAX_FACES];
extern unsigned char facesPt3       [NB_MAX_FACES];
extern unsigned char facesChar      [NB_MAX_FACES];

extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
extern void initScreenBuffers();
extern void buffer2screen(char destAdr[]);
#endif // GLORIC_H
