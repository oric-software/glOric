#ifdef USE_ASM_FILLFACE
;; void fillFace()
_fillFace:
.(
	ldy #0 : jsr _angle2screen :
	ldy #0 : jsr _fill8 :
.)
	rts
#endif // USE_ASM_FILLFACE

