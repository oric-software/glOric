
glOric is a library to draw on screen the representation of a 3D scene

This introduction aims at providing developpers with necessary information to create 3D application with glOric

First of all, let's see some fundamentals of 3D graphics and how they are implemented in glOric.

Point is just cartesian coordinates in a 3D space. It is not something visible. It is just a positionnal information in space.
In glOric, points are composed of three 8-bits integer value representing the position along the orthogonal X, Y, and Z axes  of an Euclidean space.
Each point is given a number (its index in a table) by which it is referred.

Segment is a part of a line. It is something visible and drawable on screen. In Gloric segments are defined by the index of the two points corresponding to the extremities of the segment and the character that has to be used to render this segment on the screen.

Face is a triangular surface. It is something visible and drawable on screen. In glOric a face is defined by the index of the three points corresponding to the extremities of the triangle and the character that has to be used to fill the surface on the screen.

Particule is visible vertex. It is simplest visible and drawable thing on screen. In glOric a particule is defined by the index of the single points where the vertex shall be drawn and by the character that has to be used to draw this vertice on screen.
 
the Camera is the point from which particules, segments and  faces are viewed. It is called the point of view.
In glOric, the camera position is represented by 3 integer values corresponding to its 3D coordinates in the Euclidean space and the camera orientation is composed of two values for its pitch and yaw angles 

The Scene is the set of particules, segments and faces that glOric shall draw on screen is never it is in the field of view of the camera.

Now, let's have a look on how these concepts are instanciated in glOric.
For that, open the `glOric_vXY.h` file

The camera position and orientation by five variables

```C
 // Camera Position use only low bytes
extern signed char      CamPosX;
extern signed char      CamPosY;
extern signed char      CamPosZ;

 // Camera Orientation
extern signed char      CamRotZ;  // -128 -> 127 unit : 2PI/(2^8 - 1)
extern signed char      CamRotX;

```

`CamPosX`, `CamPosY` and `CamPosZ` are the 3D coordinates of the point of view from which the 3D scene is seen (virtual camera).
`CamPosX`, `CamPosY` and `CamPosZ` are 8 bits signed values.

`CamRotZ` and `CamRotX` are respectively pitch and yaw of the camera.
These angle are 8 bits fixed point values made so that the 2*PI circle fits the whole 256 value range centered on 0. Thus angle excursion goes from -PI coded -128 (0x80) to PI coded 0x7F passing by 0 radians coded 0. Angle resolution is then (2*PI / 256).

## Declaring points'coordinates

Now let's look at how 3D coordinates involved in scene description are given to glOric.
As we've seen earlier, points are 3D coordinates. Each of theses 3 coordinates are stored in a corresponding array:
```C
extern signed char      points3dX[];
extern signed char      points3dY[];
extern signed char      points3dZ[];
```

These arrays are respecively position along the X, Y, and Z axes of points in an Euclidean space.

In glOric, the convention is that X and Y coordinates are on a horizontal plan while the Z coordinates represents elevation.

If a point numbered `n` of the scene is located at position (X=2, Y=3, Z=1) then we will indicate that by setting
points3dX[n] = 2,  points3dY[n] = 3 and points3dZ[n] = 1,

For glOric to know the number of points that are stored in this array, it has to be indicated in the `nbPoints` variable.
The maximum number of points is configured througb the constant named `NB_MAX_POINTS` defined in file `glOric_vXY.h`.
In any circunstance, you must ensure that the value contained in the `nbPoints` variable is lower than the value of `NB_MAX_POINTS`. Memory corruption can occur if this constraint is not respected.

Once points of interest of the scene are given to glOric, we can refer to them through their index to tell glOric where to draw particules, segments and faces.

Let's start to explore this with the simplest drawable element: the particule

## Declaring particules

As seen previously, a particule is just a single vertice in 3D space.
Particules are declared to glOric through the following arrays:
```C
extern unsigned char    particulesPt[];
extern unsigned char    particulesChar[];
```

`particulesPt` contains, for each particules, the index of the point containing the position where to draw the particule and `particulesChar` contains, for each particules, the character that has to be used to display the particule.

