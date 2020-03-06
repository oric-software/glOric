
#include "config.h"

#define        via_portb               $0300 
#define		   via_ddrb				   $0302	
#define		   via_ddra				   $0303
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 

.zero
zpTemp01			.byt 0
zpTemp02			.byt 0

.text 
#define IRQ_ADDRLO $0245
#define IRQ_ADDRHI $0246

#undef TRANSPARENT_KEYBOARD

tab_ascii
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",59,"-",0,0,92,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,"]","["
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"="

#ifdef USE_RT_KEYBOARD
; The virtual Key Matrix
_KeyBank .dsb 8
_oldKeyBank .dsb 8
#endif // USE_RT_KEYBOARD


irq_handler:

	pha
	txa
	pha
	tya
	pha

	; This handler runs at 100hz 
#ifdef USE_RT_KEYBOARD

	; jsr _task_100Hz ;; FIXME !! Why does this line prevent COLORDEMO from compiling ?

	
#ifndef TRANSPARENT_KEYBOARD
    ;Clear IRQ event
	lda via_t1cl 
#endif TRANSPARENT_KEYBOARD

	jsr ReadKeyboard 
#endif // USE_RT_KEYBOARD

	pla
	tay
	pla
	tax
	pla

#ifndef TRANSPARENT_KEYBOARD
    jmp leave_interrupt
#endif TRANSPARENT_KEYBOARD
jmp_old_handler
 	jmp 0000
leave_interrupt:
    rti



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
    
    
#ifdef USE_RT_KEYBOARD

old_via_ddra .dsb 1
old_via_ddrb .dsb 1 
old_via_acr  .dsb 1   
old_via_t1ll .dsb 1
old_via_t1lh .dsb 1 
    
_kernelExit:
.(
    ; Restore VIA config
    lda old_via_ddra : sta via_ddra
    lda old_via_ddrb : sta via_ddrb
    lda old_via_acr  : sta via_acr 
    lda old_via_t1ll : sta via_t1ll
    lda old_via_t1lh : sta via_t1lh

	; Restore old handler value
	lda jmp_old_handler+1
	sta IRQ_ADDRLO
	lda jmp_old_handler+2
	sta IRQ_ADDRHI

.)
    rts

_kernelInit:
.(
#ifdef TRANSPARENT_KEYBOARD
	; Save the old handler value
	lda IRQ_ADDRLO
	sta jmp_old_handler+1
	lda IRQ_ADDRHI
	sta jmp_old_handler+2
#endif TRANSPARENT_KEYBOARD

	;Since we are starting from when the standard irq has already been 
	;setup, we need not worry about ensuring one irq event and/or right 
	;timer period, only redirecting irq vector to our own irq handler. 
	sei


    lda via_ddra: sta old_via_ddra
    lda via_ddrb: sta old_via_ddrb
    lda via_acr: sta old_via_acr 
    lda via_t1ll: sta old_via_t1ll
    lda via_t1lh: sta old_via_t1lh


	; Setup DDRA, DDRB and ACR
	lda #%11111111
	sta via_ddra
	lda #%11110111 ; PB0-2 outputs, PB3 input.
	sta via_ddrb
	lda #%1000000
	sta via_acr

	; Since this is an slow process, we set the VIA timer to 
	; issue interrupts at 25Hz, instead of 100 Hz. This is 
	; not necessary -- it depends on your needs
	lda #<40000
	sta via_t1ll 
	lda #>40000
	sta via_t1lh
	

	; Install our own handler
	lda #<irq_handler
	sta IRQ_ADDRLO
	lda #>irq_handler
	sta IRQ_ADDRHI
	cli 
    
.)
    rts




ReadKeyboard
.(
        ;Write Column Register Number to PortA 
        lda #$0E 
        sta via_porta 

        ;Tell AY this is Register Number 
        lda #$FF 
        sta via_pcr 

		; Clear CB2, as keeping it high hangs on some orics.
		; Pitty, as all this code could be run only once, otherwise
        ldy #$dd 
        sty via_pcr 

        ldx #7 

loop2   ;Clear relevant bank 
        lda #00 
        sta _KeyBank,x 

        ;Write 0 to Column Register 

		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        lda #$dd
        sta via_pcr


        lda via_portb 
        and #%11111000
        stx zpTemp02
        ora zpTemp02 
        sta via_portb 

        
        ;Wait 10 cycles for circuit to settle on new row 
        ;Use time to load inner loop counter and load Bit 

		; CHEMA: Fabrice Broche uses 4 cycles (lda #8:inx) plus
		; the four cycles of the and absolute. That is 8 cycles.
		; So I guess that I could do the same here (ldy,lda)

        ldy #$80
        lda #8 

        ;Sense Row activity 
        and via_portb 
        beq skip2 

        ;Store Column 
        tya
loop1   
        eor #$FF 

		sta via_porta 
	    lda #$fd 
	    sta via_pcr 
        lda #$dd
        sta via_pcr

        lda via_portb 
        and #%11111000
        stx zpTemp02
        ora zpTemp02 
        sta via_portb 


        ;Use delay(10 cycles) for setting up bit in _KeyBank and loading Bit 
        tya 
        ora _KeyBank,x 
        sta zpTemp01 
        lda #8 

        ;Sense key activity 
        and via_portb 
        beq skip1 

        ;Store key 
        lda zpTemp01 
        sta _KeyBank,x 

skip1   ;Proceed to next column 
        tya 
        lsr 
        tay 
        bcc loop1 

skip2   ;Proceed to next row 
        dex 
        bpl loop2 

		;jsr _keyEvent
        rts 
.)  

#endif // USE_RT_KEYBOARD