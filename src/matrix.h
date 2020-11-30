#ifndef _MATRIX_H_
#define _MATRIX_H_

// Matrices are stored in row-major order:    
// M(row, col) = *(M.elements + row * M.width + col)    
typedef struct {    
    int width;    
    int height;    
    float *elements;    
} Matrix;    

// Thread block size    
#define BLOCK_SIZE 16    

#ifdef __cplusplus
extern "C"{
#endif

// Matrix multiplication - Host function
void MatMul(const Matrix A, const Matrix B, Matrix C);

#ifdef __cplusplus
};
#endif

#endif // _MATRIX_H_