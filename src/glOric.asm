.include "config.inc"

.import popax
.import popa


ptrpt3:				.word 0
ptrpt2:				.word 0
nbPoints:			.byte 0
opts:				.byte 0

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

    rts
.endproc

.export _une_fonction
 
.proc _une_fonction
	lda #SCREEN_WIDTH
    rts
.endproc

