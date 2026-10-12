/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
int alive(int cur, int count, uint32_t rule) {
	if (cur)
		return ((rule >> 9) >> count) & 1;
	return (rule >> count) & 1;
}
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	// if (row == 8 && col == 2) {
	// 	printf("here\n");
	// }
	Color p, q;
	Color *res = malloc(sizeof(Color));
	p = image->image[row][col];
	res->R = res->G = res->B = 0;
	// if (row == 9 && p.R == 255) {
	// 	printf("here\n");
	// }
	for (int w = 0; w <= 7; w++) {
		int cr, cg, cb;
		cr = cg = cb = 0;
		for (int i = -1; i <= 1; i++)
			for (int j = -1; j <= 1; j++) {
				if (i == 0 && j == 0) continue;
				int x = row + i, y = col + j;
				if (x < 0) x = image->rows - 1;
				if (y < 0) y = image->cols - 1;
				if (x == image->rows) x = 0;
				if (y == image->cols) y = 0;
				q = image->image[x][y];
				cr += (q.R >> w) & 1;
				cg += (q.G >> w) & 1;
				cb += (q.B >> w) & 1;
			}		
		res->R |= alive(p.R >> w & 1, cr, rule) << w;
		res->G |= alive(p.G >> w & 1, cg, rule) << w;
		res->B |= alive(p.B >> w & 1, cb, rule) << w;
	}
	return res;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image *res = malloc(sizeof(Image));
	int n = image->rows, m = image->cols;
	res->rows = n;
	res->cols = m;
	res->image = (Color **)malloc(n * sizeof(Color*));
	if (res->image == NULL) {
		exit(-1);
	}
	for (uint32_t i = 0; i < n; i++) {
		res->image[i] = (Color *)malloc(m * sizeof(Color));
		if (res->image[i] == NULL) {
			exit(-1);
		}
		for (uint32_t j = 0; j < m; j++) {
			Color *o = evaluateOneCell(image, i, j, rule);
			res->image[i][j] = *o;
			free(o);
		}
	}
	return res;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc <= 2) {
		printf("usage: ./gameOfLife filename rule\n");
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.");
		exit(-1);
	}
	Image* a = readData(argv[1]);
	if (a == NULL) {
		exit(-1);
	}
	uint32_t rule;
	char * end;
	rule = strtol(argv[2], &end, 16);
	if (end == argv[2] || *end != '\0') {
		freeImage(a);
		exit(-1);
	}
	// writeData(a);
	Image *b = life(a, rule);
	writeData(b);
	freeImage(a);
	freeImage(b);
	return 0;
}
