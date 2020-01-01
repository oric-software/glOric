


#include "config.h"
#include "glOric.h"


.text


 // Camera Position
_CamPosX:		.dsb 2
_CamPosY:		.dsb 2
_CamPosZ:		.dsb 2

 // Camera Orientation
_CamRotZ:		.dsb 1			// -128 -> -127 unit : 2PI/(2^8 - 1)
_CamRotX:		.dsb 1


//char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//unsigned char nbPoints=0;
_nbPoints       .dsb 1
//.dsb 256-(*&255)
//_points3d       .dsb NB_MAX_POINTS*SIZEOF_3DPOINT

//char segments[NB_MAX_SEGMENTS*SIZEOF_SEGMENT];
//unsigned char nbSegments=0;
_nbSegments     .dsb 1
.dsb 256-(*&255)
_segments       .dsb NB_MAX_SEGMENTS*SIZEOF_SEGMENT

//char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_POINTS*SIZEOF_2DPOINT

.zero

ptrpt3:
ptrpt3L .dsb 1
ptrpt3H .dsb 1
ptrpt2:
ptrpt2L .dsb 1
ptrpt2H .dsb 1

.text
//  void doProjection(){
_doProjection:
.(
//  	unsigned char ii = 0;
//  	for (ii = 0; ii< nbPoints; ii++){
    lda _nbPoints
    beq doprojdone
    tax
    dex
doprojloop:
//  		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
        txa
        asl
        asl
        sta ptrpt3L
        lda #<_points3d
        clc
        adc ptrpt3L
        sta ptrpt3L
        lda #>_points3d
        adc #$00
        sta ptrpt3H
        ldy #$00
        lda (ptrpt3),y
        sta _PointX

//  		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
        iny
        lda (ptrpt3),y
        sta _PointY

//  		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
        iny
        lda (ptrpt3),y
        sta _PointZ

//  		project();
        jsr _project
//  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        txa
        asl
        sta ptrpt2L
        lda #<_points2d
        clc
        adc ptrpt2L
        sta ptrpt2L
        lda #>_points2d
        adc #$00
        sta ptrpt2H

        ldy #$00
        lda _ResX
        sta (ptrpt2),y

//  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;
        iny
        lda _ResY
        sta (ptrpt2),y
//  	}
    dex
    bpl doprojloop   ;; FIXME : does not allows more than 127 points
doprojdone:
//  }
.)
    rts


//  void doProjection(){
_doFastProjection:
.(
//  	unsigned char ii = 0;
//  	for (ii = nbPoints-1; ii< 0; ii--){
    ;; TODO : move this in an init function to save instruction
//    lda #>_points3d
//    sta ptrpt3H
//    lda #<_points3d  ;; TODO : use 0 instead if table is aligned on page
//    sta ptrpt3L
//    lda #<_points2d
//    sta ptrpt2L
//    lda #>_points2d
//    sta ptrpt2H

    ldx _nbPoints
    dex
    txa ; ii = nbPoints - 1
    asl
    asl ; ii * SIZEOF_3DPOINT (4)
    clc
    adc #$03
    tay
    
    ldx _nbPoints
    dex
    txa ; ii = nbPoints - 1
    asl
    asl ; ii * SIZEOF_2DPOINT (4)
    clc
    adc #$03
    tax
    
dofastprojloop:
//          Status = points3d[ii*SIZEOF_3DPOINT + 3]
        dey
//  		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
        lda (ptrpt3),y
        sta _PointZ
        dey
//  		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
        lda (ptrpt3),y
        sta _PointY
        dey
//  		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
        lda (ptrpt3),y
        sta _PointX
        dey

//  		project();
        jsr _project
		
        tya
        pha
        txa
        tay
		
#ifdef TEXTMODE      
 //  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;
     
        lda _Norm+1
        sta (ptrpt2), y
        dey 

        lda _Norm
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
//  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
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
//  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y
		
#endif		
        tya
        tax
        pla
        tay
//  	}
    dex
    txa
    cmp #$FF
    bne dofastprojloop   ;; FIXME : does not allows more than 127 points
dofastprojdone:
//  }
.)
    rts


 // Point 3D Coordinates
