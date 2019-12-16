; http://miniserve.defence-force.org/svn/public/oric/routines/rasterization/linebench/
#include "config.h"
#define ROW_SIZE    SCREEN_WIDTH/6

    .dsb 256-(*&255)

_HiresAddrLow           .dsb SCREEN_HEIGHT

    .dsb 256-(*&255)

_HiresAddrHigh          .dsb SCREEN_HEIGHT

    .dsb 256-(*&255)

    .byt 0
_TableDiv6              .dsb SCREEN_WIDTH

    .dsb 256-(*&255)

    .byt 0
_TableBit6Reverse
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .dsb 256-(*&255)

    .byt 0
_TableBit6
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80


_GenerateTables
.(

    ; Generate screen offset data
.(
    lda #<$a000
    sta tmp0+0
    lda #>$a000
    sta tmp0+1

    ldx #0
loop
    ; generate two bytes screen adress
    clc
    lda tmp0+0
    sta _HiresAddrLow,x
    adc #ROW_SIZE
    sta tmp0+0
    lda tmp0+1
    sta _HiresAddrHigh,x
    adc #0
    sta tmp0+1

    inx
    cpx #SCREEN_HEIGHT
    bne loop
.)


    ; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6,x
    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    cpx #SCREEN_WIDTH
    bne loop
.)
.)
    rts







