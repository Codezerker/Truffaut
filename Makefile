.PHONY: carthage
carthage:
	rm -rf ./Carthage/Build
	carthage update --no-use-binaries --platform osx --verbose

