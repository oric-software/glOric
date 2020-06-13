# Using glProject of glOric

Here's an introduction of what I would call an "Hyper Fast Projection Routine" for Oric, named `glProject`.

This function is of interest for people intending to render 3D scene on Oric in real time context because it computes screen coordinates from 3D coordinates and it does it fast .. terribly fast .. (about 500 cycles per point).

Given the camera situation (position and orientation) and a screen configuration, this function gives screen 2d-coordinates of up to 64 projected 3d points.

```C

// Camera Position
extern signed char glCamPosX;
extern signed char glCamPosY;
extern signed char glCamPosZ;

// Camera Orientation
extern char glCamRotZ;
extern char glCamRotX;

void glProject (char points2D[], char points3D[], unsigned char glNbVertices, unsigned char options);
```


As input of the function, array `points3D` contains list of `glNbVertices` 3D points stored on 4 bytes: 3 bytes for X, Y and Z coordinates and a spare bytes for futur use.

As output of function, array `points2D` if filled with `glNbVertices` 2D points stored on 4 bytes: 2 bytes for L and C (line and column coordinates) and 2 bytes for distance (between camera and point).

For exemple, here's an exemple of how to project a 3D cube:

```C
#include <glOric.h>

#define CUBE_SIZE	4
#define NB_POINTS_CUBE		8

const char ptsCube3D[]={
	 -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0 // P0
	,-CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0 // P1
	,+CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0 // P2
	,+CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0 // P3
	,-CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0 // P4
	,-CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0 // P5
	,+CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0 // P6
	,+CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0 // P7
};
char ptsCube2D [NB_POINTS_CUBE	* SIZEOF_2DPOINT];

glProject (points2D, points3D, NB_POINTS_CUBE, 0);
```

after the call to `glProject` array `points2D` contains 2D coordinates of points in `points3D`



Provided you have a function `drawLine (X1, Y1, X2, Y2)` that draws a segment between points [X1, Y1] and [X2, Y2], it is possible to draw the cube with following instructions:

```c

void lineBetweenPoints (idxPt1, idxPt2 ){
  drawLine (
	// L , C Point 1
    ptsCube2D [idxPt1*SIZEOF_2DPOINT + 0],
    ptsCube2D [idxPt1*SIZEOF_2DPOINT + 1],
	// L , C Point 2
    ptsCube2D [idxPt2*SIZEOF_2DPOINT + 0],
    ptsCube2D [idxPt2*SIZEOF_2DPOINT + 1]
	);
}

lineBetweenPoints (0, 1);
lineBetweenPoints (1, 2);
lineBetweenPoints (2, 3);
lineBetweenPoints (3, 0);
lineBetweenPoints (4, 5);
lineBetweenPoints (5, 6);
lineBetweenPoints (6, 7);
lineBetweenPoints (7, 4);
lineBetweenPoints (0, 4);
lineBetweenPoints (1, 5);
lineBetweenPoints (2, 6);
lineBetweenPoints (3, 7);

```
