.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    addi t0, zero 1
check_r1:
    bge a1, t0, check_w1
    li a1, 72
    jal exit2
check_w1:
    bge a2, t0, check_r2 
    li a1, 72
    jal exit2
check_r2:
    bge a4, t0, check_w2 
    li a1, 73
    jal exit2
check_w2:
    bge a5, t0, check_eq 
    li a1, 73
    jal exit2
check_eq:
    beq a2, a4, ok
    li a1, 74
    jal exit2
ok:
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    # outer_init
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3     # for calling "dot"
                  # since a2 = a4, I don't backup a4
    mv s5, a5
    mv s6, a6     # call convention !!!
    mv t0, zero   # i = 0
    mv t2, zero   # i*a2
    mv t3, zero   # i*a5+j  (index in a6)

outer_loop_start:



    # inner init
    mv t1, zero   # j = 0
inner_loop_start:

# function call
    
    # mv a1, t2
    # jal print_int
    # li a1, 10
    # jal print_char

    slli t4, t2, 2
    add a0, t4, s0      # get address   

    slli t4, t1, 2      #
    add a1, t4, s3      # get address      
    mv a2, s2           # length
    addi a3, zero, 1    # stride 1
    mv a4, s5           # stride 2
    # call Prologue
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    jal dot
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    addi sp, sp, 16
    # call Epilogue

    slli t4, t3, 2
    add t4, t4, s6      # get address
    sw a0, 0(t4)        # store result



    addi t1, t1, 1
    addi t3, t3, 1
    blt t1, s5, inner_loop_start
inner_loop_end:

    add t2, t2, s2
    addi t0, t0, 1
    blt t0, s1, outer_loop_start
outer_loop_end:


    # Epilogue
    
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    ret
