# Truffaut

A humble tool to help you presenting ideas by writing Swift.

## Requirements

- **macOS 10.13**, could also work on earlier versions as long as Xcode 9 works
- **Xcode 9**, the embeded `swiftc` will be used to interpret the slides manifest file
- ruby gem [**rouge**](https://github.com/jneen/rouge), this gem will be used to provide syntax highlighting for source code blocks

## Usage

First, create a Swift file:

```sh
$ touch slides.swift
```

Import the supporting module:

```swift
import TruffautSupport
```

Then initialize a presentation with pages:

```swift
let presentation = Presentation(pages: [
  Page(title: "Hello World", subtitle: "A Swift Slide"),
])
```

For full reference of the supporting library, please check [here](Documentations/TruffaultSupport-Full-Refenrece.md).

For an example of the slides, please check [this repo](https://github.com/CocoaHeads-Auckland/wellington-mobile-refresh-2017).

## Known Issues

- Currently the syntax highlighter is assuming ruby is installed at path `/usr/local/bin/ruby` which is usually true if the ruby is intalled with [homebrew](https://brew.sh/). If this is not true for you, you can modify the ruby path [here](Truffaut/Shell.swift). In the future there will be preference settings to make it easier to set paths like this.
