#ifdef USE_ASM_GLDRAWPARTICULES
// void glDrawParticules(){
_glDrawParticules:
.(
//     unsigned char ii = 0;
#ifdef SAFE_CONTEXT
    lda reg5 : pha 
#endif // SAFE_CONTEXT

    ldy _nbParticules
    jmp glDrawParticules_nextParticule
//     for (ii = 0; ii < nbParticules; ii++) {

glDrawParticules_loop:

//         idxPt1    = particulesPt[ii];  // ii*SIZEOF_SEGMENT +0
        lda _particulesPt,y : sta _idxPt1
//         ch2disp = particulesChar[ii];    // ii*SIZEOF_SEGMENT +2
        lda _particulesChar,y : sta _ch2disp

        sty reg5 : ldy _idxPt1
//         dchar = points2dL[idxPt]-2 ; //FIXME : -2 to helps particule to be displayed
        lda _points2dL,y : sta _distpoint

//         P1X = (SCREEN_WIDTH -points2aH[idxPt]) >> 1;
        sec : lda #SCREEN_WIDTH : sbc _points2aH,y : cmp #$80 : ror
        sta _plotX
        
//         P1Y = (SCREEN_HEIGHT - points2aV[idxPt]) >> 1;
        sec : lda #SCREEN_HEIGHT : sbc _points2aV,y : cmp #$80 : ror
        sta _plotY

#ifdef USE_ZBUFFER
//         zplot(P1X, P1Y, dchar, ch2disp);
        jsr _fastzplot
#else
//         // TODO : plot a point with no z-buffer
//         plot(A1X, A1Y, ch2disp);
#endif
        ldy reg5
glDrawParticules_nextParticule:
	dey 
    bmi glDrawParticules_done
	jmp glDrawParticules_loop
//     }

glDrawParticules_done:

#ifdef SAFE_CONTEXT
	// Restore context
	pla : sta reg5
#endif // SAFE_CONTEXT
// }
.)
    rts
#endif // USE_ASM_GLDRAWPARTICULES
