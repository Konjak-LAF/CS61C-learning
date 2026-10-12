/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) {
		return NULL;
	}
	char buf[10];
	uint32_t n, m, K;
	fscanf(fp, "%s%d%d%d", buf, &m, &n, &K);
	Image *res;
	res = (Image *)malloc(sizeof(Image));
	res->rows = n;
	res->cols = m;
	res->image = (Color **)malloc(n * sizeof(Color*));
	for (uint32_t i = 0; i < n; i++) {
		res->image[i] = (Color *)malloc(m * sizeof(Color));
		for (uint32_t j = 0; j < m; j++) {
			fscanf(fp, "%hhu%hhu%hhu", &res->image[i][j].R, &res->image[i][j].G, &res->image[i][j].B);
		}
	}
	fclose(fp);
	return res;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n%d %d\n255\n", image->cols, image->rows);
	Color x;
	for (int i = 0; i < image->rows; i++) {
		for (int j = 0; j < image->cols; j++) {
			x = image->image[i][j];
			printf("%3d %3d %3d", x.R, x.G, x.B);
			if (j < image->cols - 1)
				printf("   ");
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for (int i = 0; i < image->rows; i++)
		free(image->image[i]);
	free(image->image);
	free(image);
}