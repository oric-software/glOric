
# Introduction to glOric

glOric is a library to draw ascii art 3D scene on an Oric screen.

This introduction aims at providing developers with necessary information to create 3D application with glOric.

# Core concepts for 3D graphics

First of all, let's see some fundamentals of 3D graphics and how they are implemented in glOric.

A Point is just cartesian coordinates in a 3D space. It is not something visible. It is just a positional information in space.
In glOric, points are composed of three 8-bits integer value representing the position along the orthogonal X, Y, and Z axes  of an Euclidean space.
Each point is given a number (its index in a table) by which it is referred.

A Segment is a part of a line. It is something visible and drawable on screen. In glOric segments are defined by the index of the two points corresponding to the extremities of the segment and the character that has to be used to render this segment on the screen.

A Face is a triangular surface. It is something visible and drawable on screen. In glOric a face is defined by the index of the three points corresponding to the extremities of the triangle and the character that has to be used to fill the surface on the screen.

A Particle is visible vertex. It is simplest visible and drawable thing on screen. In glOric a particle is defined by the index of the single points where the vertex shall be drawn and by the character that has to be used to draw this vertex on screen.
 
The Camera is the point from which particles, segments and  faces are viewed. It is called the point of view.
In glOric, the camera position is represented by 3 integer values corresponding to its 3D coordinates in the Euclidean space and the camera orientation is composed of two values for its pitch and yaw angles 

The Scene is the set of particles, segments and faces that glOric shall draw on screen whenever it is in the field of view of the camera.


Now, let's have a look on how these concepts are instantiated in glOric.
Most of what we're going to see can be found in the `glOric_vXY.h` file. (where XY is the actual version of glOric you are using)


# Where we are watching the scene from

The camera position and orientation is set through five variables.

```C
 // Camera Position 
extern signed char      glCamPosX;
extern signed char      glCamPosY;
extern signed char      glCamPosZ;

 // Camera Orientation
extern signed char      glCamRotZ;  // -128 -> 127 unit : 2PI/(2^8 - 1)
extern signed char      glCamRotX;

```

`glCamPosX`, `glCamPosY` and `glCamPosZ` are 8 bit signed values representing the 3D coordinates of the point of view from which the 3D scene is seen (virtual camera).

`glCamRotZ` and `glCamRotX` are respectively pitch and yaw of the camera.
These angle are 8 bits fixed point values made so that the 2PI circle fits the whole 256 value range centered on 0. Thus angle excursion goes from -PI coded -128 (0x80) to PI coded 0x7F passing by 0 radians coded 0. Angle resolution is then (2PI / 256).

# Describing the 3D scene.

## Declaring points' coordinates

Now let's look at how 3D coordinates involved in scene description are given to glOric.
As we've seen earlier, points are 3D coordinates. Each of theses 3 coordinates are stored in a corresponding array:
```C
extern signed char      glVerticesX[];
extern signed char      glVerticesY[];
extern signed char      glVerticesZ[];
```

These arrays are respectively position along the X, Y, and Z axes of points in an Euclidean space.

In glOric, the convention is that X and Y coordinates are on a horizontal plan while the Z coordinates represents elevation.

If a point numbered `n` of the scene is located at position (X=2, Y=3, Z=1) then we will indicate that by setting
glVerticesX[n] = 2,  glVerticesY[n] = 3 and glVerticesZ[n] = 1,

