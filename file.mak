.PHONY: help sign package clean install

APP_NAME := ipainstaller
APP_DIR := app
OUTPUT_DIR := output
PAYLOAD_DIR := $(OUTPUT_DIR)/Payload
IPA_FILE := $(OUTPUT_DIR)/$(APP_NAME).ipa

# Colors for output
GREEN := \033[0;32m
BLUE := \033[0;34m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)=== ipainstaller - iOS IPA Signing Tool ===$(NC)"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  $(GREEN)sign$(NC)       - Sign the app with entitlements"
	@echo "  $(GREEN)package$(NC)    - Create IPA file from signed app"
	@echo "  $(GREEN)all$(NC)        - Sign and package (complete build)"
	@echo "  $(GREEN)clean$(NC)      - Remove output files"
	@echo "  $(GREEN)help$(NC)       - Show this help message"
	@echo ""

sign:
	@echo "$(BLUE)[*] Starting app signing process...$(NC)"
	@if [ ! -d "$(APP_DIR)" ]; then \
		echo "$(RED)Error: $(APP_DIR) directory not found!$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)[+] App found at $(APP_DIR)$(NC)"
	@echo "$(BLUE)[*] Signing with entitlements...$(NC)"
	# If you're using esign or codesign, place command here
	@echo "$(GREEN)[+] Signing complete!$(NC)"

package: sign
	@echo "$(BLUE)[*] Creating IPA package...$(NC)"
	@mkdir -p "$(PAYLOAD_DIR)"
	@cp -r "$(APP_DIR)" "$(PAYLOAD_DIR)/"
	@echo "$(BLUE)[*] Compressing into IPA...$(NC)"
	@cd "$(OUTPUT_DIR)" && zip -r -q "$(APP_NAME).ipa" Payload/
	@echo "$(GREEN)[+] IPA created: $(IPA_FILE)$(NC)"

all: clean sign package
	@echo "$(GREEN)[✓] Build complete! IPA ready at $(IPA_FILE)$(NC)"

clean:
	@echo "$(BLUE)[*] Cleaning output files...$(NC)"
	@rm -rf "$(OUTPUT_DIR)"
	@echo "$(GREEN)[+] Clean complete!$(NC)"

install: package
	@echo "$(BLUE)[*] Installing IPA...$(NC)"
	@echo "Use a tool like Sideloadly, AltStore, or esign to install:"
	@echo "$(GREEN)  esign install $(IPA_FILE)$(NC)"

.PHONY: all
