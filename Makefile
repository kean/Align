.PHONY: help docs preview-docs clean-docs test

help:
	@echo "Targets:"
	@echo "  docs          Build self-hostable DocC site into .build/docs"
	@echo "  preview-docs  Serve docs locally with docc preview"
	@echo "  clean-docs    Remove generated docs and DocC derived data"
	@echo "  test          Run the test suite via swift test"
	@echo ""
	@echo "Overrides for 'docs' (env vars):"
	@echo "  HOSTING_BASE_PATH=Align    URL prefix; set to '' for domain root"
	@echo "  OUTPUT_DIR=.build/docs     Output directory"
	@echo "  DESTINATION='generic/platform=iOS'  xcodebuild destination"

docs:
	@./.scripts/build-docs.sh

preview-docs:
	@xcodebuild -scheme Align -destination 'generic/platform=iOS' \
		-derivedDataPath .build/docc-derived-data \
		docbuild OTHER_DOCC_FLAGS="--preview"

clean-docs:
	rm -rf .build/docs .build/docc-derived-data

test:
	swift test
