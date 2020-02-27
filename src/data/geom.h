#ifndef GEOM_H
#define GEOM_H


extern char geomTriangle[];
extern char geomRectangle[];
extern char geomHouse [];
extern char geomPine [];
extern char geomCube [];
extern char geomTower [];

extern void addPlan(signed char X, signed char Y, unsigned char L, signed char orientation, char char2disp);
extern void addGeom(signed char X, signed char Y, signed char Z, unsigned char sizeX, unsigned char sizeY, unsigned char sizeZ, unsigned char orientation, char geom[]);

#endif