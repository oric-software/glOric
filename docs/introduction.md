
glOric is a library to draw on screen the representation of a 3D scene

This introduction

First of all, let's see some fundamentals of 

Point is just cartesian coordinates in a 3D space. It is not something visible. It is just a positionnal information in space.
In glOric, points are composed of three 8-bits integer value representing the position along the orthogonal X, Y, and Z axes  of an Euclidean space.
Each point is given a number (its index in a table) by which it is referred.

Segment is a part of a line. It is something visible and drawable on screen. In Gloric segments are defined by the index of the two points corresponding to the extremities of the segment and the character that has to be used to render this segment on the screen.

Face is a triangular surface. It is something visible and drawable on screen. In glOric a face is defined by the index of the three points corresponding to the extremities of the triangle and the character that has to be used to fill the surface on the screen.

Particule is visible vertex. It is simplest visible and drawable thing on screen. In glOric a particule is defined by the index of the single points where the vertex shall be drawn and by the character that has to be used to draw this vertice on screen.
 
the Camera is the point from which particules, segments and  faces are viewed. It is called the point of view.
In glOric, the camera position is represented by 3 integer values corresponding to its 3D coordinates in the Euclidean space and the camera orientation is composed of two values for its pitch and yaw angles 

The Scene is the set of particules, segments and faces that glOric shall draw on screen is never it is in the field of view of the camera.

