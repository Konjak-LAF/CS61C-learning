.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)

    addi t0, zero, 1
    bge a2, t0, check1
    li a1, 75
    jal exit2
check1:
    bge a3, t0, check2
    li a1, 76
    jal exit2
check2:
    bge a4, t0, loop_start
    li a1, 76
    jal exit2
loop_start:
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv t0, zero
    mv t1, zero
    mv a0, zero
    mv a1, zero
    # now a1 is i, t0 and t1 is real index
    # a2 is free
loop:
    slli t2, t0, 2
    add t2, t2, s0   # get address   
    lw a2, 0(t2)     # val of A
    slli t2, t1, 2
    add t2, t2, s1   # get address   
    lw t3, 0(t2)     # val of B
    mul a2, a2, t3
    add a0, a0, a2
    add t0, t0, a3
    add t1, t1, a4
    addi a1, a1, 1
    blt a1, s2, loop

loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
