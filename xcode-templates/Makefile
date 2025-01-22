# Makefile to install MVVMC Xcode Templates

# Variables
SRC_DIR := Templates
DEST_DIR := ~/Library/Developer/Xcode/Templates/MVVMC

# Expand the tilde to the home directory
DEST_DIR_PATH := $(shell echo $(DEST_DIR))

.PHONY: install clean help

# Default target
all: help

# Install target
install:
	@echo "Installing MVVMC Templates..."
	@mkdir -p "$(DEST_DIR_PATH)"
	@cp -R "$(SRC_DIR)/." "$(DEST_DIR_PATH)/"
	@echo "Templates installed to $(DEST_DIR_PATH)"

# Clean target (optional)
clean:
	@echo "Cleaning installed templates..."
	@rm -rf "$(DEST_DIR_PATH)"
	@echo "Installed templates removed from $(DEST_DIR_PATH)"

# Help target
help:
	@echo "Makefile Commands:"
	@echo "  make install   Install MVVMC Templates to Xcode Templates directory."
	@echo "  make clean     Remove installed MVVMC Templates from Xcode Templates directory."
	@echo "  make help      Show this help message."
