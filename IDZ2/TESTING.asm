.include "macros.asm"
.include "io.asm"

# Macro for printing the result with given x1, y1, and message
.macro PRINT_RESULT(%x1, %y1, %real_res, %msg)
    WRITE_FLOAT(%x1)            # Print the floating-point value of x1
    PRINT_STRING(" , ")         # Print a comma separator
    WRITE_FLOAT(%y1)            # Print the floating-point value of y1
    PRINT_STRING(" - ")         # Print a hyphen separator
    PRINT_STRING(%msg)          # Print the result message ("TRUE" or "FALSE")
    PRINT_STRING(" , CTH(X) = ")
    WRITE_FLOAT(%real_res)
    PRINT_STRING("\n")
.end_macro 

# Macro to test if coth(x1) is approximately equal to y1 within a precision range
.macro test(%x1, %y1)
    .data
        x1t: .float %x1          # Define x1 as a floating-point constant in memory
        y1t: .float %y1          # Define y1 as a floating-point constant in memory
        precision: .float 0.001  # Set the precision level to 0.001 (0.1%)
    .text 
        LAB_TO_REG(ft0, x1t)     # Load x1 into ft0
        CTH_X(ft0, ft3)          # Compute coth(x1) and store the result in ft3
        LAB_TO_REG(ft1, y1t)     # Load y1 into ft1
        LAB_TO_REG(ft6, precision) # Load the precision value into ft6

        # Compute the range for comparison: (y1 - precision * y1) and (y1 + precision * y1)
        fmul.s ft6, ft6, ft1     # ft6 = precision * y1
        fsub.s ft7, ft1, ft6     # ft7 = y1 - (precision * y1) -> lower bound
        fadd.s ft8, ft1, ft6     # ft8 = y1 + (precision * y1) -> upper bound

        # Check if coth(x1) (stored in ft3) falls within the range [ft7, ft8]
        flt.s t0, ft7, ft3       # t0 = (ft7 < ft3)
        flt.s t1, ft3, ft8       # t1 = (ft3 < ft8)
        and t2, t0, t1           # t2 = t0 & t1; t2 is true if ft7 < ft3 < ft8

        # Print the result based on the comparison outcome
        beqz t2, false           # If t2 is false, branch to "false" label

        # If the value is within range, print "TRUE"
        PRINT_RESULT(ft0, ft1, ft3, "TRUE")
        j end                    # Jump to the end of the test macro
    false:
        PRINT_RESULT(ft0, ft1, ft3, "FALSE") # If the value is out of range, print "FALSE"

    end:
.end_macro

main:
    test(2.0, 1.5)  # false, CTH(2.0) = 1.0373147
	test(1.0, 1.313035)  # true, CTH(1.0) = 1.3130353
	test(0.5, 2.1639534)  # true, CTH(0.5) = 2.1639534
	test(0.1, 10.016686)  # true, CTH(0.1) = 10.0166861
	test(1.5, 1.0)  # false, CTH(1.5) = 1.0709148
	test(3.0, 1.0049698)  # true, CTH(3.0) = 1.0049698
	test(3.0, 1.1)  # false, CTH(3.0) = 1.0049698
	test(4.0, 1.0003354)  # true, CTH(4.0) = 1.0003354
	test(0.2, 5.033489)  # true, CTH(0.2) = 5.0334895
	test(0.2, 5.5)  # false, CTH(0.2) = 5.0334895

