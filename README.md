# CUDA-Test

A test code of CUDA-C programming.

## Envorionment

1. CUDA

First, you should install CUDA on your computer. Be sure to install the CUDA version that matches the NVIDIA graphics card model.

2. System compiler

You need to link your program to the CUDA static library. If you are installing CUDA on a Windows system, the installed CUDA will only contain libraries in .lib, which is the target file format of msvc. Similarly, CUDA installed on a Linux system contains only .a libraries in the gcc target file format. Therefore, you need a compiler that is compatible with your system. Otherwise, you need to recompile the CUDA libraries using your compiler.

## Build

During the build process, you need to make sure that the libraries used are consistent with the architecture of the target platform. Therefore, you may need to change the corresponding paths in the makefile.
\
If you are using the msvc compiler (cl.exe) on a Windows system, be sure to specify the compiler's include and library directories, as well as the system's include and library directories.

## Run

    ./test.exe
