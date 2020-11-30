#include <malloc.h>
#include <stdio.h>
#include <Windows.h>
#include "matrix.h"

#define DIM1 16
#define DIM2 65536
#define DIM3 256

void initializeMatrix(Matrix A){
    if(NULL == A.elements){
        A.elements = (float*) malloc(A.width * A.height * sizeof(float));
    }

    for(int i = 0; i < A.height; i++){
        for(int j = 0; j < A.width; j++){
            *(A.elements + i * A.width + j) = i * A.width + j + 1;
        }
    }
}

void printMatrix(Matrix A){
    if(NULL == A.elements){
        printf("Matrix not allocated memory.\n");
    }

    for(int i = 0; i < A.height; i++){
        for(int j = 0; j < A.width; j++){
            printf("%f ", *(A.elements + i * A.width + j));
        }
        printf("\n");
    }
}

void MatMulCPU(const Matrix A, const Matrix B, Matrix C){
    float sum;
    for(int i = 0; i < C.height; i++){
        for(int j = 0; j < C.width; j++){
            sum = 0;
            for(int k = 0; k < A.height; k++){
                sum += A.elements[i*A.width+k] * B.elements[k*B.width+j];
            }
            C.elements[i*C.width+j] = sum;
        }
    }
}

int main(){
        
    // timer preparation
    LARGE_INTEGER nFreq;
    LARGE_INTEGER t1;
    LARGE_INTEGER t2;
    double dt;
    QueryPerformanceFrequency(&nFreq);

    // matrix preparation
    Matrix A, B, C;
    A.height = C.height = DIM1;
    A.width = B.height = DIM2;
    B.width = C.width = DIM3;

    A.elements = (float*) malloc(A.width * A.height * sizeof(float));
    B.elements = (float*) malloc(B.width * B.height * sizeof(float));
    C.elements = (float*) malloc(C.width * C.height * sizeof(float));

    // CUDA test
    printf("Parallel compute with CUDA:");

    initializeMatrix(A);
    initializeMatrix(B);
    initializeMatrix(C);
    
    MatMul(A, B, C);
    

    // CPU test
    printf("Serial compute with CPU:");

    initializeMatrix(A);
    initializeMatrix(B);
    initializeMatrix(C);

    QueryPerformanceCounter(&t1);
    MatMulCPU(A, B, C);
    QueryPerformanceCounter(&t2);
    dt = (t2.QuadPart -t1.QuadPart)/(double)nFreq.QuadPart; 
    printf("%lfs\n", dt);

    // clean
    free(A.elements);
    free(B.elements);
    free(C.elements);

	return 0;
}