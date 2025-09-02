# STM32F1xx Template Project

A clean and organized starter template for STM32F1xx microcontroller development using the **Standard Peripheral Library (SPL)**, not HAL. This template provides a professional project structure that's easy to maintain and extend.

## 🚀 Features

- **Clean Project Structure**: Organized source files, headers, and build outputs
- **SPL-based**: Uses STM32F10x Standard Peripheral Library for maximum hardware control
- **Makefile Build System**: Simple and efficient compilation process
- **Cross-platform**: Works on Linux, macOS, and Windows
- **Easy to Extend**: Well-structured for adding new features and peripherals

## 📁 Project Structure

```
stm32f1xx_template/
├── src/                    # Source files (.c)
│   ├── main.c
│   └── system_stm32f10x.c
├── include/                # Header files (.h)
│   ├── stm32f10x.h
│   └── stm32f10x_conf.h
├── build/                  # Build outputs (generated)
│   ├── obj/               # Object files (.o)
│   ├── template.elf       # Executable
│   ├── template.hex       # Intel HEX format
│   └── template.bin       # Binary format
├── Makefile               # Build configuration
├── stm32_flash.ld         # Linker script
└── README.md
```

## 📋 Prerequisites

### Required Tools

- **ARM GCC Toolchain**: `arm-none-eabi-gcc`
- **STM32 Flash Tool**: `st-flash` (from stlink package)
- **Make**: Build automation tool

### Install on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install gcc-arm-none-eabi stlink-tools make
```

### Install on macOS:

```bash
brew install --cask gcc-arm-embedded
brew install stlink
```

## 🔧 Setup Instructions

### 1. Download STM32F10x Standard Peripheral Library

1. Download the STM32F10x Standard Peripheral Library from ST's website:

   - [STM32F10x Standard Peripheral Library](https://www.st.com/en/embedded-software/stm32-standard-peripheral-libraries.html)
   - Or use the direct link for v3.6.0

2. Extract the library to your development directory:
   ```bash
   # Example path structure:
   /home/username/Dev/Embedded/stm32/STM32F10x_StdPeriph_Lib_V3.6.0/
   ```

### 2. Configure the Makefile

Edit the `Makefile` and update the `STM_COMMON` path to point to your SPL library:

```makefile
# Put your STM32FXX library code directory here, change to your path
STM_COMMON=/path/to/your/STM32F10x_StdPeriph_Lib_V3.6.0
```

### 3. Configure for Your Board

The template is configured for **STM32F103RCTx** (256KB Flash, 48KB RAM). To use with other STM32F1xx variants:

1. **Update the linker script** (`stm32_flash.ld`):

   - Modify `FLASH` and `RAM` sizes according to your MCU
   - See [Getting the Right Linker Script](#-getting-the-right-linker-script) section

2. **Update startup file** in `Makefile` if needed:
   ```makefile
   # Change startup file according to your device (ld/md/hd/xl/cl)
   SRCS += $(STM_COMMON)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_hd.s
   ```

## 🔨 Building and Flashing

### Build the Project

```bash
make
```

This will create all build outputs in the `build/` directory.

### Flash to MCU

```bash
make burn
```

This uses `st-flash` to program the microcontroller via ST-Link.

### Clean Build Files

```bash
make clean
```

Removes the entire `build/` directory.

## 📖 Getting the Right Linker Script

The easiest way to get the correct linker script for your specific STM32 board:

1. **Open STM32CubeIDE**
2. **Create a new project** for your exact board/MCU
3. **Let CubeIDE auto-generate** the project
4. **Copy the linker script** (usually named `STM32F1xxxx_FLASH.ld`)
5. **Rename it** to `stm32_flash.ld` and replace the one in this template

This ensures you have the correct memory layout, stack size, and heap configuration for your specific microcontroller.

## 🔄 Adapting for Other STM32 Families

This template can be easily adapted for other STM32 families:

### For STM32F4xx:

1. Download STM32F4xx Standard Peripheral Library
2. Update `STM_COMMON` path in Makefile
3. Change include paths in Makefile:
   ```makefile
   # Change F10x to F4xx in library paths
   CFLAGS += -I$(STM_COMMON)/Libraries/STM32F4xx_StdPeriph_Driver/inc
   ```
4. Update startup file path and device-specific configurations
5. Get appropriate linker script from CubeIDE

### For STM32F0xx, STM32F3xx, etc.:

Follow similar steps as above, replacing the family-specific library paths and configurations.

## 📝 Usage Example

Here's a simple example to blink an LED:

```c
// src/main.c
#include "stm32f10x.h"

void GPIO_Configuration(void);
void Delay(uint32_t nTime);

int main(void)
{
    // Configure system clock and GPIO
    SystemInit();
    GPIO_Configuration();

    while(1)
    {
        GPIO_SetBits(GPIOC, GPIO_Pin_13);   // LED ON
        Delay(500000);
        GPIO_ResetBits(GPIOC, GPIO_Pin_13); // LED OFF
        Delay(500000);
    }
}

void GPIO_Configuration(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;

    // Enable GPIOC clock
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    // Configure PC13 as output
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);
}

void Delay(uint32_t nTime)
{
    for(; nTime != 0; nTime--);
}
```

## 🎯 Why Standard Peripheral Library (SPL)?

This template uses SPL instead of HAL because:

- **Direct Hardware Control**: More precise control over peripherals
- **Smaller Code Size**: Less overhead compared to HAL
- **Educational Value**: Better for learning STM32 architecture
- **Legacy Support**: Works with older projects and documentation
- **Performance**: Often faster execution due to less abstraction

## 🐛 Troubleshooting

### Common Issues:

1. **"arm-none-eabi-gcc: command not found"**

   - Install ARM GCC toolchain
   - Add to PATH if necessary

2. **"No such file or directory" for SPL includes**

   - Check `STM_COMMON` path in Makefile
   - Ensure SPL library is properly extracted

3. **"st-flash: command not found"**

   - Install stlink-tools package
   - Check ST-Link connection

4. **Linker errors about memory regions**
   - Verify linker script matches your MCU
   - Check memory sizes in `stm32_flash.ld`

## 📄 License

This template is provided as-is for educational and development purposes. Please refer to ST's license terms for the Standard Peripheral Library components.

## 🤝 Contributing

Feel free to submit issues and improvements to make this template better for the STM32 development community!

---

**Happy Coding with STM32! 🚀**
