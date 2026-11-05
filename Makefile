# IPLS - Engineering Pre-flight Checks & Automation Interface
SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -c

.PHONY: all check check-shell check-docs check-rust clean help

# Default target executed when running 'make'
all: check

## help: Display available targets and descriptions
help:
	@echo "IPLS Development Automation Interface"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':'

## check: Run all pre-flight quality gates (Shell + Docs + Rust)
check: check-shell check-docs check-rust
	@echo "==> [PASS] All pre-flight checks completed with zero warnings."

## check-shell: Static analysis of shell scripts, PKGBUILDs, and hooks via shellcheck
check-shell:
	@echo "==> [SHELL] Checking scripts, PKGBUILDs, and Archiso hooks with shellcheck..."
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "    [ERROR] shellcheck is not installed. Run 'sudo pacman -S shellcheck'."; \
		exit 1; \
	fi
	@FILES=$$(find . -type f \( -name "*.sh" -o -name "PKGBUILD" -o -name "*.hook" \) \
		-not -path "*/.*" \
		-not -path "./work/*" \
		-not -path "./out/*" \
		-not -path "./target/*"); \
	if [ -n "$$FILES" ]; then \
		echo "$$FILES" | xargs shellcheck --severity=style || exit 1; \
		echo "    [OK] Shell verification passed without warnings."; \
	else \
		echo "    [SKIP] No shell scripts or PKGBUILD recipes found."; \
	fi

## check-docs: Validate Markdown documentation formatting via markdownlint
check-docs:
	@echo "==> [DOCS] Validating documentation files with markdownlint..."
	@if ! command -v markdownlint >/dev/null 2>&1; then \
		echo "    [ERROR] markdownlint is not installed."; \
		echo "            Install via: 'sudo pacman -S npm && sudo npm install -g markdownlint-cli'"; \
		exit 1; \
	fi
	@FILES=$$(find . -type f -name "*.md" \
		-not -path "*/.*" \
		-not -path "./work/*" \
		-not -path "./out/*" \
		-not -path "./target/*"); \
	if [ -n "$$FILES" ]; then \
		echo "$$FILES" | xargs markdownlint --config .markdownlint.json || exit 1; \
		echo "    [OK] Markdown documentation compliant."; \
	else \
		echo "    [SKIP] No Markdown documentation files found."; \
	fi

## check-rust: Enforce formatting, strict clippy lints, and test suites
check-rust:
	@echo "==> [RUST] Inspecting Rust modules..."
	@if [ -f "Cargo.toml" ] || find . -maxdepth 2 -name "Cargo.toml" | grep -q .; then \
		if ! command -v cargo >/dev/null 2>&1; then \
			echo "    [ERROR] cargo is not installed. Run 'sudo pacman -S rust'."; \
			exit 1; \
		fi; \
		echo "    -> Running cargo fmt check..."; \
		cargo fmt --check || exit 1; \
		echo "    -> Running cargo clippy (-D warnings)..."; \
		cargo clippy -- -D warnings || exit 1; \
		echo "    -> Running unit tests..."; \
		cargo test || exit 1; \
		echo "    [OK] Rust workspace compliant."; \
	else \
		echo "    [SKIP] No Cargo workspace detected yet. Skipping Rust verification."; \
	fi

# Dynamic rule to tag and push a version directly (e.g., make v1.0.0)
v%:
	@echo "[+] Checking Git repository status..."
	@git diff --quiet && git diff --cached --quiet || (echo "[-] Error: You have uncommitted or staged changes." && exit 1)
	@echo "[+] Creating annotated tag $*..."
	git tag -a $@ -m "IPLS Release $*"
	@echo "[+] Pushing tag $* to remote repository..."
	git push origin $@
	@echo "[+] Success: Tag $@ pushed. GitHub Actions CI/CD will generate the release!"

# Secure rule to flash the ISO onto a USB drive
# Usage: make flash USB=/dev/sdX
flash:
	@if [ -z "$(USB)" ]; then \
		echo "[-] Error: USB variable is not defined."; \
		echo "    Usage example: make flash USB=/dev/sdb"; \
		exit 1; \
	fi
	@if [ ! -b "$(USB)" ]; then \
		echo "[-] Error: Device $(USB) does not exist or is not a valid block device."; \
		exit 1; \
	fi
	@echo "[!] WARNING: You are about to completely overwrite the device $(USB)!"
	@lsblk $(USB)
	@read -p "Are you absolutely sure you want to continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		iso_file=$$(ls out/*.iso 2>/dev/null | head -n 1); \
		if [ -z "$$iso_file" ]; then \
			echo "[-] Error: No ISO found in the out/ directory. Run 'make iso' first."; \
			exit 1; \
		fi; \
		echo "[+] Flashing image $$iso_file to $(USB)..."; \
		sudo dd if=$$iso_file of=$(USB) bs=4M status=progress oflag=sync; \
		sync; \
		echo "[+] Flashing completed and synchronized successfully!"; \
	else \
		echo "[-] Operation canceled."; \
	fi

## clean: Purge temporary build artifacts and scratchpads
clean:
	@echo "==> [CLEAN] Purging temporary build artifacts..."
	@rm -rf out/ work/ target/
	@echo "    [OK] Scratchpads removed."

