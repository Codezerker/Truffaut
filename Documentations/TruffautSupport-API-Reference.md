# TruffautSupport

Describe your presentation slides with Swift.

## Overview

`TruffautSupport` contains data types for describing presentation slides.

It provides the vocabulary for the manifest file.

## Data Types

### `Presentation`

[View source](../TruffautSupport/Presentation.swift)

The top-level data type that holds all necessary information about the slides.

It is also a crucial part of the manifest file interpreting process, as its designated initializer is responsible for printing out its JSON representation so that the manifest can be passed from the `swiftc` interpreter to `Truffaut.app`.

#### `title`

- Reserved for future use.

#### `authors`

- Reserved for future use.

#### `pages`

- An array of `Page`s that needs to be presented in the slides.

#### `init(title: String = "", authors: [String] = [], pages: [Page])`

- Designated initializer for `Presentation`.
- `title`: optional, reserved for future use, default value is an empty string.
- `authors`: optional, reserved for future use, default value is an empty array of strings.
- `pages`: required, an array of `Page`s that needs to be presented in the slides.

---

### `Page`

[View source](../TruffautSupport/Page.swift)

A `Page` describes what should be displayed in a single slide.

Currently there are two types of pages: **cover** and **normal**.

- A **cover** page is a page that only displayes its `title` and `subtitle`, and all the contents are vertically and horizontally centered.
- A **normal** page is a page that can display a `title` and a tree of `contents`. The title is aligned to the top-left corner.

The detection of page types is implicit: **if `contents` is `nil`** the page will be recognized as a **cover**, otherwise it will be recognized as a `normal` page.

#### `title`

- The title of the page.

#### `subtitle`

- Subtitle of the page.
- This value is ignored if the page is a **normal** page.

#### `contents`

- An array of `Content` to be displayed in the page.
- If this value is `nil`, the page will be recognized as a **cover**, otherwise it will be recognized as a **normal** page.

#### `init(title: String? = nil, subtitle: String? = nil, contents: [Content]? = nil)`

- Designated initializer for `Page`.
- `title`: optional, the title of the page, default value is `nil`.
- `subtitle`: optional, the subtitle of the page, default value is `nil`.
- `contents`: optional, an array of `Content`, default value is `nil`.

---

### `Content`

[View source](../TruffautSupport/Content.swift)

A `Content` describes an entry in the slide.

It can be a text (`.text`), a monospaced text with optional syntax highlighting (`.sourceCode`), or an image (`.image`).

To make it more flexible to layout the entries, it is also possible to wrap contents with indentations (`.indent`). All contents can be wrapped in a `.indent`, including the `.indent` itself.

#### `.title(String)`

- Reserved for future use.

#### `.text(String)`

- A text entry rendered with system font.
- The associated `String` will be used to render the text entry.

#### `.image(String)`

- A image entry.
- The associated `String` will be used as the image's relative file path based on the manifest file's path.

#### `.sourceCode(FileType, String)`

- A text entry rendered with monospaced font.
- The first associated `FileType` value will be used to determine the syntax highlighting type.
- The second associated `String` will be used to render the text entry.

#### `indent([Content])`

- An indent entry to make its content visually indented by one level.
- The associated `Content` array will be indented.

#### `Content.FileType`

A `Content.FileType` will be mapped to [**rouge**](https://github.com/jneen/rouge)'s syntax highlighting lexers.

##### `.plainText`

- The content is plain text, no lexer will be applied (no syntax highlighting).

##### `.swift`

- The content is Swift source code, `Rouge::Lexers::Swift` will be applied.

##### `.shell`

- The content is shell script, `Rouge::Lexers::Shell` will be applied.

##### `.javaScript`

- The content is JavaScript source code, `Rouge::Lexers::Javascript` will be applied.