For glOric to know the number of points that are stored in this array, it has to be indicated in the `glNbVertices` variable.
The maximum number of points is configured througb the constant named `NB_MAX_POINTS` defined in file `glOric_vXY.h`.
In any circumstance, you must ensure that the value contained in the `glNbVertices` variable is lower than the value of `NB_MAX_POINTS` (which can't be greater or equal to 256). Memory corruption can occur if this constraint is not respected.

Once points of interest of the scene are given to glOric, we can refer to them through their index to tell glOric where to draw particles, segments and faces.

Let's start to explore this with the simplest drawable element: the particle

## Declaring particles

As seen previously, a particle is just a single vertice in 3D space.
Particles are declared to glOric through the following arrays:
```C
extern unsigned char    glParticlesPt[];
extern unsigned char    glParticlesChar[];
```

`glParticlesPt` contains, for each particles, the index of the point containing the position where to draw the particle and `glParticlesChar` contains, for each particles, the character that has to be used to display the particle.

For glOric to know the number of particles that are stored in these arrays, it has to be indicated in the `glNbParticles` variable.
The maximum number of particles is configured througb the constant named `NB_MAX_ParticleS` defined in file `glOric_vXY.h`. Default max is 64.
In any circumstance, you must ensure that the value contained in the `glNbParticles` variable is lower than the value of `NB_MAX_ParticleS`. Memory corruption can occur if this constraint is not respected.

Now we're going to see how to let glOric know where and how to draw particles.

For example, let's consider we want to draw a character `P` at position (X=8, Y=12, Z=4) in the 3D scene.
Then we will first declare this coordinate in the points' arrays:

```C
glVerticesX[0] = 8;
glVerticesY[0] = 12;
glVerticesZ[0] = 4;
```
Then we declare to glOric that we have stored one point in the array by setting the `glNbVertices` variable accordingly:

```C
glNbVertices = 1;
```



Now that this point, numbered 0 (because it if the first index in the array) is known by glOric, we can refer to it to say to glOric where to draw the particle and what character shall be used to depict the particle:

```C
glParticlesPt[0]=0;      // particle number 0 shall be drawn at coordinates of point number 0
glParticlesChar[0]='P';  // particle number 0 shall display letter 'P'
```

And finally we indicate that we have stored one particle in the array of particles.

```C
glNbParticles = 1;
```

For now, we've just seen how to declare a 3D coordinate at which we want to draw a specific character. 
Before going further in how to tell glOric to actually draw things, let's see how to declare other graphic primitives such as segments and faces.

As the approach is very similar to the one we've just seen for particles, we'll cover this topic a bit faster.


## Declaring Segments

Segments are parts of line. a segment goes from one point in space to another. 

Segments are declared to glOric through the following arrays:
```C
extern unsigned char    glSegmentsPt1[];
extern unsigned char    glSegmentsPt2[];
extern unsigned char    glSegmentsChar[];
```
The number of segments shall be set in variables `glNbSegments` which shall never be greater than `NB_MAX_SEGMENTS`.

Let's consider we want a segment going from coordinates (X= 8, Y=4, Z= 0) to coordinates (X=-8, Y=4 , Z= 12) and we want this segment to be drawn with character '-' (minus).

To declare such a segment in glOric, we first need to declare the 2 points corresponding to the extremities of the segment:

```C
// Point index 0 (X= 8, Y=4, Z= 0)
glVerticesX[0] = 8;  glVerticesY[0] = 4;  glVerticesZ[0] = 0;
// Point index 1 (X=-8, Y=4 , Z= 12)
glVerticesX[1] = -8; glVerticesY[1] = 4;  glVerticesZ[1] = 12;
// we now have two points
glNbVertices = 2;
```

Now we declare one segment going from point numbered 0 to point numbered 1.

```C
// first extremity of segement number 0 is point number 0
glSegmentsPt1 [0] = 0;
// second extremity of segement number 0 is point number 1
glSegmentsPt2 [0] = 1;
// The segment shall be drawn with character '-'
glSegmentsChar [0] = '-';
// We have 1 segment declared
glNbSegments = 1;
```

## Declaring Faces

Faces are triangular surfaces delimited by three corners.
In glOric triangles are declared through the fours following arrays:
```C
extern unsigned char    glFacesPt1[];
extern unsigned char    glFacesPt2[];
extern unsigned char    glFacesPt3[];
extern unsigned char    glFacesChar[];
```

Where `glFacesPt1`, `glFacesPt2` and `glFacesPt3` are indexes of points used as corners of the triangle and `glFacesChar` is the character used  to fill the face.
The number of faces shall be set in variables `glNbFaces` which shall never be greater than `NB_MAX_FACES`.

The following code shows how to declare a face based on three points.

```C
// Declare points for corners (X= 8, Y=4, Z= 0), (X=-8, Y=4 , Z= 0), (X=0, Y=4 , Z= 8) 
glVerticesX[0] = 8;  glVerticesY[0] = 4;  glVerticesZ[0] = 0;
glVerticesX[1] = -8; glVerticesY[1] = 4;  glVerticesZ[1] = 0;
glVerticesX[2] = 0;  glVerticesY[2] = 4;  glVerticesZ[2] = 8;
glNbVertices = 3;

// Use previously declared points to describe a face that will be filled with character '*'
glFacesPt1[0]=0;
glFacesPt2[0]=1;
glFacesPt3[0]=2;
glFacesChar='*';
glNbVertices = 3;
```

## Mixing all primitives

In the examples above, 
Let's suppose we want to draw a more complex scene that mix several of the element we've see up to know.
For example a triangle similar to the one below:
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
We also have to declare a face filling the space between the three points with character '*'. 
And we also have to declare three segments corresponding to the three edge.

```C
glNbVertices = 0;

glVerticesX[glNbVertices] = 8;  glVerticesY[glNbVertices] = 4;  glVerticesZ[glNbVertices] = 0; glNbVertices ++;
glVerticesX[glNbVertices] = -8; glVerticesY[glNbVertices] = 4;  glVerticesZ[glNbVertices] = 0; glNbVertices ++;
glVerticesX[glNbVertices] = 0;  glVerticesY[glNbVertices] = 4;  glVerticesZ[glNbVertices] = 8; glNbVertices ++;


// Use previously declared points to describe a face that will be filled with character '*'

glFacesPt1[0]=0; glFacesPt2[0]=1; glFacesPt3[0]=2; glFacesChar='*';
glNbFaces = 1;

//
nbSegment = 0;

glSegmentsPt1 [nbSegment] = 0; glSegmentsPt2 [nbSegment] = 1; glSegmentsChar [nbSegment] = '/'; nbSegment ++;
glSegmentsPt1 [nbSegment] = 1; glSegmentsPt2 [nbSegment] = 2; glSegmentsChar [nbSegment] = '-'; nbSegment ++;
glSegmentsPt1 [nbSegment] = 2; glSegmentsPt2 [nbSegment] = 0; glSegmentsChar [nbSegment] = '/'; nbSegment ++;
```

You may have noticed that the characters used to draw the last segment (going from point 2 to point 0) is not '\\' (backslash) as could have been expected.

There's two reasons to explain that:
- The character '\\' (backslash) doesn't exist on Oric 
- It would have no sens to tell glOric which inclination to use to draw an oblique character since the slope of the character depends on where it is seen from.

Indeed, if you watch the triangle shown earlier from a place located in front of it or from a place located behind it, the tilt of the character used to render inclined edge is different. So it is not possible to say, by advance, how to draw  an oblique character.

That's the reason why glOric interprets the '/' as meaning 'I want an oblique character to draw this segment' and glOric will take in charge to draw the appropriate character depending on the place where the segment is seen from.

glOric will use either the native character '/' or the character '$' that you have to redefine into `\\` in order to draw an oblique segment.

As a consequence, if you explicitly want to use character  '$' or '/' to draw a given segment, you will have to redefine an other character with the one you want to use and refer to this new character in segment declaration.

Most glOric sample code come with a function that you can use to redefine a character on an Oric Atmos: 

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
        glInitScreenBuffers();

        // project 3D points to 2D coordinates
        glProjectArrays();

        // draw game scene's shapes in buffer
        glDrawFaces();
        glDrawSegments();
        glDrawParticles();

        // update display with frame buffer
        glBuffer2Screen();

    }


