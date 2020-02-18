#ifndef ALPHABET_H
#define ALPHABET_H

#ifdef TEXTDEMO

char geomLetterM[] = {
    /* Nb Coords = */ 5,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 4,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    0, 0, 1, 0,   // P0
    0, 0, 7, 0,   // P1
    2, 0, 4, 0,   // P2
    4, 0, 7, 0,   // P3
    4, 0, 1, 0,   // P4
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 77, 0,  //124, 0
    1, 2, 77, 0,  //92, 0
    2, 3, 77, 0,  //47, 0
    3, 4, 77, 0   //124, 0
    // Particule List : idxPoint1, character

};

char geomLetterC[] = {
    /* Nb Coords = */ 8,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 7,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    4, 0, 2, 0,   // P0
    3, 0, 1, 0,   // P1
    1, 0, 1, 0,   // P2
    0, 0, 2, 0,   // P3
    0, 0, 6, 0,   // P4
    1, 0, 7, 0,   // P5
    3, 0, 7, 0,   // P6
    4, 0, 6, 0,   // P7
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 67, 0,  // 47, 0
    1, 2, 67, 0,  // 45, 0
    2, 3, 67, 0,  // 92, 0
    3, 4, 67, 0,  // 124, 0
    4, 5, 67, 0,  // 47, 0
    5, 6, 67, 0,  // 45, 0
    6, 7, 67, 0   // 92, 0
    // Particule List : idxPoint1, character

};

char geomLetterI[] = {
    /* Nb Coords = */ 6,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 3,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    1, 0, 1, 0,   // P0
    3, 0, 1, 0,   // P1
    1, 0, 7, 0,   // P2
    3, 0, 7, 0,   // P3
    2, 0, 1, 0,   // P4
    2, 0, 7, 0,   // P5
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 73, 0,  // 45, 0
    2, 3, 73, 0,  // 45, 0
    4, 5, 73, 0   // 124, 0
    // Particule List : idxPoint1, character
};

char geomLetterR[] = {
    /* Nb Coords = */ 9,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 7,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    0, 0, 1, 0,   // P0
    0, 0, 7, 0,   // P1
    3, 0, 7, 0,   // P2
    4, 0, 6, 0,   // P3
    4, 0, 5, 0,   // P4
    3, 0, 4, 0,   // P5
    0, 0, 4, 0,   // P6
    1, 0, 4, 0,   // P7
    4, 0, 1, 0,   // P8
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 82, 0,  // 124, 0
    1, 2, 82, 0,  // 45, 0
    2, 3, 82, 0,  // 92, 0
    3, 4, 82, 0,  // 124, 0
    4, 5, 82, 0,  // 47, 0
    5, 6, 82, 0,  // 45, 0
    7, 8, 82, 0   // 92, 0
    // Particule List : idxPoint1, character
};

char geomLetterE[] = {
    /* Nb Coords = */ 6,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 4,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    0, 0, 7, 0,   // P0
    4, 0, 7, 0,   // P1
    0, 0, 1, 0,   // P2
    4, 0, 1, 0,   // P3
    4, 0, 4, 0,   // P4
    0, 0, 4, 0,   // P5
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 69, 0,  // 45, 0
    0, 2, 69, 0,  // 124, 0
    2, 3, 69, 0,  // 45, 0
    5, 4, 69, 0   // 45, 0
    // Particule List : idxPoint1, character
};

char geomLetterN[] = {
    /* Nb Coords = */ 4,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 3,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    0, 0, 1, 0,   // P0
    0, 0, 7, 0,   // P1
    4, 0, 1, 0,   // P2
    4, 0, 7, 0,   // P3
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 78, 0,  //124, 0
    1, 2, 78, 0,  //92 , 0
    2, 3, 78, 0   //124, 0
    // Particule List : idxPoint1, character
};

#endif  //TEXTDEMO

#endif