
// 0 : rz(0) : newX = x; newY = y
// 1 : rz(-pi/2) : newX = -y; newY = x
// 2 : rz(pi) : newX = -x; newY = -y
// 3 : rz(pi/2) : newX = y; newY = -x
extern unsigned char sl_kk;
extern unsigned char sl_npt,sl_nfa, sl_nseg, sl_npart;
extern unsigned char sl_ii;
extern unsigned char sl_ori;
extern signed char          *sl_geom;
extern signed char sl_X, sl_Y, sl_Z;

void addGeom2(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char orientation,
    signed char          geom[]) {

    sl_X = X;
    sl_Y = Y;
    sl_Z = Z;
    sl_geom = geom;
    sl_ori = orientation;

    loadShape();
}

#ifdef USE_C_ADDGEOM
void addGeom(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char orientation,
    signed char          geom[]) {

    sl_X = X;
    sl_Y = Y;
    sl_Z = Z;
    sl_geom = geom;
    sl_ori = orientation;

    {asm("starthere");}

    // sl_kk=0;
    {asm(":lda #0: sta _sl_kk:");}

    
    {asm("lda _sl_geom : sta tmp5 : lda _sl_geom+1 : sta tmp5+1 :"
        // sl_npt = sl_geom[sl_kk++];
         "ldy _sl_kk: lda (tmp5),y: sta _sl_npt: iny: "
        // sl_nfa = sl_geom[sl_kk++];
         ": lda (tmp5),y: sta _sl_nfa: iny: "
        // sl_nseg = sl_geom[sl_kk++];
         ": lda (tmp5),y: sta _sl_nseg: iny: "
        //  sl_npart = sl_geom[sl_kk++];
         ": lda (tmp5),y: sta _sl_npart: iny: sty _sl_kk: "
        );}

 

    for (sl_ii = 0; sl_ii < sl_npt; sl_ii++){
        if (sl_ori == 0) {
            // glVerticesX[glNbVertices] = sl_X + sl_geom[sl_kk++]; // X
            {asm("ldy _sl_kk: lda (tmp5),y: clc: adc _sl_X: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk: ");}

            // glVerticesY[glNbVertices] = sl_Y + sl_geom[sl_kk++]; // Y
            {asm("ldy _sl_kk: lda (tmp5),y: clc: adc _sl_Y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk: ");}
        } else if (sl_ori == 1){
            // glVerticesY[glNbVertices] = sl_Y + sl_geom[sl_kk++]; // X
            {asm("ldy _sl_kk: lda (tmp5),y: clc: adc _sl_Y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk: ");}
            // glVerticesX[glNbVertices] = sl_X - sl_geom[sl_kk++]; // -Y
            {asm("ldy _sl_kk: lda _sl_X: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk: ");}
        } else if (sl_ori == 2){
            // glVerticesX[glNbVertices] = sl_X - sl_geom[sl_kk++]; // -X
            {asm("ldy _sl_kk: lda _sl_X: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk: ");}
            // glVerticesY[glNbVertices] = sl_Y - sl_geom[sl_kk++]; // -Y
            {asm("ldy _sl_kk: lda _sl_Y: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk: ");}
        } else if (sl_ori == 3){
            // glVerticesY[glNbVertices] = sl_Y - sl_geom[sl_kk++]; // -X
            {asm("ldy _sl_kk: lda _sl_Y: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk: ");}
            // glVerticesX[glNbVertices] = sl_X + sl_geom[sl_kk++]; // Y
            {asm("ldy _sl_kk: lda _sl_X: clc: adc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk: ");}
        }
        // glVerticesZ[glNbVertices] = sl_Z + sl_geom[sl_kk++];
        {asm("ldy _sl_kk: lda _sl_Z: clc: adc (tmp5),y: ldy _glNbVertices: sta _glVerticesZ,y: inc _sl_kk: ");}
        // glNbVertices ++;
        // sl_kk++; // skip unused byte
        {asm(" inc _glNbVertices: inc _sl_kk:");}
    }
    for (sl_ii = 0; sl_ii < sl_nfa; sl_ii++){
        // glFacesPt1[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 1
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt1,y: inc _sl_kk: ");}
        // glFacesPt2[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 2
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt2,y: inc _sl_kk: ");}
        // glFacesPt3[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 3
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt3,y: inc _sl_kk: ");}
        // glFacesChar[glNbFaces] = sl_geom[sl_kk++];  // Character
        {asm("ldy _sl_kk: lda (tmp5),y: ldy _glNbFaces: sta _glFacesChar,y: inc _sl_kk: ");}
        // glNbFaces++;
        {asm("inc _glNbFaces: ");}
    }
    for (sl_ii = 0; sl_ii < sl_nseg; sl_ii++){
        // glSegmentsPt1[glNbSegments] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 1
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbSegments: sta _glSegmentsPt1,y: inc _sl_kk: ");}
        // glSegmentsPt2[glNbSegments] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 2
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbSegments: sta _glSegmentsPt2,y: inc _sl_kk: ");}
        // glSegmentsChar[glNbSegments] = sl_geom[sl_kk++]; // Character
        {asm("ldy _sl_kk: lda (tmp5),y: ldy _glNbSegments: sta _glSegmentsChar,y: inc _sl_kk: ");}
        // glNbSegments++;
        // sl_kk++; // skip unused byte
        {asm("inc _glNbSegments:  inc _sl_kk:");}
    }
    for (sl_ii = 0; sl_ii < sl_npart; sl_ii++){
        // glParticlesPt[glNbParticles] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point
        {asm("lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbParticles: sta _glParticlesPt,y: inc _sl_kk: ");}
        // glParticlesChar[glNbParticles] = sl_geom[sl_kk++]; // Character
        {asm("ldy _sl_kk: lda (tmp5),y: ldy _glNbParticles: sta _glParticlesChar,y: inc _sl_kk: ");}
        // glNbParticles++;        
        {asm("inc _glNbParticles: ");}
    }

    {asm("endhere");}

}   
#endif // USE_C_ADDGEOM