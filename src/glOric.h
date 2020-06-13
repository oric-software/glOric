
#ifndef GLORIC_H
#define GLORIC_H


extern void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints, unsigned char options);

 // Camera Position
extern int CamPosX;
extern int CamPosY;
extern int CamPosZ;

 // Camera Orientation
extern char CamRotZ;			// -128 -> 127 unit : 2PI/(2^8 - 1)
extern char CamRotX;

// Geometry buffers ;
extern unsigned char nbPoints;
extern unsigned char nbFaces;
extern unsigned char nbSegments;
extern unsigned char nbParticles;

#endif