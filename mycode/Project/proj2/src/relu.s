.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    addi t0, zero, 1
    bge a1, t0, loop_start
    li a1, 78
    jal exit2

loop_start:
    mv s0, a0
    mv s1, a1
    mv t0, zero


loop_continue:
    slli t1, t0, 2
    add t1, t1, s0   # get address
    lw a0, 0(t1)
    bge a0, zero, continue
    sw zero, 0(t1) 
continue:
    addi t0, t0, 1
    bne t0, s1, loop_continue

loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
	ret
