# This file was automagically generated by mbed.org. For more information, 
# see http://mbed.org/handbook/Exporting-to-GCC-ARM-Embedded

###############################################################################
# Scheduler type:
# - rm: Rate Monotonic
# - dm: Deadline Monotonic
# - edf: Earliest Deadline First
# - dp: Dual Priority
# - ss: Slack Stealing
#
HST_SCHED ?= ss

BIN_DIR = out

###############################################################################
GCC_BIN = 
PROJECT = hst
FREERTOS_OBJECTS = ./FreeRTOS/tasks.o ./FreeRTOS/queue.o ./FreeRTOS/list.o ./FreeRTOS/portable/MemMang/heap_1.o ./FreeRTOS/portable/GCC/ARM_CM3/port.o
HST_OBJECTS = ./hst/$(HST_SCHED)/scheduler_logic_$(HST_SCHED).o ./hst/scheduler.o ./hst/utils.o ./hst/wcrt.o
TEST_OBJECTS = ./test/$(HST_SCHED)/main.o
OBJECTS = $(FREERTOS_OBJECTS) $(HST_OBJECTS) $(TEST_OBJECTS)
SYS_OBJECTS = ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/cmsis_nvic.o ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/system_LPC17xx.o ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/board.o ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/retarget.o ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/startup_LPC17xx.o 
FREERTOS_INCLUDE_PATHS =  -I./FreeRTOS/include -I./FreeRTOS/portable/GCC/ARM_CM3 -I./FreeRTOS/config
HST_INCLUDE_PATHS = -I./hst -I./hst/$(HST_SCHED)
INCLUDE_PATHS = -I. -I./mbed -I./mbed/TARGET_LPC1768 -I./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM -I./mbed/TARGET_LPC1768/TARGET_NXP -I./mbed/TARGET_LPC1768/TARGET_NXP/TARGET_LPC176X -I./mbed/TARGET_LPC1768/TARGET_NXP/TARGET_LPC176X/TARGET_MBED_LPC1768 $(FREERTOS_INCLUDE_PATHS) $(HST_INCLUDE_PATHS)
LIBRARY_PATHS = -L./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM 
LIBRARIES = -lmbed 
LINKER_SCRIPT = ./mbed/TARGET_LPC1768/TOOLCHAIN_GCC_ARM/LPC1768.ld

ifeq ($(HST_SCHED), ss)
	OBJECTS += ./hst/$(HST_SCHED)/slack.o
endif

############################################################################### 
AS      = $(GCC_BIN)arm-none-eabi-as
CC      = $(GCC_BIN)arm-none-eabi-gcc
CPP     = $(GCC_BIN)arm-none-eabi-g++
LD      = $(GCC_BIN)arm-none-eabi-gcc
OBJCOPY = $(GCC_BIN)arm-none-eabi-objcopy
OBJDUMP = $(GCC_BIN)arm-none-eabi-objdump
SIZE 	= $(GCC_BIN)arm-none-eabi-size

CPU = -mcpu=cortex-m3 -mthumb
CC_FLAGS = $(CPU) -c -g -fno-common -fmessage-length=0 -Wall -fno-exceptions -ffunction-sections -fdata-sections -fomit-frame-pointer
CC_FLAGS += -MMD -MP
CC_SYMBOLS = -DTARGET_LPC1768 -DTARGET_M3 -DTARGET_CORTEX_M -DTARGET_NXP -DTARGET_LPC176X -DTARGET_MBED_LPC1768 -DTOOLCHAIN_GCC_ARM -DTOOLCHAIN_GCC -D__CORTEX_M3 -DARM_MATH_CM3 -DMBED_BUILD_TIMESTAMP=1417809229.07 -D__MBED__=1 

LD_FLAGS = $(CPU) -Wl,--gc-sections --specs=nano.specs -u _printf_float -u _scanf_float

LD_FLAGS += -Wl,-Map=$(BIN_DIR)/$(PROJECT).map,--cref
LD_SYS_LIBS = -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

ifeq ($(DEBUG), 1)
  CC_FLAGS += -DDEBUG -O0
else
  CC_FLAGS += -DNDEBUG -Os
endif

LIST = $(BIN_DIR)/$(PROJECT).bin $(BIN_DIR)/$(PROJECT).hex

all: $(LIST)

clean:
	rm -f $(BIN_DIR)/$(PROJECT).bin $(BIN_DIR)/$(PROJECT).elf $(BIN_DIR)/$(PROJECT).hex $(BIN_DIR)/$(PROJECT).map $(BIN_DIR)/$(PROJECT).lst $(OBJECTS) $(DEPS)

.s.o:
	$(AS) $(CPU) -o $@ $<

.c.o:
	$(CC)  $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu99   $(INCLUDE_PATHS) -o $@ $<

.cpp.o:
	$(CPP) $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu++98 -fno-rtti $(INCLUDE_PATHS) -o $@ $<


$(BIN_DIR)/$(PROJECT).elf: $(OBJECTS) $(SYS_OBJECTS)
	$(LD) $(LD_FLAGS) -T$(LINKER_SCRIPT) $(LIBRARY_PATHS) -o $@ $^ $(LIBRARIES) $(LD_SYS_LIBS) $(LIBRARIES) $(LD_SYS_LIBS)
	@echo ""
	@echo "*****"
	@echo "***** You must modify vector checksum value in *.bin and *.hex files."
	@echo "*****"
	@echo ""
	$(SIZE) $@

$(BIN_DIR)/$(PROJECT).bin: $(BIN_DIR)/$(PROJECT).elf
	@$(OBJCOPY) -O binary $< $@

$(BIN_DIR)/$(PROJECT).hex: $(BIN_DIR)/$(PROJECT).elf
	@$(OBJCOPY) -O ihex $< $@

$(BIN_DIR)/$(PROJECT).lst: $(BIN_DIR)/$(PROJECT).elf
	@$(OBJDUMP) -Sdh $< > $@

lst: $(BIN_DIR)/$(PROJECT).lst

size:
	$(SIZE) $(BIN_DIR)/$(PROJECT).elf

DEPS = $(OBJECTS:.o=.d) $(SYS_OBJECTS:.o=.d)
-include $(DEPS)
