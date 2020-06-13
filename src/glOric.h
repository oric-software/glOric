
#ifndef GLORIC_H
#define GLORIC_H


extern void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char glNbVertices, unsigned char options);

 // Camera Position
extern int glCamPosX;
extern int glCamPosY;
extern int glCamPosZ;

 // Camera Orientation
extern char glCamRotZ;			// -128 -> 127 unit : 2PI/(2^8 - 1)
extern char glCamRotX;

// Geometry buffers ;
extern unsigned char glNbVertices;
extern unsigned char glNbFaces;
extern unsigned char glNbSegments;
extern unsigned char glNbParticles;

#endif