For glOric to know the number of particules that are stored in these arrays, it has to be indicated in the `nbParticules` variable.
The maximum number of particules is configured througb the constant named `NB_MAX_PARTICULES` defined in file `glOric_vXY.h`. Default max is 64.
In any circunstance, you must ensure that the value contained in the `nbParticules` variable is lower than the value of `NB_MAX_PARTICULES`. Memory corruption can occur if this constraint is not respected.

Now we're going to see how to let glOric know where and how to draw particules.

For exemple, let's consider we want to draw a character `P` at position (X=8, Y=12, Z=4) in the 3D scene.
Then we will first declare this coordinate in the points'arrays:

```C
points3dX[0] = 8;
points3dY[0] = 12;
points3dZ[0] = 4;
```
Then we declare to glOric that we have stored one point in the array by setting the `nbPoints` variable accordingly:

```C
nbPoints = 1;
```



Now that this point, numbered 0 (because it if the first index in the array) is known by glOric, we can refer to it to say to glOric where to draw the particule and what character shall be used to depict the particule:

```C
particulesPt[0]=0;      // particule number 0 shall be drawn at coordinates of point number 0
particulesChar[0]='P';  // particule number 0 shall display letter 'P'
```

And finally we indicate that we have stored one particule in the array of particules.

```C
nbParticules = 1;
```

For now, we've just seen how to declare a 3D coordinate at which we want to draw a specific character. 
Before going further in how to tell glOric to actually draw things, let's see how to declare other graphic primitives such as segments and faces.

As the approach is very similar to the one we've just seen for particules, we'll cover this topic a bit faster.


## Declaring Segments

Segments are parts of line. a segment goes from one point in space to another. 

Segments are declared to glOric through the following arrays:
```C
extern unsigned char    segmentsPt1[];
extern unsigned char    segmentsPt2[];
extern unsigned char    segmentsChar[];
```
The number of segments shall be set in variables `nbSegments` which shall never be greater than `NB_MAX_SEGMENTS`.

Let's consider we want a segment going from coordinates (X= 8, Y=4, Z= 0) to coordinates (X=-8, Y=4 , Z= 12) and we want this segment to be drawn with character '-' (minus).

To declare such a segment in glOric, we first need to declare the 2 points corresponding to the extremities of the segment:

```C
// Point index 0 (X= 8, Y=4, Z= 0)
points3dX[0] = 8;  points3dY[0] = 4;  points3dZ[0] = 0;
// Point index 1 (X=-8, Y=4 , Z= 12)
points3dX[1] = -8; points3dY[1] = 4;  points3dZ[1] = 12;
// we now have two points
nbPoints = 2;
```

Now we declare one segment going from point numbered 0 to point numbered 1.

```C
// first extremity of segement number 0 is point number 0
segmentsPt1 [0] = 0;
// second extremity of segement number 0 is point number 1
segmentsPt2 [0] = 1;
// The segment shall be drawn with character '-'
segmentsChar [0] = '-';
// We have 1 segment declared
nbSegments = 1;
```

# Declaring Faces

Faces are triangular surfaces delimited by three corners.
In glOric triangles are declared through the fours following arrays:
```C
extern unsigned char    facesPt1[];
extern unsigned char    facesPt2[];
extern unsigned char    facesPt3[];
extern unsigned char    facesChar[];
```

Where `facesPt1`, `facesPt2` and `facesPt3` are indexes of points used as corners of the triangle and `facesChar` is the character used  to fill the face.
The number of faces shall be set in variables `nbFaces` which shall never be greater than `NB_MAX_FACES`.

The following code shows how to declare a face based on three points.

```C
// Declare points for corners (X= 8, Y=4, Z= 0), (X=-8, Y=4 , Z= 0), (X=0, Y=4 , Z= 8) 
points3dX[0] = 8;  points3dY[0] = 4;  points3dZ[0] = 0;
points3dX[1] = -8; points3dY[1] = 4;  points3dZ[1] = 0;
points3dX[2] = 0;  points3dY[2] = 4;  points3dZ[2] = 8;
nbPoints = 3;

// Use previously declared points to describe a face that will be filled with character '*'
facesPt1[0]=0;
facesPt2[0]=1;
facesPt3[0]=2;
facesChar='*';
```



