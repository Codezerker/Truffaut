.PHONY: carthage
carthage:
	rm -r ./Carthage/Build
	carthage update --no-use-binaries --platform osx

