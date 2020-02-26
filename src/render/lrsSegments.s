


.zero
pSeg .dsb 2

.text
idxPt1 .dsb 1
idxPt2 .dsb 1
//_char2Display .dsb 1

_Point1X .dsb 1
_Point1Y .dsb 1
_Point2X .dsb 1
_Point2Y .dsb 1
_char2Display .dsb 1


#ifdef  TEXTDEMO
#ifndef USE_REWORKED_BUFFERS

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

#endif // undef USE_REWORKED_BUFFERS

#endif // TEXTDEMO





/*
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
*/
