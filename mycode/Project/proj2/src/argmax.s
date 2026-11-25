.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    addi t0, zero, 1
    bge a1, t0, loop_start
    li a1, 77
    jal exit2

loop_start:
    mv s0, a0
    mv s1, a1
    addi t0, zero, 1
    lw t2, 0(s0)
    mv a0, zero
loop_continue:
    beq t0, s1, loop_end
    slli t1, t0, 2
    add t1, t1, s0   # get address
    lw a1, 0(t1)
    bge t2, a1, continue
    mv a0, t0
    mv t2, a1
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
