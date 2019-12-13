
irq_handler:

	pha
	txa
	pha
	tya
	pha

	; This handler runs at 100hz 

	;jsr _MyRoutine

	pla
	tay
	pla
	tax
	pla

jmp_old_handler
	jmp 0000



_enterSC:
.(
    pha
    lda #64
    sta $030E
    pla
.)
    rts
    
_leaveSC:
.(
    pha
    lda #192
    sta $030E
    pla
.)
    rts
    
    
    
_kernelInit:
.(
	; Save the old handler value
	lda $245
	sta jmp_old_handler+1
	lda $246
	sta jmp_old_handler+2

	; Install our own handler
	lda #<irq_handler
	sta $245
	lda #>irq_handler
	sta $246
    
.)
    rts
