.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2      # store old arguments

    li a0, 32
    jal malloc
    mv s3, a0      # malloc buffer
    bne a0, zero, malloc_ok
    li a1, 88
    jal exit2
malloc_ok:

    # mv a1, s0
    # jal print_str

    mv a1, s0
    mv a2, zero    # read mode
    jal fopen

    li t0, -1
    bne a0, t0, fopen_ok
    li a1, 90
    jal exit2
fopen_ok:

    mv s0, a0   # file name is useless

    # mv a1, s3
    # jal print_int
 
    jal read_byte
    lw t0, 0(s3)
    sw t0, 0(s1)    # read row

#    mv a1, t0
#    jal print_int
#    li a1, 10
#    jal print_char

    mv s4, t0
    jal read_byte
    lw t0, 0(s3)
    sw t0, 0(s2)    # read col
    mul s4, s4, t0

    # mv a1, s4
    # jal print_int
    # li a1, 10
    # jal print_char

    slli a0, s4, 2
    jal malloc
    mv s5, a0      # malloc array
    bne a0, zero, malloc_array_done
    li a1, 88
    jal exit2
malloc_array_done:

    mv a1, s0
    mv a2, s5
    slli a3, s4, 2
    jal fread   # call fread
    slli t0, s4, 2
    beq a0, t0, fread_ok2
    li a1, 91
    jal exit2   
fread_ok2:


# another method is to read one by one
# # loop begin
#     mv t0, zero
# loop:
#     addi sp, sp, -4         #   pro
#     sw t0, 0(sp)
#     jal read_byte           #   read
#     lw t0, 0(sp)
#     addi sp, sp, 4          #   ep
# 
#     lw t1, 0(s3)
#     slli t2, t0, 2
#     add t2, t2, s5          # get addr
#     sw t1, 0(t2)
#     addi t0, t0, 1
#     blt t0, s4, loop
# # loop end

    mv a1, s0
    jal fclose  # close file

    li t0, -1
    bne a0, t0, fclose_ok
    li a1, 92
    jal exit2
fclose_ok:

    mv a0, s3
    jal free # free buffer

    mv a0, s5  ##  return value

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    ret


read_byte:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s0
    mv a2, s3
    li a3, 4
    jal fread   # call fread
    li t0, 4
    beq a0, t0, fread_ok
    li a1, 91
    jal exit2   
fread_ok:
    lw ra, 0(sp)    
    addi sp, sp, 4
    # Epilogue
    ret