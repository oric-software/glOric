#ifdef USE_ASM_HFILL


// void hfill() {
_hfill:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_HFILL)
; #endif
	// save context
    pha:txa:pha:tya:pha
	lda reg0: pha ;; p1x 
    lda reg1: pha ;; p2x
	lda reg2: pha ;; pY
    lda reg3: pha ;; dist
    lda reg4: pha ;; char2disp
	lda tmp0: pha ;; dx
	lda tmp1: pha ;; fx
	lda tmp2: pha ;; nbpoints
	lda tmp3: pha: lda tmp3+1: pha  ;; save stack pointer

//     signed char dx, fx;
//     signed char nbpoints;

//     //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();

//     if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT)) return;
	lda _A1Y				; Access Y coordinate
    bpl *+5
    jmp hfill_done
#ifdef USE_COLOR
    cmp #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
    cmp #SCREEN_HEIGHT
#endif
    bcc *+5
	jmp hfill_done
    sta reg2 ; A1Y

//     if (A1X > A2X) {
	lda _A1X				
	sta reg0
	sec
	sbc _A2X				; signed cmp to p2x
	bvc *+4
	eor #$80
	bmi hfill_A2xOverOrEqualA1x
#ifdef USE_COLOR
//		dx = max(2, A2X);
		lda _A2X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A2xLowerThan3
		lda _A2X
		jmp hfill_A2xPositiv
hfill_A2xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A2X);
		lda _A2X
		bpl hfill_A2xPositiv
		lda #0
#endif
hfill_A2xPositiv:
		sta tmp0 ; dx
//         fx = min(A1X, SCREEN_WIDTH - 1);
		lda _A1X
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hfill_A1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A1xOverScreenWidth:
		jmp hfill_computeNbPoints
hfill_A2xOverOrEqualA1x:
//     } else {
#ifdef USE_COLOR
//		dx = max(2, A1X);
		lda _A1X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A1xLowerThan3
		lda _A1X
		jmp hfill_A1xPositiv
hfill_A1xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A1X);
		lda _A1X
		bpl hfill_A1xPositiv
		lda #0
#endif
hfill_A1xPositiv:
		sta tmp0
//         fx = min(A2X, SCREEN_WIDTH - 1);
		lda _A2X ; p2x
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hfill_A2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A2xOverScreenWidth:
//     }
hfill_computeNbPoints:
//     nbpoints = fx - dx;
//     if (nbpoints < 0) return;
	sec
	lda tmp1
	sbc tmp0
	bmi hfill_done
	sta tmp2

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, A1Y, nbpoints, distface, ch2disp);
	clc
	lda sp
	sta tmp3
	adc #10
	sta sp
	lda sp+1
	sta tmp3+1
	adc #0
	sta sp+1
	lda tmp0 : ldy #0 : sta (sp),y ;; dx
	lda reg2 : ldy #2 : sta (sp),y ;; py
	lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	lda _distface : ldy #6 : sta (sp),y ;; dist
	lda _ch2disp : ldy #8 : sta (sp),y ;; char2disp
	ldy #10 : jsr _zline
	lda tmp3
	sta sp
	lda tmp3+1
	sta sp+1
// #else
//     // TODO : draw a line whit no z-buffer
// #endif
hfill_done:
	// restore context
	pla: sta tmp3+1
	pla: sta tmp3
	pla: sta tmp2
	pla: sta tmp1
	pla: sta tmp0
    pla: sta reg4
	pla: sta reg3
    pla: sta reg2
	pla: sta reg1
    pla: sta reg0
	pla:tay:pla:tax:pla
// }
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_HFILL)
; #endif
.)
	rts

#endif // USE_ASM_HFILL
