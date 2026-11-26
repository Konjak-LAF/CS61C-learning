.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    mv a1, s0
    li a2, 1    # write mode
    jal fopen

    li t0, -1
    bne a0, t0, fopen_ok
    li a1, 93
    jal exit2
fopen_ok:

    mv s0, a0   # file name is useless

    addi sp, sp, -4   #  store to stack , to get "address"
    sw s2, 0(sp)
    mv a1, s0
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    addi sp, sp, 4
    li t0, 1
    beq a0, t0, fwrite_ok1
    li a1, 94
    jal exit2
fwrite_ok1:

    addi sp, sp, -4   #  store to stack , to get "address"
    sw s3, 0(sp)
    mv a1, s0
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    addi sp, sp, 4
    li t0, 1
    beq a0, t0, fwrite_ok2
    li a1, 94
    jal exit2
fwrite_ok2:

    mv a1, s0
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul t0, s2, s3

    beq a0, t0, fwrite_ok3
    li a1, 94
    jal exit2
fwrite_ok3:


    mv a1, s0
    jal fclose  # close file

    li t0, -1
    bne a0, t0, fclose_ok
    li a1, 95
    jal exit2
fclose_ok:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    ret
