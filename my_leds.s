    AREA asm_demo, CODE, READONLY
    EXPORT my_leds
my_leds ;Takes given number in R0 and displays it on LPC1768's onboard LEDs
    PUSH {R1, R2, R3, R4, LR}       ;Save registers
    
    LDR R1, =0x2009C020             ;Address of GPIO registers for port 1
    LDR R2, =0xB40000               ;1's on bits 23, 21, 20, and 18, which corresponds to the pins that the LEDs are on
    STR R2, [R1, #0x1C]             ;Stores R2 in the FIOCLR register of port 1, clearing the LEDs
    
    ;Transforming input from C into pattern that matches pin locations for the onboard LEDs
    ;LEDs are on pins 23, 21, 20, and 18
    ;For example: 0000000000000000000000000001111 needs to be changed to 0000000010110100000000000000000
    
    AND R4, R0, #8                  ;Take just leftmost bit of given number
    AND R3, R3, #0                  ;Clear R3, we will use it to make our bit mask
    ORR R3, R4                      ;Place the taken bit into our mask
    LSL R3, R3, #1                  ;Moves mask left 1 bit
    AND R4, R0, #6                  ;Isolates middle two bits of given number onto R4
    ORR R3, R4                      ;Places these on our mask
    LSL R3, R3, #1                  ;Shifts mask 1 bit, again
    AND R4, R0, #1                  ;Isolates rightmost bit
    ORR R3, R4                      ;Places it onto mask
    LSL R3, R3, #18                 ;Shifts mask 18 bits left, so it lines up with LED pins

    STR R3, [R1, #0x18]             ;Stores mask into FIOSET register, ativating LEDs
    
    BL wait                         ;Call to wait
    POP {R1, R2, R3, R4, LR}        ;Restore registers
    BX LR
    ALIGN                           ;End of function
    
wait                                ;Start of wait subroutine
    PUSH {R1, R2}                   ;Store registers
    MOV.W R1, #1                    ;We are going to use this as the counting variable of our loop, initalize it at 1
    MOV.W R2, #0x1000000            ;This will be the limit for our loop
loop_entry
    CMP R1, R2                      ;Compare R1 and R2
    BGT loop_exit                   ;if R1 is greater than R2, jump to loop_exit
                                    
    ADD R1, R1, #1 ;i++             ;Increment R1 by 1
    B loop_entry                    ;Jump back to start of loop
loop_exit
    POP {R1, R2}                    ;Restore registers
    BX LR                           ;Return from wait
    ALIGN
    END    
