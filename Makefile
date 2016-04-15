.PHONY: carthage
carthage:
	rm -r ./Carthage/Build
	carthage build --platform osx

