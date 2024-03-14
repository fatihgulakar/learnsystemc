LIB_DIR=-L$(SYSTEMC_HOME)/lib-linux64
INC_DIR=-I$(SYSTEMC_HOME)/include
LIB=-lsystemc -Wl,-rpath,$(SYSTEMC_HOME)/lib-linux64

PROJECT=hello_sc

CFLAGS   += $(INC_DIR) -O0 -ggdb3
CFLAGS   += -Wall -Wno-sign-compare
CFLAGS   += -fsanitize=address -fsanitize=undefined
CXXFLAGS += $(CFLAGS) -std=c++20
LDFLAGS  += $(LIB_DIR) $(LIB) $(CFLAGS) -std=c++20

# Build path and target
BUILD_DIR  = ./build
OUTPUT_DIR = ./output
OBJ_DIR    = $(BUILD_DIR)/objs
BINARY     = $(OUTPUT_DIR)/$(PROJECT).out

# Default build goal
default: $(BINARY)

CXX = g++
LD  = $(CXX)

SRCS := $(shell find ./$(PROJECT)/src -name '*.cpp')
OBJS = $(SRCS:%.cpp=$(OBJ_DIR)/%.o)

$(OBJ_DIR)/%.o: %.cpp
	@echo + CXX $<
	@mkdir -p $(dir $@)
	@$(CXX) $(CXXFLAGS) -c -o $@ $<

# Linking
$(BINARY): $(OBJS) 
	@echo + LD $@
	@mkdir -p $(dir $@)
	@$(LD) -o $@ $(OBJS) $(LDFLAGS)

run: $(BINARY)
	./$(BINARY)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)

gdb: $(BINARY)
	gdb --tui -s $(BINARY) --args $(BINARY)

.PHONY: default clean run