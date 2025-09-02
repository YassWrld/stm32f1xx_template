# Makefile for STM32F10x projects

SPL_SRC = \
  $(STM_COMMON)/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c \
  $(STM_COMMON)/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c

# Put your source files here (*.c)
SRCS = src/main.c src/system_stm32f10x.c \
       $(SPL_SRC)

# Binaries will be generated with this name (.elf, .bin, .hex)
PROJ_NAME=template

# Build directory
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj

# Put your STM32FXX library code directory here, change YOURUSERNAME to yours
STM_COMMON=/home/yass/Dev/Embedded/stm32/STM32F10x_StdPeriph_Lib_V3.6.0

# Compiler settings. Only edit CFLAGS to include other header files.
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

# Compiler flags
CFLAGS  = -g -O2 -Wall -Tstm32_flash.ld --specs=nosys.specs
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I. -Iinclude

# Include files from STM libraries
# CMSIS core support (Cortex-M3)
CFLAGS += -I$(STM_COMMON)/Libraries/CMSIS/CM3/CoreSupport

# CMSIS device headers (STM32F10x family)
CFLAGS += -I$(STM_COMMON)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x

# SPL drivers (GPIO, RCC, USART, etc.)
CFLAGS += -I$(STM_COMMON)/Libraries/STM32F10x_StdPeriph_Driver/inc

# add startup file to build
SRCS += $(STM_COMMON)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_hd.s

# Object files will be placed in build/obj directory
OBJS = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.c=.o)))
OBJS := $(OBJS:.s=.o)

vpath %.c src $(STM_COMMON)/Libraries/STM32F10x_StdPeriph_Driver/src
vpath %.s $(STM_COMMON)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7

.PHONY: proj clean

# Commands
all: proj

proj: $(BUILD_DIR)/$(PROJ_NAME).elf

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Create obj directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Pattern rule for compiling C files
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Pattern rule for assembling .s files
$(OBJ_DIR)/%.o: %.s | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/$(PROJ_NAME).elf: $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $@ $(BUILD_DIR)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $@ $(BUILD_DIR)/$(PROJ_NAME).bin

clean:
	rm -rf $(BUILD_DIR)

# Flash the STM32 using stlink
burn: proj
	st-flash write $(BUILD_DIR)/$(PROJ_NAME).bin 0x8000000