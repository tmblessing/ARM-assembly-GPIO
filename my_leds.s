    AREA asm_demo, CODE, READONLY
    EXPORT my_leds
my_leds
    PUSH {R1, R2, R3, R4, LR}       ;Clear regs
    
    LDR R1, =0x2009C020             ;mask port address
    LDR R2, =0xB40000               ;1s on the pins for the LEDs
    STR R2, [R1, #0x1C]             ;Clears LEDs
    
    AND R4, R0, #8                  ;Transforming input from C
    AND R3, R3, #0                  ;This line makes sure R3 is clear
    ORR R3, R4                      ;Places left bit on mask
    LSL R3, R3, #1                  ;Moves mask left 1 bit
    AND R4, R0, #6                  ;Isolates middle two bits onto R4
    ORR R3, R4                      ;Adds these onto mask containing first bit
    LSL R3, R3, #1                  ;Shifts mask 1 bit, again
    AND R4, R0, #1                  ;Isolates rightmost bit
    ORR R3, R4                      ;Places it onto mask
    LSL R3, R3, #18                 ;Shifts mask 18 bits left, so it lines up with LED pins

    STR R3, [R1, #0x18]             ;Stores mask into FIOSET register, ativating LEDs
    
    BL wait                         ; Call to wait
    POP {R1, R2, R3, R4, LR}        ; Clear regs
    BX LR
    ALIGN                           ; End of my_leds function
wait                                ; Start of wait subroutine
    PUSH {R1, R2}
    MOV.W R1, #1                    ;int i = 1
    MOV.W R2, #0x1000000            ;Set limit to a very high number
loop_entry
    CMP R1, R2                      ;R4 - R5 (i - limit)
    BGT loop_exit                   ;if R1 is greater than R2 exit
                                    ;loop body goes here
    ADD R1, R1, #1 ;i++
    B loop_entry ;Return
loop_exit
    POP {R1, R2}
    BX LR                           ; Return from wait
    ALIGN
    END    