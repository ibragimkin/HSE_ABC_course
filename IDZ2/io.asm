.data
    msg_input: .asciz "\nEnter x (as a floating-point number), where x is not equal to zero:\n"  # Prompt message
    msg_badinput: .asciz "Invalid input, x cannot be zero. Try again.\n"                       # Error message

.text 

# Macro to print a message stored in the data section
.macro PRINT_MSG(%msg)
    la a0, %msg       # Load the address of the message string into register a0
    li a7, 4          # Syscall code for printing a string
    ecall             # Make syscall to print the message
.end_macro

# Macro to print a custom string
.macro PRINT_STRING(%msg)
    .data 
        msg: .asciz %msg   # Store the custom string as an ASCII zero-terminated string
    .text 
        PRINT_MSG(msg)     # Use the PRINT_MSG macro to print the custom string
.end_macro 

# Macro to read a floating-point number from user input into a specified floating-point register
.macro READ_FLOAT(%freg)
    start:
        PRINT_MSG(msg_input)   # Print the input prompt message
        li a7, 6               # Syscall code for reading a float
        ecall                  # Make syscall to read a float
        fmv.s %freg, fa0       # Move the read float from fa0 to the specified register %freg

        # Check if the input is zero
        LAB_TO_REG(ft1, const_zero)  # Load constant zero into ft1
        feq.s t0, %freg, ft1         # Set t0 to 1 if %freg == 0, else 0
        li t1, 1
        beq t0, t1, error_processing # If the input is zero, branch to error handling

        j end                        # If the input is non-zero, proceed to end

    error_processing:
        PRINT_MSG(msg_badinput)      # Print the error message
        j start                      # Retry reading the input

    end:
.end_macro

# Macro to write (print) a floating-point number stored in a specified floating-point register
.macro WRITE_FLOAT(%freg)
    fmv.s fa0, %freg   # Move the floating-point value from %freg to fa0 for syscall
    li a7, 2           # Syscall code for printing a float
    ecall              # Make syscall to print the float
.end_macro
