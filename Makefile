.DEFAULT_GOAL := help

help:
		@echo "Please use 'make <target>' where <target> is one of"
		@echo ""
		@echo "  lint        - run the linter"
		@echo "  format      - run the formatter"
		@echo "  test        - run the tests"
		@echo ""
		@echo "Check the Makefile to know exactly what each target is doing."

lint:
	cargo clippy

format:
	cargo fmt

test:
	cargo test