```

`initGame()` contains the shapes declaration and the characters redefinition as seen previously

`glInitScreenBuffers()` is a glOric's function which initializes two buffers:
- a frame buffer and a z-buffer. The frame buffer is a buffer which is a copy of the screen memory that glOric uses to prepare what is going to be displayed. Once particles, segments and faces are drawn in this buffer, the call to `glBuffer2Screen()` actually copy the frame buffer to the screen area in memory.
- a z-buffer which stores, for each position on screen, the distance of the closest  element that was drawn on this position. Read the [wikipedia article on Z-Buffering](https://en.wikipedia.org/wiki/Z-buffering) to better understand this mecanism.

`glProjectArrays()` is a function which computes, for each of the `glNbVertices` points in arrays `points3d`, the angular position of the point relatively to the camera position and orientation.

`glDrawFaces()`, `glDrawSegments()`and `glDrawParticles()` are glOric function which fill the frame buffer with characters used to respectively draw faces, segments and particles found in points, segments and faces. they also fill the z-buffer to keep memory of 



# Going further

We've seen all function provided by glOric except two the we are now going to explore because they allow to extend possiblities of glOric while benefiting of its powerful 

## 3D to 2D projection

If you remember what we've seen earlier, you know that the function glProjectArrays () computes  angular position of points contained in arrays `points3d` relatively to the camera position and orientation. The function `glProjectPoint` do the same for a single point and gives you back 
the resulting angle rather than letting them only available for drawing functions:
```C
extern void glProjectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
```

This function takes the point of coordinate (x, y, z) and put:
- in `ah` the horizontal angle between the point and the axis of the camera,
- in `av` the vertical angle between the point and the axis of the camera,
- in `dist` the distance between the point and the camera.

Just as camera angle, `ah` and `av` angles are 8 bits fixed point values coding angle from -PI coded -128 (0x80) to PI coded 0x7F passing by 0 radians coded 0. Angle resolution is then (2*PI / 256).
`dist` is a 16 bits unsigned value corresponding to the euclidean norm of vector [glCamPosX-x, ComPosY-y]

From the horizontal and vertical angles returned by glProjectPoint, it is easy to obtain screen coordinates with the following code: 

```C
    sX = (SCREEN_WIDTH -aH) >> 1;
    sY = (SCREEN_HEIGHT - aV) >> 1;
