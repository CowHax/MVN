include config/config.mk
include color.mk
include cco.mk
default: all

BUILD_DIR := ./build
SRC_DIRS := ./src
PRINT = printf

# Find all the C files we want to compile
SRCS := $(shell find $(SRC_DIRS) -name '*.c')

# String substitution for every C file.
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

ifeq ($(CC),cproc)
	OPTFLAGS += $(cproc)
else ifeq ($(CC),gcc)
	OPTFLAGS += $(gcc)
else ifeq ($(CC),clang)
	OPTFLAGS = $(clang)
endif

INC_FLAGS := $(addprefix -I,$(INC_DIRS))
CFLAGS = $(STDFLAGS) $(OPTFLAGS) $(WARNINGFLAGS) ${INC_FLAGS}

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@$(CC) $(STATIC) $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all clean
clean:
	@rm -r $(BUILD_DIR)

test: all
	@$(BUILD_DIR)/$(TARGET_EXEC)

all: $(BUILD_DIR)/$(TARGET_EXEC)
	@$(PRINT) "$(YELLOW)____________________________________________________$(WHITE)\n"
	@$(PRINT) "$(YELLOW)|                                                  |$(WHITE)\n"
	@$(PRINT) "$(YELLOW)|                 $(FLASH)Compile Settings$(WHITE)                 $(YELLOW)|$(WHITE)\n"
	@$(PRINT) "$(YELLOW)|__________________________________________________|$(WHITE)\n"
	@$(PRINT) "$(RED)Compiler:      $(PURPLE)$(CC)$(WHITE)\n"
	@$(PRINT) "$(RED)STD:           $(PURPLE)$(STDFLAGS)$(WHITE)\n"
	@$(PRINT) "$(RED)Optimizations: $(PURPLE)$(OPTFLAGS)$(WHITE)\n"

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)