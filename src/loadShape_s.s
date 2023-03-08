

;; unsigned char sl_kk=0;
_sl_kk .dsb 1
;; unsigned char sl_npt,sl_nfa, sl_nseg, sl_npart;
_sl_npt .dsb 1
_sl_nfa .dsb 1
_sl_nseg .dsb 1
_sl_npart .dsb 1
;; unsigned char sl_ii;
_sl_ii .dsb 1
;; unsigned char sl_ori;
_sl_ori .dsb 1
;; signed char          *sl_geom;
_sl_geom .dsb 2
;; signed char sl_X, sl_Y, sl_Z;
_sl_X  .dsb 1
_sl_Y .dsb 1
_sl_Z .dsb 1



_loadShape:
.(

;; sl_kk=0;
lda #0: sta _sl_kk:

lda _sl_geom : sta tmp5 : lda _sl_geom+1 : sta tmp5+1 :
;; sl_npt = sl_geom[sl_kk++];
ldy _sl_kk: lda (tmp5),y: sta _sl_npt: iny:
;; sl_nfa = sl_geom[sl_kk++];
lda (tmp5),y: sta _sl_nfa: iny:
;; sl_nseg = sl_geom[sl_kk++];
lda (tmp5),y: sta _sl_nseg: iny:
;;  sl_npart = sl_geom[sl_kk++];
lda (tmp5),y: sta _sl_npart: iny: sty _sl_kk:


lda _sl_npt
sta _sl_ii
bne startlooppoint
jmp endlooppoint
startlooppoint:

    lda _sl_ori
    bne case1
        ;; glVerticesX[glNbVertices] = sl_X + sl_geom[sl_kk++]; // X
        ldy _sl_kk: lda (tmp5),y: clc: adc _sl_X: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk:
        ;; glVerticesY[glNbVertices] = sl_Y + sl_geom[sl_kk++]; // Y
        ldy _sl_kk: lda (tmp5),y: clc: adc _sl_Y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk:

    jmp endswitch
case1:
    cmp #1
    bne case2
        ;; glVerticesY[glNbVertices] = sl_Y + sl_geom[sl_kk++]; // X
        ldy _sl_kk: lda (tmp5),y: clc: adc _sl_Y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk:
        ;; glVerticesX[glNbVertices] = sl_X - sl_geom[sl_kk++]; // -Y
        ldy _sl_kk: lda _sl_X: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk:

    jmp endswitch    
case2:
    cmp #2
    bne case3
        ;; glVerticesX[glNbVertices] = sl_X - sl_geom[sl_kk++]; // -X
        ldy _sl_kk: lda _sl_X: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk:
        ;; glVerticesY[glNbVertices] = sl_Y - sl_geom[sl_kk++]; // -Y
        ldy _sl_kk: lda _sl_Y: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk:

    jmp endswitch
case3:
    cmp #3
    bne endswitch
        ;; glVerticesY[glNbVertices] = sl_Y - sl_geom[sl_kk++]; // -X
        ldy _sl_kk: lda _sl_Y: sec: sbc (tmp5),y: ldy _glNbVertices: sta _glVerticesY,y: inc _sl_kk:
        ;; glVerticesX[glNbVertices] = sl_X + sl_geom[sl_kk++]; // Y
        ldy _sl_kk: lda _sl_X: clc: adc (tmp5),y: ldy _glNbVertices: sta _glVerticesX,y: inc _sl_kk:


endswitch:

    ;; glVerticesZ[glNbVertices] = sl_Z + sl_geom[sl_kk++];
    ldy _sl_kk: lda _sl_Z: clc: adc (tmp5),y: ldy _glNbVertices: sta _glVerticesZ,y: inc _sl_kk:
    ;; glNbVertices ++;
    ;; sl_kk++; // skip unused byte
    inc _glNbVertices: inc _sl_kk:



dec _sl_ii
lda _sl_ii
beq endlooppoint
jmp startlooppoint
endlooppoint:   


lda _sl_nfa
sta _sl_ii
bne startloopfaces
jmp endloopfaces
startloopfaces:

    ;; glFacesPt1[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 1
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt1,y: inc _sl_kk:
    ;; glFacesPt2[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 2
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt2,y: inc _sl_kk:
    ;; glFacesPt3[glNbFaces] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 3
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbFaces: sta _glFacesPt3,y: inc _sl_kk:
    ;; glFacesChar[glNbFaces] = sl_geom[sl_kk++];  // Character
    ldy _sl_kk: lda (tmp5),y: ldy _glNbFaces: sta _glFacesChar,y: inc _sl_kk:
    ;; glNbFaces++;
    inc _glNbFaces:


dec _sl_ii
lda _sl_ii
beq endloopfaces
jmp startloopfaces
endloopfaces:   

lda _sl_nseg
sta _sl_ii
bne startloopsegments
jmp endloopsegments
startloopsegments:

    ;; glSegmentsPt1[glNbSegments] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 1
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbSegments: sta _glSegmentsPt1,y: inc _sl_kk:
    ;; glSegmentsPt2[glNbSegments] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point 2
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbSegments: sta _glSegmentsPt2,y: inc _sl_kk:
    ; glSegmentsChar[glNbSegments] = sl_geom[sl_kk++]; // Character
    ldy _sl_kk: lda (tmp5),y: ldy _glNbSegments: sta _glSegmentsChar,y: inc _sl_kk:
    ;; glNbSegments++;
    ;; sl_kk++; // skip unused byte
    inc _glNbSegments:  inc _sl_kk:

dec _sl_ii
lda _sl_ii
beq endloopsegments
jmp startloopsegments
endloopsegments:   

lda _sl_npart
sta _sl_ii
bne startloopparticules
jmp endloopparticules
startloopparticules:

    ;; glParticlesPt[glNbParticles] = glNbVertices - (sl_npt-sl_geom[sl_kk++]);  // Index Point
    lda _glNbVertices: sec:  sbc _sl_npt: ldy _sl_kk: clc: adc (tmp5),y: ldy _glNbParticles: sta _glParticlesPt,y: inc _sl_kk:
    ;; glParticlesChar[glNbParticles] = sl_geom[sl_kk++]; // Character
    ldy _sl_kk: lda (tmp5),y: ldy _glNbParticles: sta _glParticlesChar,y: inc _sl_kk:
    ;; glNbParticles++;        
    inc _glNbParticles:

dec _sl_ii
lda _sl_ii
beq endloopparticules
jmp startloopparticules
endloopparticules:   

.)
    rts
