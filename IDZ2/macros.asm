.data
    const_zero: .float 0.0           # Constant zero
    const_one: .float 1.0            # Constant one
    term: .float 1.0                 # Initial term for series
    exp_x: .float 1.0                # Sum for e^x calculation
    precisionn: .float 0.000001       # Precision (0.001% or 0.00001)

.text 

# Macro to load the address of a label into a register and then load the float value at that address
.macro LAB_TO_REG(%reg, %lab)
    la a0, %lab          # Load address of label %lab into a0
    flw %reg, 0(a0)      # Load the float value from memory into register %reg
.end_macro 

# Macro to calculate the exponential function e^x using a series expansion
.macro EXP(%x, %res)
    # Save used floating-point registers on the stack
    addi sp, sp, -28            # Allocate space on the stack for 7 registers (7 * 4 bytes)
    fsw ft1, 0(sp)              # Save ft1
    fsw ft3, 4(sp)              # Save ft3
    fsw ft4, 8(sp)              # Save ft4
    fsw ft5, 12(sp)             # Save ft5
    fsw ft6, 16(sp)             # Save ft6
    fsw ft7, 20(sp)             # Save ft7

    # Use temporary registers for %x and %res
    fmv.s ft7, %x               # Save %x to temporary register ft7 (ft_temp_x)
    fmv.s ft8, %res             # Save %res to temporary register ft8 (ft_temp_res)

    # Load constants and initialize variables for the series
    LAB_TO_REG(ft1, term)       # Load initial term (1.0) into ft1
    LAB_TO_REG(ft8, exp_x)      # Initialize ft8 (temp for %res) with exp_x (1.0)
    LAB_TO_REG(ft3, precisionn) # Load precision value into ft3
    LAB_TO_REG(ft4, const_one)  # Set initial n = 1.0 in ft4
    LAB_TO_REG(ft5, const_one)  # Constant value 1.0 in ft5

loop_start:
    # Calculate the next term in the series: term = term * x / n
    fmul.s ft1, ft1, ft7        # term *= %x (using ft_temp_x)
    fdiv.s ft1, ft1, ft4        # term /= n

    # Add the term to the current sum for e^x
    fadd.s ft8, ft8, ft1        # ft8 (temp for %res) += term

    # Increment n for the next term
    fadd.s ft4, ft4, ft5        # n += 1.0

    # Check if the absolute value of the term is below the precision threshold
    fabs.s ft6, ft1             # Get the absolute value of the term in ft6
    flt.s t0, ft6, ft3          # t0 = (abs(term) < precision)
    beqz t0, loop_start         # If abs(term) >= precision, continue loop

    # Restore %res from the temporary register
    fmv.s %res, ft8             # Copy result from ft8 (temp for %res) back to %res

    # Restore the saved floating-point registers from the stack
    flw ft1, 0(sp)              # Restore ft1
    flw ft3, 4(sp)              # Restore ft3
    flw ft4, 8(sp)              # Restore ft4
    flw ft5, 12(sp)             # Restore ft5
    flw ft6, 16(sp)             # Restore ft6
    flw ft7, 20(sp)             # Restore ft7
    addi sp, sp, 28             # Deallocate stack space

.end_macro 

# Macro to calculate the hyperbolic cotangent coth(x) using exp(x) and its inverse
.macro CTH_X(%x, %res)
    # Save used floating-point registers on the stack
    addi sp, sp, -16            # Allocate space on the stack for 4 registers (4 * 4 bytes)
    fsw ft1, 0(sp)              # Save ft1
    fsw ft2, 4(sp)              # Save ft2
    fsw ft4, 8(sp)              # Save ft4
    fsw ft5, 12(sp)             # Save ft5

    # Use temporary registers for %x and %res
    fmv.s ft7, %x               # Save %x to temporary register ft7 (ft_temp_x)
    fmv.s ft8, %res             # Save %res to temporary register ft8 (ft_temp_res)

    # Calculate exp(x) and store in ft2
    EXP(ft7, ft2)               # Call EXP macro with temporary register ft7 for %x

    # Load the constant 1.0 to calculate the inverse
    LAB_TO_REG(ft5, const_one)  # Load 1.0 into ft5

    # Calculate 1 / exp(x)
    fdiv.s ft1, ft5, ft2        # ft1 = 1 / exp(x)

    # Calculate coth(x) = (exp(x) + 1/exp(x)) / (exp(x) - 1/exp(x))
    fadd.s ft8, ft1, ft2        # ft8 (temp for %res) = exp(x) + 1/exp(x)
    fsub.s ft4, ft2, ft1        # ft4 = exp(x) - 1/exp(x)
    fdiv.s ft8, ft8, ft4        # ft8 (temp for %res) = (exp(x) + 1/exp(x)) / (exp(x) - 1/exp(x))

    # Restore %res from the temporary register
    fmv.s %res, ft8             # Copy result from ft8 (temp for %res) back to %res

    # Restore the saved floating-point registers from the stack
    flw ft1, 0(sp)              # Restore ft1
    flw ft2, 4(sp)              # Restore ft2
    flw ft4, 8(sp)              # Restore ft4
    flw ft5, 12(sp)             # Restore ft5
    addi sp, sp, 16             # Deallocate stack space
.end_macro
