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

## clean: Purge temporary build artifacts and scratchpads
clean:
	@echo "==> [CLEAN] Purging temporary build artifacts..."
	@rm -rf out/ work/ target/
	@echo "    [OK] Scratchpads removed."