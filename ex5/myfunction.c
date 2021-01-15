#include <stdbool.h> 

typedef struct {
	unsigned char red;
	unsigned char green;
	unsigned char blue;
} pixel;

typedef struct {
	int red;
	int green;
	int blue;
} pixel_sum;

// I used macros because they are more efficient then functions and i also changed the function calcIndex
// Compute min and max of two integers, respectively
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))
#define calcIndex(i,j,n) ((i)*(n)+(j))

//This is doConvolution function and i put inside this function the code of the function that doConvolution was call
void doConvolution(Image* image, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {
	int dim = m;
	int size = dim * n * sizeof(pixel);
	pixel* pixelsImg = malloc(size);
	pixel* backupOrg = malloc(size);

	// Convert chars to pixels - I moved the function charsToPixels to here
	int row, col;
	char* data = image->data;
	for (row = 0; row < m; row++) {
		for (col = 0; col < n; col++) {
			pixelsImg[row * n + col].red = data[3 * row * n + 3 * col];
			pixelsImg[row * n + col].green = data[3 * row * n + 3 * col + 1];
			pixelsImg[row * n + col].blue = data[3 * row * n + 3 * col + 2];
		}
	}

	// I swich the function copy to memcpy function
	memcpy(backupOrg, pixelsImg, size);


	//This part is the functiom smooth that i moved here
	int i, j, cur_case;
	if (kernel[0][0] == 1)
	{
		cur_case = 1;
	}
	else {
		cur_case = 2;
	}

	// insatd of calculate the size of half kernelSize i set new variable that coantain the value of half kernel size
	int half_kernelSize = kernelSize / 2;
	for (i = half_kernelSize; i < dim - half_kernelSize; i++) {
		for (j = half_kernelSize; j < dim - half_kernelSize; j++) {
			//int ii, jj;
			int currRow, currCol;
			pixel_sum sum;
			pixel current_pixel;
			int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
			int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
			int min_row, min_col, max_row, max_col;
			pixel loop_pixel;

			//initialize_pixel_sum - Initializes all fields of sum to zero, instad of function i put this here
			sum.red = 0;
			sum.green = 0;
			sum.blue = 0;

			//Instead of using a double loop, reading all of the pixels at once and summing them up according to the pixel  
			// calculate the index of the top left corner of the current part of the image
			int index = calcIndex(i - 1, j - 1, dim);
			pixel pixel1 = backupOrg[index];
			pixel pixel2 = backupOrg[index + 1];
			pixel pixel3 = backupOrg[index + 2];
			index += dim;
			pixel pixel4 = backupOrg[index];
			pixel pixel5 = backupOrg[index + 1];
			pixel pixel6 = backupOrg[index + 2];
			index += dim;
			pixel pixel7 = backupOrg[index];
			pixel pixel8 = backupOrg[index + 1];
			pixel pixel9 = backupOrg[index + 2];

			int non_center_sum_r = (int)pixel1.red + (int)pixel2.red + (int)pixel3.red + (int)pixel4.red + (int)pixel6.red + (int)pixel7.red + (int)pixel8.red + (int)pixel9.red;
			int non_center_sum_g = (int)pixel1.green + (int)pixel2.green + (int)pixel3.green + (int)pixel4.green + (int)pixel6.green + (int)pixel7.green + (int)pixel8.green + (int)pixel9.green;
			int non_center_sum_b = (int)pixel1.blue + (int)pixel2.blue + (int)pixel3.blue + (int)pixel4.blue + (int)pixel6.blue + (int)pixel7.blue + (int)pixel8.blue + (int)pixel9.blue;
			if (cur_case == 1)
			{
				sum.red += non_center_sum_r + (int)pixel5.red;
				sum.green += non_center_sum_g + (int)pixel5.green;
				sum.blue += non_center_sum_b + (int)pixel5.blue;
			}
			else
			{
				sum.red -= non_center_sum_r - (9 * (int)pixel5.red);
				sum.green -= non_center_sum_g - (9 * (int)pixel5.green);
				sum.blue -= non_center_sum_b - (9 * (int)pixel5.blue);
			}

			int ii, jj;
			if (filter) {
				int loop_pixel_sum;
				// find min and max coordinates
				for (ii = max(i - 1, 0); ii <= min(i + 1, dim - 1); ii++) {
					for (jj = max(j - 1, 0); jj <= min(j + 1, dim - 1); jj++) {
						// check if smaller than min or higher than max and update
						loop_pixel = backupOrg[calcIndex(ii, jj, dim)];
						loop_pixel_sum = (int)loop_pixel.red + (int)loop_pixel.green + (int)loop_pixel.blue;
						if (loop_pixel_sum <= min_intensity) {
							min_intensity = loop_pixel_sum;
							min_row = ii;
							min_col = jj;
						}
						if (loop_pixel_sum > max_intensity) {
							max_intensity = loop_pixel_sum;
							max_row = ii;
							max_col = jj;
						}
					}
				}

				// filter out min and max
				//sum_pixels_by_weight - Sums pixel values, scaled by given weight
				pixel p = backupOrg[(min_row) * (dim)+min_col];
				int weight = -1;
				sum.red += ((int)p.red) * weight;
				sum.green += ((int)p.green) * weight;
				sum.blue += ((int)p.blue) * weight;
				//sum_pixels_by_weight - Sums pixel values, scaled by given weight
				p = backupOrg[max_row * dim + max_col];
				sum.red += ((int)p.red) * weight;
				sum.green += ((int)p.green) * weight;
				sum.blue += ((int)p.blue) * weight;
			}

			// assign kernel's result to pixel at [i,j]
			// i moved the func assign_sum_to_pixel to here
			//in case the kernelScale there is no need to divide 
			if (kernelScale != 1)
			{
				sum.red = sum.red / kernelScale;
				sum.green = sum.green / kernelScale;
				sum.blue = sum.blue / kernelScale;
			}

			// truncate each pixel's color values to match the range [0,255]
			current_pixel.red = (unsigned char)(min(max(sum.red, 0), 255));
			current_pixel.green = (unsigned char)(min(max(sum.green, 0), 255));
			current_pixel.blue = (unsigned char)(min(max(sum.blue, 0), 255));

			pixelsImg[i * dim + j] = current_pixel;
		}
	}

	// Convert from pixels to chars
	for (row = 0; row < m; row++) {
		for (col = 0; col < n; col++) {
			data[3 * row * n + 3 * col] = pixelsImg[row * n + col].red;
			data[3 * row * n + 3 * col + 1] = pixelsImg[row * n + col].green;
			data[3 * row * n + 3 * col + 2] = pixelsImg[row * n + col].blue;
		}
	}

	// free the memory
	free(pixelsImg);
	free(backupOrg);
}

void myfunction(Image* image, char* srcImgpName, char* blurRsltImgName, char* sharpRsltImgName, char* filteredBlurRsltImgName, char* filteredSharpRsltImgName, char flag) {

	/*
	* [1, 1, 1]
	* [1, 1, 1]
	* [1, 1, 1]
	*/
	int blurKernel[3][3] = { {1, 1, 1}, {1, 1, 1}, {1, 1, 1} };

	/*
	* [-1, -1, -1]
	* [-1, 9, -1]
	* [-1, -1, -1]
	*/
	int sharpKernel[3][3] = { {-1,-1,-1},{-1,9,-1},{-1,-1,-1} };

	if (flag == '1') {
		// blur image
		doConvolution(image, 3, blurKernel, 9, false);

		// write result image to file
		writeBMP(image, srcImgpName, blurRsltImgName);

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);

		// write result image to file
		writeBMP(image, srcImgpName, sharpRsltImgName);
	}
	else {
		// apply extermum filtered kernel to blur image
		doConvolution(image, 3, blurKernel, 7, true);

		// write result image to file
		writeBMP(image, srcImgpName, filteredBlurRsltImgName);

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);

		// write result image to file
		writeBMP(image, srcImgpName, filteredSharpRsltImgName);
	}
}