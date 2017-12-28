# Truffaut

A humble tool to help you presenting ideas by writing Swift

![](Screenshots/sample.png)

## Requirements

- **macOS 10.13**, could also work on earlier versions as long as Xcode 9 works
- **Xcode 9**, the embedded `swiftc` will be used to interpret the slides manifest file
- Ruby gem [**rouge**](https://github.com/jneen/rouge), this gem will be used to provide syntax highlighting for source code blocks

## Usage

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

For a full reference of the `TruffautSupport` supporting module, please check [here](Documentations/TruffaultSupport-Full-Refenrece.md).

For a real-life example of a Truffaut slides, please check [this repo](https://github.com/CocoaHeads-Auckland/wellington-mobile-refresh-2017).

## Known Issues

- Currently the syntax highlighter is assuming ruby is installed at path `/usr/local/bin/ruby` which is usually true if the ruby is intalled with [homebrew](https://brew.sh/). If this is not true for you, you can modify the ruby path [here](Truffaut/Shell.swift#L20). In the future there will be preference settings to make it easier to set paths like this.
- Export to PDF is not implemented.
