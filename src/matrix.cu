#include <stdio.h>
#include <Windows.h>
#include "matrix.h"

#define __TEST__

#ifdef __cplusplus
extern "C"{
#endif


// Forward declaration of the matrix multiplication kernel    
__global__ void MatMulKernel(const Matrix, const Matrix, Matrix); 
    
// Matrix multiplication - Host code    
// Matrix dimensions are assumed to be multiples of BLOCK_SIZE    
void MatMul(const Matrix A, const Matrix B, Matrix C) {   
    
    // dimension check
    if(A.width != B.height){
        printf("A dimension 1 doesn't match B dimension 0.\n");
        return;
    }
    if(A.height != C.height){
        printf("A dimension 0 doesn't match C dimension 0.\n");
        return;
    }
    if(B.width != C.width){
        printf("B dimension 1 doesn't match C dimension 1.\n");
        return;
    }

    // Load A and B to device memory    
    Matrix d_A;    
    d_A.width = A.width; d_A.height = A.height;    
    size_t size = A.width * A.height * sizeof(float);    
    cudaMalloc(&d_A.elements, size);    
    cudaMemcpy(d_A.elements, A.elements, size, cudaMemcpyHostToDevice);    
    Matrix d_B;    
    d_B.width = B.width; d_B.height = B.height;    
    size = B.width * B.height * sizeof(float);    
    cudaMalloc(&d_B.elements, size);    
    cudaMemcpy(d_B.elements, B.elements, size, cudaMemcpyHostToDevice);    
    
    // Allocate C in device memory    
    Matrix d_C;    
    d_C.width = C.width; d_C.height = C.height;    
    size = C.width * C.height * sizeof(float);    
    cudaMalloc(&d_C.elements, size);    
    
    // Invoke kernel    
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);    
    dim3 dimGrid(B.width / dimBlock.x, A.height / dimBlock.y);   
    
#ifdef __TEST__
    // time test code
    LARGE_INTEGER nFreq;
    LARGE_INTEGER t1;
    LARGE_INTEGER t2;
    double dt;
    QueryPerformanceFrequency(&nFreq);
    QueryPerformanceCounter(&t1);
#endif //__TEST

    MatMulKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C);  

#ifdef __TEST__
    QueryPerformanceCounter(&t2);
    dt = (t2.QuadPart -t1.QuadPart)/(double)nFreq.QuadPart; 
    printf("%lfs\n", dt);  
#endif //__TEST
    
    // Read C from device memory    
    cudaMemcpy(C.elements, d_C.elements, size, cudaMemcpyDeviceToHost);    
    
    // Free device memory    
    cudaFree(d_A.elements);    
    cudaFree(d_B.elements);    
    cudaFree(d_C.elements);    
}    
    
// Matrix multiplication kernel called by MatMul()    
__global__ void MatMulKernel(Matrix A, Matrix B, Matrix C) {    
    // Each thread computes one element of C    
    // by accumulating results into Cvalue    
    float Cvalue = 0;    
    int row  = blockIdx.y * blockDim.y + threadIdx.y;    
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    for (int e = 0; e < A.width; ++e) {   
		Cvalue += A.elements[row * A.width + e] * B.elements[e * B.width + col];    
	}
    C.elements[row * C.width + col] = Cvalue;    
}

#ifdef __cplusplus
};
#endif