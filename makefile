MSCC:= cl.exe
NVCC:= nvcc
MSLINK:= link.exe
CFLAGS:= -O2 -Wall -Werror -Wno-unused 

MSVC_PATH:= C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/bin/amd64
VS_INCLUDE:= C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include
VS_LIB:= C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/lib/amd64
SYS_INCLUDE:= C:/Program Files (x86)/Windows Kits/10/Include/10.0.18362.0
SYS_LIB:= C:/Program Files (x86)/Windows Kits/10/Lib/10.0.18362.0
CUDA_LIB:= "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v9.1/lib/x64"

MS_INCLUDE:= /I"$(SYS_INCLUDE)/ucrt" /I"$(SYS_INCLUDE)/um" /I"$(SYS_INCLUDE)/shared" /I"$(VS_INCLUDE)"
LIBS:= cudart.lib /LIBPATH:$(CUDA_LIB) /LIBPATH:"$(VS_LIB)" /LIBPATH:"$(SYS_LIB)/um/x64" /LIBPATH:"$(SYS_LIB)/ucrt/x64"
DIR_SRC:= ./src
DIR_OBJ:= ./obj
DIR_OBJ_WIN:= .\obj
TARGET:= test.exe
OBJECT_NAMES := test.obj matrix.obj
OBJECTS := $(addprefix $(DIR_OBJ)/,$(OBJECT_NAMES))
MSCC := $(addprefix $(MSVC_PATH)/,$(MSCC))
MSCC := "$(MSCC)"
MSLINK := $(addprefix $(MSVC_PATH)/,$(MSLINK))
MSLINK := "$(MSLINK)"

all: $(TARGET) 

$(shell mkdir obj)

$(TARGET): $(OBJECTS)
	$(MSLINK) $(OBJECTS) $(LIBS) /out:$(TARGET) /MACHINE:x64
   
$(DIR_OBJ)/%.obj: $(DIR_SRC)/%.c   
	$(MSCC) /c $< $(MS_INCLUDE) /Fo$@

$(DIR_OBJ)/%.obj: $(DIR_SRC)/%.cu   
	$(NVCC) -c  $< -o $@
  
.PHONY : clean
clean:   
	-del $(DIR_OBJ_WIN)\*.obj
	-del $(TARGET) 
	rmdir obj
