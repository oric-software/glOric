
#ifdef USE_ASM_ANGLE2SCREEN


// void angle2screen() {
_angle2screen:
.(

#ifdef SAFE_CONTEXT
	// save context
    pha
#endif // SAFE_CONTEXT
// FIXME : deal with case of overflow
//     P1X = (SCREEN_WIDTH - P1AH) >> 1;
sec : lda #SCREEN_WIDTH : sbc _P1AH : cmp #$80: ror : sta _P1X
//     P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
sec : lda #SCREEN_HEIGHT : sbc _P1AV : cmp #$80: ror : sta _P1Y
//     P2X = (SCREEN_WIDTH - P2AH) >> 1;
sec : lda #SCREEN_WIDTH : sbc _P2AH : cmp #$80: ror : sta _P2X
//     P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
sec : lda #SCREEN_HEIGHT : sbc _P2AV : cmp #$80: ror : sta _P2Y
//     P3X = (SCREEN_WIDTH - P3AH) >> 1;
sec : lda #SCREEN_WIDTH : sbc _P3AH : cmp #$80: ror : sta _P3X
//     P3Y = (SCREEN_HEIGHT - P3AV) >> 1;
sec : lda #SCREEN_HEIGHT : sbc _P3AV : cmp #$80: ror : sta _P3Y


#ifdef SAFE_CONTEXT
	// restore context
	pla
#endif // SAFE_CONTEXT
// }
.)
	rts

#endif // USE_ASM_ANGLE2SCREEN