```

## plotting with distance

```C
extern void glZPlot(signed char X, signed char Y, unsigned char dist, char char2disp);
```
glZPlot is a function which allows you to plot a character `char2disp` at position (`X`,`Y`) in glOric's inner frame buffer.

The plot will only happens if the distance `dist` is lower than what's stored at position (`X`,`Y`) in glOric's inner z-buffer

It has to be noted that (`X`,`Y`) may be out of screen range. It's not a problem because the glZPlot will deals with that for you.

Thus, the visibility of what you want to draw is integrally handled by glOric. You don't have to deal with the visibility, glOric does it for you.

## Inserting sprites in 3D scene

The two functions seen above can easily be combined to incorporate sprites in a 3D scene.
Let's suppose we want to draw the text sprite 'HELLO' at  position (X=0, Y=0, Z=24) in the 3D scene.

This is going to be done in two steps:

- First we compute the screen position of the 3D coordinates where we want to draw the sprite

```C
    signed char pX, pY, pZ, sX, sY, aH, aV;
    unsigned int distance;

    pX=0; pY=0; pZ=24;
    glProjectPoint(pX, pY, pZ, 0, &aH, &aV , &distance);
    sX = (SCREEN_WIDTH -aH) >> 1;
    sY = (SCREEN_HEIGHT - aV) >> 1;
```

- Next we glZPlot the string so that it will be display if it is in field of view of the camera and if nothing hides it by being closer from the camera:

```C
    glZPlot(sX  ,sY,distance,'H');
    glZPlot(sX+1,sY,distance,'E');
    glZPlot(sX+2,sY,distance,'L');
    glZPlot(sX+3,sY,distance,'L');
    glZPlot(sX+4,sY,distance,'O');
```

