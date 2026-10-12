#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t v = *reg;
    *reg = (v >> 1) | (((v ^ (v >> 2) ^ (v >> 3) ^ (v >> 5)) & 1) << 15);
}

