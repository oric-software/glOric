.include "config.inc"

.import popax
.import popa



;; Point 3D Coordinates
_PointX:		.word 0
_PointY:		.word 0
_PointZ:		.word 0

_Norm:          .word 0

;; Point 2D Projected Coordinates
_ResX:			.byte 0	
_ResY:			.byte 0

.segment  "ZEROPAGE"

ptrpt3:				.word 0
ptrpt2:				.word 0
nbPoints:			.byte 0
opts:				.byte 0


			.segment "CODE"

;---------------------------------------------------------------------------------
;void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints, unsigned char opts);
;---------------------------------------------------------------------------------
.export _glProject2

.proc _glProject2
	sta opts		;opts
	jsr popa
	sta nbPoints		;nbPoints
	jsr popax		;get tabpoint3D
	sta ptrpt3
	stx ptrpt3+1
	jsr popax		;get tabpoint2D
	sta ptrpt2
	stx ptrpt2+1

    ldx nbPoints
    dex
    txa ; ii = nbPoints - 1
    asl
    asl ; ii * SIZEOF_3DPOINT (4)
    clc
    adc #$03
    tay
    
    ldx nbPoints
    dex
    txa ; ii = nbPoints - 1
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

;;  		project();
        ;;jsr _project
        
;;  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;
        tya
        pha
        txa
        tay
        
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

        tya
        tax
        pla
;;  	}
    dex
    txa
    cmp #$FF
    bne dofastprojloop 
dofastprojdone:
	
	
    rts
.endproc

.export _une_fonction
 
.proc _une_fonction
	lda #SCREEN_WIDTH
    rts
.endproc