_PointX:		.dsb 2
_PointY:		.dsb 2
_PointZ:		.dsb 2




 // Point 2D Projected Coordinates
_ResX:			.dsb 2			// -128 -> 127
_ResY:			.dsb 2			// -128 -> 127

 // Intermediary Computation
_DeltaX:		.dsb 2
_DeltaY:		.dsb 2
_DeltaZ:		.dsb 2

_DeltaXSquare:	.dsb 4
_DeltaYSquare:	.dsb 4

_Norm:          .dsb 2
_AngleH:        .dsb 1
_AngleV:        .dsb 1


//_Quotient:		.dsb 2
//_Divisor:		.dsb 2
//_Remainder :	.dsb 2
//
AnglePH .dsb 1 ; horizontal angle of point from player pov
AnglePV .dsb 1 ; vertical angle of point from player pov


_project:
.(
	// save context
    pha:txa:pha:tya:pha

	// DeltaX = CamPosX - PointX
	// Divisor = DeltaX
	sec
	lda _PointX
	sbc _CamPosX
	sta _DeltaX
	lda _PointX+1
	sbc _CamPosX+1
	sta _DeltaX+1

	// DeltaY = CamPosY - PointY
	sec
	lda _PointY
	sbc _CamPosY
	sta _DeltaY
	lda _PointY+1
	sbc _CamPosY+1
	sta _DeltaY+1

    // AngleH = atan2 (DeltaY, DeltaX)
    lda _DeltaY
    sta _ty
    lda _DeltaX
    sta _tx
    jsr _fastatan2 ; _atan2_8
    lda _res
    sta _AngleH

    // Norm = norm (DeltaX, DeltaY)
    jsr _hyperfastnorm; fastnorm ; ultrafastnorm ; ; 

   	// DeltaZ = CamPosZ - PointZ
	sec
	lda _PointZ
	sbc _CamPosZ
	sta _DeltaZ
	lda _PointZ+1
	sbc _CamPosZ+1
	sta _DeltaZ+1

    // AngleV = atan2 (DeltaZ, Norm)
    lda _DeltaZ
    sta _ty
    lda _Norm
    sta _tx
    jsr _fastatan2 ; _atan2_8
    lda _res
    sta _AngleV

    // AnglePH = AngleH - CamRotZ
    sec
    lda _AngleH
    sbc _CamRotZ
    sta AnglePH

    // AnglePV = AngleV - CamRotX
    sec
    lda _AngleV
    sbc _CamRotX
    sta AnglePV

#ifdef TEXTMODE
	// Quick Disgusting Hack
	lda AnglePH
	eor #$FF
	sec
	adc #$00
	cmp #$80
	ror
	clc
    adc #SCREEN_WIDTH/2
	sta _ResX

	lda AnglePV
	eor #$FF
	sec
	adc #$00
	cmp #$80
	ror
	clc
    adc #SCREEN_HEIGHT/2
	sta _ResY
#else
	;; lda AnglePH
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; clc
    ;; adc #120 ; 240/2 = WIDTH/2
	;; sta _ResX
debugici:
	// Extend AnglePH on 16 bits
	lda #$00
	sta _ResX+1
	lda AnglePH
	sta _ResX
	bpl angHpositiv
	lda #$FF
	sta _ResX+1
angHpositiv:
	// Invert AnglePH on 16 bits
	sec 
	lda #$00
	sbc _ResX
	sta _ResX
	lda #$00
	sbc _ResX+1
	sta _ResX+1
	// Multiply by 4
	asl _ResX
	rol _ResX+1
	asl _ResX
	rol _ResX+1
	// Add offset of screen center
	clc
	lda _ResX
	adc #120
	sta _ResX
	lda _ResX+1
	adc #$00
	sta _ResX+1
	
	;; lda AnglePV
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; adc #100 ; = 200 /2 SCREEN_HEIGHT/2
	;; sta _ResY
	
	// Extend AnglePV on 16 bits
	lda #$00
	sta _ResY+1
	lda AnglePV
	sta _ResY
	bpl angVpositiv
	lda #$FF
	sta _ResY+1
angVpositiv:
	// Invert AnglePV on 16 bits
	sec 
	lda #$00
	sbc _ResY
	sta _ResY
	lda #$00
	sbc _ResY+1
	sta _ResY+1
	// Multiply by 4
	asl _ResY
	rol _ResY+1
	asl _ResY
	rol _ResY+1
	// Add offset of screen center
	clc
	lda _ResY
	adc #100
	sta _ResY
	lda _ResY+1
	adc #$00
	sta _ResY+1

#endif


//  ; http://nparker.llx.com/a2/mult.html
//	// Quotient, Remainder = Quotient / Divisor
//	lda #0      ;Initialize _Remainder to 0
//	sta _Remainder
//	sta _Remainder+1
//	ldx #16     ;There are 16 bits in _Quotient
//L1  asl _Quotient    ;Shift hi bit of _Quotient into _Remainder
//	rol _Quotient+1  ;(vacating the lo bit, which will be used for the quotient)
//	rol _Remainder
//	rol _Remainder+1
//	lda _Remainder
//	sec         ;Trial subtraction
//	sbc _Divisor
//	tay
//	lda _Remainder+1
//	sbc _Divisor+1
//	bcc L2      ;Did subtraction succeed?
//	sta _Remainder+1   ;If yes, save it
//	sty _Remainder
//	inc _Quotient    ;and record a 1 in the quotient
//L2  dex
//	bne L1

prodone:
	// restore context
	pla:tay:pla:tax:pla
.)
	rts


