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
            glVerticesX[glNbVertices] = X + sizeX * geom[kk++];
            glVerticesY[glNbVertices] = Y + sizeY * geom[kk++];
        } else {
            glVerticesY[glNbVertices] = Y + sizeY * geom[kk++];
            glVerticesX[glNbVertices] = X + sizeX * geom[kk++];
        }
        glVerticesZ[glNbVertices] = Z + sizeZ * geom[kk++];
        glNbVertices ++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < nfa; ii++){
        glFacesPt1[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 1
        glFacesPt2[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 2
        glFacesPt3[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 3
        glFacesChar[glNbFaces] = geom[kk++];  // Character
        glNbFaces++;
    }
    for (ii = 0; ii < nseg; ii++){
        glSegmentsPt1[glNbSegments] = glNbVertices - (npt-geom[kk++]);  // Index Point 1
        glSegmentsPt2[glNbSegments] = glNbVertices - (npt-geom[kk++]);  // Index Point 2
        glSegmentsChar[glNbSegments] = geom[kk++]; // Character
        glNbSegments++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < npart; ii++){
        glParticlesPt[glNbParticles] = glNbVertices - (npt-geom[kk++]);  // Index Point
        glParticlesChar[glNbParticles] = geom[kk++]; // Character
        glNbParticles++;        
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
    // oldNbPoints = glNbVertices;

    for (kk=0; kk< geom[0]; kk++){
        points3d[glNbVertices * SIZEOF_3DPOINT + 0] = X + ((orientation == 0) ? sizeX * geom[4+kk*SIZEOF_3DPOINT+0]: sizeY * geom[4+kk*SIZEOF_3DPOINT+1]);// X + ii;
        points3d[glNbVertices * SIZEOF_3DPOINT + 1] = Y + ((orientation == 0) ? sizeY * geom[4+kk*SIZEOF_3DPOINT+1]: sizeX * geom[4+kk*SIZEOF_3DPOINT+0]);// Y + jj;
        points3d[glNbVertices * SIZEOF_3DPOINT + 2] = Z + geom[4+kk*SIZEOF_3DPOINT+2]*sizeZ;// ;
        glNbVertices++;
    }
    for (kk=0; kk< geom[1]; kk++){
        faces[glNbFaces * SIZEOF_FACE + 0] = glNbVertices - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+0]);  // Index Point 1
        faces[glNbFaces * SIZEOF_FACE + 1] = glNbVertices - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+1]);  // Index Point 2
        faces[glNbFaces * SIZEOF_FACE + 2] = glNbVertices - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+2]);  // Index Point 3
        faces[glNbFaces * SIZEOF_FACE + 3] = geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+3];  // Character
        glNbFaces++;
    }
    for (kk=0; kk< geom[2]; kk++){
        segments[glNbSegments * SIZEOF_SEGMENT + 0] = glNbVertices - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 0]);  // Index Point 1
        segments[glNbSegments * SIZEOF_SEGMENT + 1] = glNbVertices - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 1]);  // Index Point 2
        segments[glNbSegments * SIZEOF_SEGMENT + 2] = geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 2]; // Character
        glNbSegments++;
    }
    for (kk=0; kk< geom[3]; kk++){
        particles[glNbParticles * SIZEOF_PARTICLE + 0] = glNbVertices - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 0]);  // Index Point
        particles[glNbParticles * SIZEOF_PARTICLE + 1] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 1]; // Character
        glNbParticles++;
    }
}
#endif // USE_REWORKED_BUFFERS