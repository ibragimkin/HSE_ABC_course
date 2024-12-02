.include "macros.asm"
.include "io.asm"
.data
	msg_result: .asciz "The value of cth(x) is: "
	msg_restart: .asciz "\nRestart the program? Enter\n0 - NO\nAny other number - YES\n"
.text
.globl main

main:
    READ_FLOAT(ft0)
    CTH_X(ft0, ft3)
    PRINT_MSG(msg_result)
    WRITE_FLOAT(ft3)
	PRINT_MSG(msg_restart) 
    li a7, 5
    ecall 
    beqz a0, end   # Check if the user wants to restart
    j main
end: # Terminate program
    li a7, 10
    ecall