.zero
pSeg .dsb 2

.text
idxPt1 .dsb 1
idxPt2 .dsb 1
//char2Display .dsb 1

//  void drawSegments(){
_drawSegments:
.(
	// save context
    pha:txa:pha:tya:pha
//  	unsigned char ii = 0;
//  	unsigned char idxPt1, idxPt2;
//  	for (ii = 0; ii< nbSegments; ii++){
    ;lda #<pSeg

    ldx _nbSegments
    beq drwsgdone
    dex

drwloop:
//  
//  		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
        txa ; ii
        asl
        asl ; ii * SIZEOF_SEGMENT
        sta pSeg
        lda #<_segments
        clc
        adc pSeg
        sta pSeg
        lda #>_segments
        adc #$00
        sta pSeg+1
        ldy #$00
        lda (pSeg),y
        sta idxPt1

//  		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
        iny
        lda (pSeg),y
        sta idxPt2
        
//  		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];
        iny
        lda (pSeg),y
        sta _char2Display
        
//          
//  		Point1X = points2d[idxPt1*SIZEOF_2DPOINT + 0];
        lda idxPt1  ; 
        asl         ; idxPt1 * SIZEOF_2DPOINT
        asl
        sta ptrpt2L
        lda #<_points2d
        clc
        adc ptrpt2L
        sta ptrpt2L
        lda #>_points2d
        adc #$00
        sta ptrpt2H

        ldy #$00
        lda (ptrpt2),y
        sta _Point1X
       
//  		Point1Y = points2d[idxPt1*SIZEOF_2DPOINT + 1];
        iny
        lda (ptrpt2),y
        sta _Point1Y
       
//  		Point2X = points2d[idxPt2*SIZEOF_2DPOINT + 0];
        lda idxPt2  ; 
        asl         ; idxPt2 * SIZEOF_2DPOINT
        asl
        sta ptrpt2L
        lda #<_points2d
        clc
        adc ptrpt2L
        sta ptrpt2L
        lda #>_points2d
        adc #$00
        sta ptrpt2H

        ldy #$00
        lda (ptrpt2),y
        sta _Point2X

//  		Point2Y = points2d[idxPt2*SIZEOF_2DPOINT + 1];
        iny
        lda (ptrpt2),y
        sta _Point2Y

//  		drawLine ();
        jsr _drawLine
//  	}
    dex
    txa
    cmp #$FF
    bne drwloop
drwsgdone
//  }
	// restore context
	pla:tay:pla:tax:pla
.)
    rts



