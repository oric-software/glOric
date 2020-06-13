#ifdef USE_ASM_REACHSCREEN
;; void reachScreen()
_reachScreen:
.(
	jmp reachScreen_Lbresfill130 :
reachScreen_Lbresfill129
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
reachScreen_Lbresfill130
    lda _A1arrived
    bne reachScreen_done
    lda _A1Y : sec:
#ifdef USE_COLOR
    sbc #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
    sbc #SCREEN_HEIGHT
#endif 
    .(:bvc skip : eor #$80: skip:.)
    bmi *+5 : jmp reachScreen_Lbresfill129
reachScreen_done
.)
	rts
#endif ;; USE_ASM_REACHSCREEN
