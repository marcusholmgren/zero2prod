.DEFAULT_GOAL := help
.PHONY : all

help:
		@echo "Please use 'make <target>' where <target> is one of"
		@echo ""
		@echo "  lint        - run the linter"
		@echo "  format      - format all files"
		@echo "  test        - run all tests"
		@echo "  test-health - run only health test endpoint test"
		@echo "  audit       - run security vulnerabilities scan"
		@echo ""
		@echo "Check the Makefile to know exactly what each target is doing."

lint:
	cargo clippy

format:
	cargo fmt

test:
	cargo test

test-health:
	TEST_LOG=true cargo test health_check_works

# Requires installation of: cargo install cargo-audit
audit:
	cargo audit