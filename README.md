# Truffaut

A humble tool to help you presenting ideas by writing Swift

![](Screenshots/sample.png)

## Requirements

- **macOS 10.13**, could also work on earlier versions as long as Xcode 9 works
- **Xcode 9**, the embedded `swiftc` will be used to interpret the slides manifest file
- Ruby gem [**rouge**](https://github.com/jneen/rouge), this gem will be used to provide syntax highlighting for source code blocks

## Usage

### Get Truffaut.app

Clone this repo and build the target `Truffaut`.

### Create slides manifest

Create a Swift file:

```sh
$ touch slides.swift
```

Import the supporting module:

```swift
import TruffautSupport
```

Initialize a presentation with pages:

```swift
let presentation = Presentation(pages: [
  Page(title: "Hello World", subtitle: "A Swift Slide"),
])
```

## Manifest file reference

For a full reference of the `TruffautSupport` supporting module, please check [here](Documentations/TruffautSupport-API-Reference.md).

## Examples

For real-life Truffaut slides, please check the [Examples](Examples/).

## Caveats and Known Issues

- The Xcode version selected by `xcode-select` must be the same as the one used to build the application.
  - Otherwise opening slides may fail with errors like this: `slides.swift:1:8: error: cannot load underlying module for 'TruffautSupport'`
  - In Swift 5.1, this issue is likely to be fixed by [Library Evolution](https://github.com/apple/swift-evolution/blob/master/proposals/0260-library-evolution.md).
- Currently the syntax highlighter is assuming ruby is installed at path `/usr/local/bin/ruby` which is usually true if the ruby is intalled with [homebrew](https://brew.sh/).
  - If this is not true for you, you can modify the ruby path in the preference (`⌘ + ,`).
- Export to PDF is not implemented.
