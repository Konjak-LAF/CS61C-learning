.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)   # array
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    sw s7, 32(sp)   # array size
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2              #  save the args

    li t0, 5
    beq s0, t0, correct_args
    li a1, 89
    jal exit2   
correct_args:
    # notice that s0 is useless now


	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0

    jal new_int
    mv s7, a0
    jal new_int
    mv s8, a0


    # lw a1, 4(s1)
    # jal print_str
    # li a1, 10
    # jal print_char


    lw a0, 4(s1)
    mv a1, s7
    mv a2, s8
    jal read_matrix
    mv s3, a0

    # Load pretrained m1

    jal new_int
    mv s9, a0
    jal new_int
    mv s10, a0

    lw a0, 8(s1)
    mv a1, s9
    mv a2, s10
    jal read_matrix
    mv s4, a0


    # Load input matrix

    jal new_int
    mv s0, a0
    jal new_int
    mv s11, a0

    lw a0, 12(s1)
    mv a1, s0
    mv a2, s11
    jal read_matrix
    mv s5, a0

    ### print for debug
    beq zero, zero, print_end
    lw a1, 0(s7)
    jal print_int
    li a1, 32
    jal print_char
    lw a1, 0(s8)
    jal print_int
    li a1, 10
    jal print_char
    lw a1, 0(s9)
    jal print_int
    li a1, 32
    jal print_char
    lw a1, 0(s10)
    jal print_int
    li a1, 10
    jal print_char
    lw a1, 0(s0)
    jal print_int
    li a1, 32
    jal print_char
    lw a1, 0(s11)
    jal print_int
    li a1, 10
    jal print_char
print_end:



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    ### 1
    # notice that m0(s7*s8)*in(s0*s11) so s8==s0, s0 is useless again!
    lw t0, 0(s8)
    lw t1, 0(s0)
    beq t0, t1, ok
    li a1, 74
    jal exit2
ok:
    lw t0, 0(s7)
    lw t1, 0(s11)
    mul t0, t0, t1
    slli a0, t0, 4



    jal malloc
    mv s0, a0      # malloc array
    bne a0, zero, malloc_hidden
    li a1, 88
    jal exit2
malloc_hidden:

    
    mv a0, s3
    lw t0, 0(s7)
    mv a1, t0
    lw t0, 0(s8)
    mv a2, t0
    mv a3, s5
    mv a4, t0
    lw t0, 0(s11)
    mv a5, t0
    mv a6, s0
    jal matmul
    ### 1

    # lw a1, 0(s0)
    # jal print_int
    # li a1, 32
    # jal print_char
    # lw a1, 4(s0)
    # jal print_int
    # li a1, 32
    # jal print_char
    # lw a1, 8(s0)
    # jal print_int
    # li a1, 10
    # jal print_char


    ### 2


    mv a0, s0
    lw t0, 0(s7)
    lw t1, 0(s11)
    mul a1, t0, t1
    jal relu

    ### 2

    ### 3

    # m1: s9*s10, s0(hidden layer) : s7*s11, so s7==s10, s10 is free
    lw t0, 0(s7)
    lw t1, 0(s10)
    beq t0, t1, ok2
    li a1, 74
    jal exit2
ok2:
    lw t0, 0(s9)
    lw t1, 0(s11)
    mul t0, t0, t1
    slli a0, t0, 4
    jal malloc
    mv s10, a0      # malloc array
    bne a0, zero, malloc_score
    li a1, 88
    jal exit2
malloc_score:    

    mv a0, s4
    lw t0, 0(s9)
    mv a1, t0
    lw t0, 0(s7)
    mv a2, t0
    mv a3, s0
    mv a4, t0
    lw t0, 0(s11)
    mv a5, t0
    mv a6, s10
    jal matmul    

    ### 3

    mv a0, s0
    jal free    #  free hidden layer





    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    mv a1, s10
    lw t0, 0(s9)
    mv a2, t0
    lw t0, 0(s11)
    mv a3, t0
    jal write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s10
    lw t0, 0(s9)
    lw t1, 0(s11)
    mul a1, t0, t1
    jal argmax

    bne s2, zero, end_of_func
    # Print classification
    
    # a0 is the result
    lw t1, 0(s11)
    div a1, a0, t1
    jal print_int
    
    # Print newline afterwards for clarity
    li a1, 10
    jal print_char

end_of_func:

    # free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    # mv a0, s6
    # jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    mv a0, s11
    jal free

return_p:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)   # array
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)

    lw s7, 32(sp)   # array size
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret


new_int:
    addi sp, sp, -4
    sw ra, 0(sp)
    # Prologue end
    li a0, 4
    jal malloc
    bne a0, zero, malloc_end
    li a1, 88
    jal exit2
malloc_end:
    # Epilogue begin
    lw ra, 0(sp)
    addi sp, sp, 4
    ret