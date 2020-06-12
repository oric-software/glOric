
glOric is a library to draw on screen the representation of a 3D scene

This introduction aims at providing developpers with necessary information to create 3D application with glOric

# Core concepts for 3D graphics

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


# Where we are watching the scene from

The camera position and orientation is set through five variables.

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

# Describing the 3D scene.

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

## Declaring Faces

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
nbPoints = 3;
```

## Mixing all primitives

In the examples above, 
Let's suppose we want to draw a more complex scene that mix several of the element we've see up to know.
For exemple a triangle similar to the one below:
```                 
                    /     <- Point 0     
                   /*\         
                  /***\        
                 /*****\       
                /*******\      
               /*********\     
              /***********\    
             /*************\   
 Point 1 -> -----------------   <- Point 2
```

To render such a shape, we need to declare 3 points 
We also have to declare a face filling the space bertween the three points with character '*'. 
And we also have to declare three segments corresponding to the three edge.

```C
nbPoints = 0;

points3dX[nbPoints] = 8;  points3dY[nbPoints] = 4;  points3dZ[nbPoints] = 0; nbPoints ++;
points3dX[nbPoints] = -8; points3dY[nbPoints] = 4;  points3dZ[nbPoints] = 0; nbPoints ++;
points3dX[nbPoints] = 0;  points3dY[nbPoints] = 4;  points3dZ[nbPoints] = 8; nbPoints ++;


// Use previously declared points to describe a face that will be filled with character '*'

facesPt1[0]=0; facesPt2[0]=1; facesPt3[0]=2; facesChar='*';
nbFaces = 1;

//
nbSegment = 0;

segmentsPt1 [nbSegment] = 0; segmentsPt2 [nbSegment] = 1; segmentsChar [nbSegment] = '/'; nbSegment ++;
segmentsPt1 [nbSegment] = 1; segmentsPt2 [nbSegment] = 2; segmentsChar [nbSegment] = '-'; nbSegment ++;
segmentsPt1 [nbSegment] = 2; segmentsPt2 [nbSegment] = 0; segmentsChar [nbSegment] = '/'; nbSegment ++;
```

You may have noticed that the characters used to draw the last segment (going from point 2 to point 0) is not '\\' (backslah) as could have been expected.

There's two reasons to explain that:
- The character '\\' (backslah) doesn't exist on Oric 
- It would have no sens to tell glOric which inclinaison to use to draw an oblique character since the slope of the character depends on where it is seen from.

Indeed, if you watch the triangle shown earlier from a place located in front of it or from a place located behind it, the tilt of the character used to render inclined edge is different. So it is not possible to say, by advance, how to draw  an oblique character.

That's the reason why glOric interprets the '/' as meaning 'I want an oblique character to draw this segment' and glOric will take in charge to draw the appropriate character depending on the place where the segment is seen from.

glOric will use either the native character '/' or the character '$' that you have to redefine into `\\` in order to draw an oblique segment.

As a consequence, if you explictly want to use character  '$' or '/' to draw a given semgent, you will have to redefine an other character with the one you want to use and refer to this new character in segment declaration.

Most glOric sample code come with a fonction that you can use to redefine a character on an Oric Atmos: 

```C
void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08) {
    unsigned char* adr;
    adr      = (unsigned char*)(0xB400 + c * 8);
    *(adr++) = patt01;
    *(adr++) = patt02;
    *(adr++) = patt03;
    *(adr++) = patt04;
    *(adr++) = patt05;
    *(adr++) = patt06;
    *(adr++) = patt07;
    *(adr++) = patt08;
}
```

In you plan to use oblique segment (specified by the '/' character ), you have to call this function from your initialisation function in order to redefine the `$` character that glOric will use to draw oblique segments:

```C
    // Change DOLLAR ($) sign into BACKSLASH (\) to draw oblique lines 
    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);
```


# Getting the 3D scene rendered on screen

Up to now we've only seen how to describe the 3D scene to glOric. 

You might be happy to learn that the most difficult part is done.

Indeed, glOric takes in charge all the rest of the process of rendering the scene on the screen of your beloved Oric.



In order to have a general view of the rendering process before entering into details, let's have a look at an example game loop using glOric:

```C
    initGame (); 

    while (inGame) {

        /*
         ... Insert Here Your Game Stuff  ...
         */

        // empty buffer
        initScreenBuffers();

        // project 3D points to 2D coordinates
        glProjectArrays();

        // draw game scene's shapes in buffer
        glDrawFaces();
        glDrawSegments();
        glDrawParticules();

        // update display with frame buffer
        buffer2screen();

    }


```

`initGame()` contains the shapes declaration and the characters redefinition as seen previously

`initScreenBuffers()` is a glOric's function which initializes two buffers:
- a frame buffer and a z-buffer. The frame buffer is a buffer which is a copy of the screen memory that glOric uses to prepare what is going to be displayed. Once particules, segments and facces are drawn in this buffer, the call to `buffer2screen()` actually copy the frame buffer to the screen area in memory.
- a z-buffer which stores, for each position on screen, the distance of the closest  element that was drawn on this position. Read the [wikipedia article on Z-Buffering](https://en.wikipedia.org/wiki/Z-buffering) to better understand this mecanism.

`glProjectArrays()` is a function which computes, for each of the `nbPoints` points in arrays `points3d`, the angular position of the point relatively to the camera position and orientation.

`glDrawFaces()`, `glDrawSegments()`and `glDrawParticules()` are glOric's function which fill the frame buffer with characters used to respectively draw faces, segments and particules found in points, segments and faces. they also fill the z-buffer to keep memory of 



# Going further

We've seen all function provided by glOric except two the we are now going to explore.

If you remember what we've seen earlier, you know that the function glProjectArrays () computes  angular position of points contained in arrays `points3d` relatively to the camera position and orientation. The function `projectPoint` do the same for a single point and gives you back 
the resulting angle rather than letting them only available for drawing functions:
```C
extern void projectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
```

This function takes the point of coordinate (x, y, z) and put:
- in `ah` the horizontal angle between the point and the axis of the camera,
- in `av` the vertical angle between the point and the axis of the camera,
- in `dist` the distance between the point and the camera.

Just as camera angle, `ah` and `av` angles are 8 bits fixed point values coding angle from -PI coded -128 (0x80) to PI coded 0x7F passing by 0 radians coded 0. Angle resolution is then (2*PI / 256).
dist is a 16 bits unsigned value corresponding to the euclidian norm of vector [CamPosX-x, ComPosY-y]

```C
extern void zplot(signed char X, signed char Y, unsigned char dist, char char2disp);
```


