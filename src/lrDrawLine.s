
#define OPCODE_DEC_ZERO $C6
#define OPCODE_INC_ZERO $E6

#ifdef USE_ASM_DRAWLINE

_lrDrawLine:
.(

#ifdef SAFE_CONTEXT
	// save context
    pha
	lda reg4:pha

#endif // SAFE_CONTEXT

//     A1X     = P1X;
	lda 	_P1X
	sta		_A1X
//     A1Y     = P1Y;
	lda 	_P1Y
	sta		_A1Y
//     A1destX = P2X;
	lda 	_P2X
	sta		_A1destX
//     A1destY = P2Y;
	lda 	_P2Y
	sta		_A1destY
//     A1dX    = abs(P2X - P1X);
//     A1sX    = P1X < P2X ? 1 : -1;
; a = P1X-P2X
    sec
    lda _P1X
    sbc _P2X
; if a >= 0 :
    bmi lrDrawLine_p2xoverp1x
;   dx = a
    sta _A1dX
;   sx = -1
    lda #$FF
    sta _A1sX
    lda #OPCODE_DEC_ZERO
    sta patch_lrDrawLine_incdec_A1X
    jmp lrDrawLine_computeDy
; else
lrDrawLine_p2xoverp1x:
;   dx = -a
    eor #$FF
    sec
    adc #$00
    sta _A1dX
;   sx =1
    lda #$01
    sta _A1sX
    lda #OPCODE_INC_ZERO
    sta patch_lrDrawLine_incdec_A1X
; endif


lrDrawLine_computeDy:
//     A1dY    = -abs(P2Y - P1Y);
//     A1sY    = P1Y < P2Y ? 1 : -1;
; a = P1Y-P2Y
    lda _P1Y
    sec
    sbc _P2Y
; if a >= 0 :
    bmi lrDrawLine_p2yoverp1y
;   dy = -a
    eor #$FF
    sec
    adc #$00
    sta _A1dY
;   sy = -1
    lda #$FF
    sta _A1sY
    lda #OPCODE_DEC_ZERO
    sta patch_lrDrawLine_incdec_A1Y
    jmp lrDrawLine_computeErr
; else
lrDrawLine_p2yoverp1y:
;   dy = a
    sta _A1dY
;   sy = 1
    lda #$01
    sta _A1sY
    lda #OPCODE_INC_ZERO
    sta patch_lrDrawLine_incdec_A1Y
; endif


lrDrawLine_computeErr:
//     A1err   = A1dX + A1dY;
; a = A1dX
    lda		_A1dX
; a = a + dy
    clc
    adc		_A1dY
; err = a
    sta		_A1err

//     if ((A1err > 64) || (A1err < -63)) return;
    sec
    sbc #$40
    bvc *+4
    eor #$80
    bmi lrDrawLine_goon01
	jmp lrDrawLine_endloop
lrDrawLine_goon01:
    lda _A1err
    sec
    sbc #$C0
    bvc *+4
    eor #$80
    bpl lrDrawLine_goon02:
	jmp lrDrawLine_endloop
lrDrawLine_goon02:

//     if ((ch2disp == '/') && (A1sX == -1)) {
//         ch2dsp = DOLLAR;
//     } else {
//         ch2dsp = ch2disp;
//     }
	lda _ch2disp 
	cmp #47
	bne lrDrawLine_loop
	lda _A1sX
	cmp #$FF
	bne  lrDrawLine_loop
	lda #DOLLAR
	sta _ch2disp 

//     while (1) {  // loop
lrDrawLine_loop:

//         //printf ("plot [%d, %d] %d %d\n", _A1X, _A1Y, distseg, ch2disp);get ();          


// #ifdef USE_ZBUFFER
//         zplot(A1X, A1Y, distseg, ch2dsp);
// #else
//         // TODO : plot a point with no z-buffer
// #endif
#ifdef USE_ZBUFFER
			
		lda _A1X : sta _plotX :
		lda _A1Y : sta _plotY :
		lda _distseg: sta _distpoint:
		jsr _fastzplot
#else
		lda _A1X : sta _plotX :
		lda _A1Y : sta _plotY :
		jsr _asmplot
#endif

//         if ((A1X == A1destX) && (A1Y == A1destY)) break;
;       a = A1X
        lda _A1X
;       if a != A1destX goto continue
        cmp _A1destX
        bne lrDrawLine_continue
;       a = A1Y
        lda _A1Y
;       if a != A1destY goto continue
        cmp _A1destY
        bne lrDrawLine_continue
;       goto endloop
        jmp lrDrawLine_endloop
;continue:
lrDrawLine_continue:

//      e2 = 2*A1err;
//         e2 = (A1err < 0) ? (
//                 ((A1err & 0x40) == 0) ? (
//                                                 0x80)
//                                         : (
//                                             A1err << 1))
//             : (
//                 ((A1err & 0x40) != 0) ? (
//                                                 0x7F)
//                                         : (
//                                                 A1err << 1));
		lda _A1err
		bpl lrDrawLine_errpositiv_01
		asl
		bmi lrDrawLine_errdone_01
		lda #$80
		jmp lrDrawLine_errdone_01
	
lrDrawLine_errpositiv_01:	
		asl
		bpl lrDrawLine_errdone_01
		lda #$7F
lrDrawLine_errdone_01:	
		sta reg4

//         if (e2 >= A1dY) {
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
        bmi lrDrawLine_dyovera

//             A1err += A1dY;  // e_xy+e_x > 0
			lda _A1err
			clc
			adc _A1dY
			sta _A1err
//             A1X += A1sX;
patch_lrDrawLine_incdec_A1X:
            inc _A1X
			; lda _A1X
			; clc
			; adc _A1sX
			; sta _A1X
lrDrawLine_dyovera:
//         }
//         if (e2 <= A1dX) {  // e_xy+e_y < 0
		lda _A1dX
		sec
		sbc reg4
		bvc *+4
		eor #$80
		bmi lrDrawLine_e2overdx
//             A1err += A1dX;
			lda _A1err
			clc
			adc _A1dX
			sta _A1err
//             A1Y += A1sY;
patch_lrDrawLine_incdec_A1Y:
            inc _A1Y
			; lda _A1Y
			; clc
			; adc _A1sY
			; sta _A1Y
lrDrawLine_e2overdx
//         }
	jmp lrDrawLine_loop
//     }


lrDrawLine_endloop:
lrDrawLine_done:

#ifdef SAFE_CONTEXT
	// restore context
	pla: sta reg4
	pla
#endif // SAFE_CONTEXT


.)
	rts
#endif // USE_ASM_DRAWLINE