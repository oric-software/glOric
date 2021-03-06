
.zero

ptrpt3:
ptrpt3L .dsb 1
ptrpt3H .dsb 1
ptrpt2:
ptrpt2L .dsb 1
ptrpt2H .dsb 1


#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif

nbPoints				.dsb 1
pOptions				.dsb 1

.text


;;  void doFastProjection(){
_doFastProjection:
.(
;;  	unsigned char ii = 0;

;;  	for (ii = glNbVertices-1; ii< 0; ii--){

    ldx _glNbVertices
    dex
    txa ; ii = glNbVertices - 1
    asl
    asl ; ii * SIZEOF_3DPOINT (4)
    clc
    adc #$03
    tay

    ldx _glNbVertices
    dex
    txa ; ii = glNbVertices - 1
    asl
    asl ; ii * SIZEOF_2DPOINT (4)
    clc
    adc #$03
    tax

dofastprojloop:
;;          Status = points3d[ii*SIZEOF_3DPOINT + 3]
        dey
;;  		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
        lda (ptrpt3),y
        sta _PointZ
        dey
;;  		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
        lda (ptrpt3),y
        sta _PointY
        dey
;;  		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
        lda (ptrpt3),y
        sta _PointX
        dey

;;  		project_i16();
        ; jsr _project_i16
		jsr _project_i8o8

        tya
        pha
        txa
        tay

#ifndef HRSDEMO
 ;;  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;

        lda _Norm+1
        sta (ptrpt2), y
        dey

        lda _Norm
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
;;  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y

#else
        lda _ResY+1
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
        dey

        lda _ResX+1
        sta (ptrpt2), y
;;  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y

#endif
        tya
        tax
        pla
        tay
;;  	}
    dex
    txa
    cmp #$FF
    bne dofastprojloop   ;; FIXME : does not allows more than 127 points
dofastprojdone:
;;  }
.)
    rts




;; void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char glNbVertices, unsigned char options);
_glProject
.(
	ldx #6 : lda #4 : jsr enter :
	ldy #0 : lda (ap),y : sta reg0 : sta ptrpt2L : iny : lda (ap),y : sta reg0+1 : sta ptrpt2H :
	ldy #2 : lda (ap),y : sta reg0 : sta ptrpt3L : iny : lda (ap),y : sta reg0+1 : sta ptrpt3H :
	ldy #4 : lda (ap),y : sta tmp0 : sta nbPoints ; iny : lda (ap),y : sta tmp0+1 :
	ldy #6 : lda (ap),y : sta tmp0 : sta pOptions ; iny : lda (ap),y : sta tmp0+1 :

	jsr _doFastProjection
	jmp leave :
.)

