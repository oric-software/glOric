#ifdef USE_REWORKED_BUFFERS
void addGeom2(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    signed char          geom[]) {

    int kk=0;
    int ii;
    int npt,nfa, nseg, npart;
    npt = geom[kk++];
    nfa = geom[kk++];
    nseg = geom[kk++];
    npart = geom[kk++];
    for (ii = 0; ii < npt; ii++){
        if (orientation == 0) {
            points3dX[nbPoints] = X + sizeX * geom[kk++];
            points3dY[nbPoints] = Y + sizeY * geom[kk++];
        } else {
            points3dY[nbPoints] = X + sizeY * geom[kk++];
            points3dX[nbPoints] = Y + sizeX * geom[kk++];
        }
        points3dZ[nbPoints] = Z + sizeZ * geom[kk++];
        nbPoints ++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < nfa; ii++){
        facesPt1[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 1
        facesPt2[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 2
        facesPt3[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 3
        facesChar[nbFaces] = geom[kk++];  // Character
        nbFaces++;
    }
    for (ii = 0; ii < nseg; ii++){
        segmentsPt1[nbSegments] = nbPoints - (npt-geom[kk++]);  // Index Point 1
        segmentsPt2[nbSegments] = nbPoints - (npt-geom[kk++]);  // Index Point 2
        segmentsChar[nbSegments] = geom[kk++]; // Character
        nbSegments++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < npart; ii++){
        particulesPt[nbParticules] = nbPoints - (npt-geom[kk++]);  // Index Point
        particulesChar[nbParticules] = geom[kk++]; // Character
        nbParticules++;        
    }
}    
#else // Not USE_REWORKED_BUFFERS
void addGeom2(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    char          geom[]) {
    // int ii, jj;
    int kk;
    // unsigned char oldNbPoints;
    // ii = (orientation == 0) ? 0 : -L;
    // jj = (orientation == 0) ? -L : 0;
    // oldNbPoints = nbPoints;

    for (kk=0; kk< geom[0]; kk++){
        points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ((orientation == 0) ? sizeX * geom[4+kk*SIZEOF_3DPOINT+0]: sizeY * geom[4+kk*SIZEOF_3DPOINT+1]);// X + ii;
        points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + ((orientation == 0) ? sizeY * geom[4+kk*SIZEOF_3DPOINT+1]: sizeX * geom[4+kk*SIZEOF_3DPOINT+0]);// Y + jj;
        points3d[nbPoints * SIZEOF_3DPOINT + 2] = Z + geom[4+kk*SIZEOF_3DPOINT+2]*sizeZ;// ;
        nbPoints++;
    }
    for (kk=0; kk< geom[1]; kk++){
        faces[nbFaces * SIZEOF_FACE + 0] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+0]);  // Index Point 1
        faces[nbFaces * SIZEOF_FACE + 1] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+1]);  // Index Point 2
        faces[nbFaces * SIZEOF_FACE + 2] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+2]);  // Index Point 3
        faces[nbFaces * SIZEOF_FACE + 3] = geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+3];  // Character
        nbFaces++;
    }
    for (kk=0; kk< geom[2]; kk++){
        segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 0]);  // Index Point 1
        segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 1]);  // Index Point 2
        segments[nbSegments * SIZEOF_SEGMENT + 2] = geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 2]; // Character
        nbSegments++;
    }
    for (kk=0; kk< geom[3]; kk++){
        particules[nbParticules * SIZEOF_PARTICULE + 0] = nbPoints - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 0]);  // Index Point
        particules[nbParticules * SIZEOF_PARTICULE + 1] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 1]; // Character
        nbParticules++;
    }
}
#endif // USE_REWORKED_BUFFERS