//  void fastdrawSegments(){
_fastDrawSegments:
.(
	// save context
    pha:txa:pha:tya:pha


//  	unsigned char ii = 0;
//  	unsigned char idxPt1, idxPt2;
//  	for (ii = 0; ii< nbSegments; ii++){
    ;lda #<pSeg

    ldx _nbSegments
    beq drwsgdone
    dex

drwloop:
//  
//  		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
        txa ; ii
        asl
        asl ; ii * SIZEOF_SEGMENT
        sta pSeg
        lda #<_segments
        clc
        adc pSeg
        sta pSeg
        lda #>_segments
        adc #$00
        sta pSeg+1
        ldy #$00
        lda (pSeg),y
        sta idxPt1

//  		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
        iny
        lda (pSeg),y
        sta idxPt2
        
//  		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];
        iny
        lda (pSeg),y
        sta _char2Display
        
//          
//  		Point1X = points2d[idxPt1*SIZEOF_2DPOINT + 0];
        lda idxPt1  ; 
        asl         ; idxPt1 * SIZEOF_2DPOINT
        asl
        sta ptrpt2L
        lda #<_points2d
        clc
        adc ptrpt2L
        sta ptrpt2L
        lda #>_points2d
        adc #$00
        sta ptrpt2H

        ldy #$00
        lda (ptrpt2),y
        sta _Point1X
       
//  		Point1Y = points2d[idxPt1*SIZEOF_2DPOINT + 1];
        iny
        lda (ptrpt2),y
        sta _Point1Y
       
//  		Point2X = points2d[idxPt2*SIZEOF_2DPOINT + 0];
        lda idxPt2  ; 
        asl         ; idxPt1 * SIZEOF_2DPOINT
        asl
        sta ptrpt2L
        lda #<_points2d
        clc
        adc ptrpt2L
        sta ptrpt2L
        lda #>_points2d
        adc #$00
        sta ptrpt2H

        ldy #$00
        lda (ptrpt2),y
        sta _Point2X

//  		Point2Y = points2d[idxPt2*SIZEOF_2DPOINT + 1];
        iny
        lda (ptrpt2),y
        sta _Point2Y

//  		drawLine ();
        jsr _drawLine
//  	}
    dex
    bpl drwloop
drwsgdone
//  }
	// restore context
	pla:tay:pla:tax:pla
.)
    rts

// void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints){
	// int local_var;
	// for (local_var = 0; local_var< nbPoints; local_var++) {
		// tabpoint2D[local_var] = local_var;
	// }
	
// }
//    lda #>_points3d
//    sta ptrpt3H
//    lda #<_points3d  ;; TODO : use 0 instead if table is aligned on page
//    sta ptrpt3L
//    lda #<_points2d
//    sta ptrpt2L
//    lda #>_points2d
//    sta ptrpt2H
//
//    ldx _nbPoints
	
_glProject
.(
	ldx #6 : lda #3 : jsr enter :
	ldy #0 : lda (ap),y : sta reg0 : sta ptrpt2L : iny : lda (ap),y : sta reg0+1 : sta ptrpt2H :
	ldy #2 : lda (ap),y : sta reg0 : sta ptrpt3L : iny : lda (ap),y : sta reg0+1 : sta ptrpt3H :
	ldy #4 : lda (ap),y : sta tmp0 : sta _nbPoints ; iny : lda (ap),y : sta tmp0+1 :
	
	jsr _doFastProjection
//	lda tmp0 : sta reg1 :
//	lda #<(0) : sta reg2 : lda #>(0) : sta reg2+1 :
//	jmp Lmain405 :
//Lmain402
//	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
//	clc : lda tmp0 : adc reg0 : sta tmp1 : lda tmp0+1 : adc reg0+1 : sta tmp1+1 :
//	ldy #0 : lda tmp0 : sta (tmp1),y :
//
//	inc reg2 : .( : bne skip : inc reg2+1 :skip : .)  :
//Lmain405
//	lda reg1 : sta tmp0 : lda #0 : sta tmp0+1 :
//	lda reg2 : cmp tmp0 : lda reg2+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp Lmain402 :skip : .) : :
	jmp leave :
.)