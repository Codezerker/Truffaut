import TruffautSupport

let presentation = Presentation(
   title: "presentation title",
   authors: ["Yan Li <eyeplum@gmail.com>", "@eyeplum"],
   pages: [
       // Cover
       Page(title: "Bonjour, Truffaut!"),

       // Simple Text
       Page(contents: [
           .text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
       ]),

       // Basic Bullet Points
       Page(title: "hello", subtitle: "say hello", contents: [
           .bulletPoints([
               .text("hello 1"),
               .text("hello 2"),
               .text("你好 3"),
           ]),
       ]),

       // Nested Bullet Points
       Page(title: "hello", subtitle: "say hello", contents: [
           .bulletPoints([
               .text("Level 1.1"),
               .bulletPoints([
                   .text("Level 1.1.1"),
                   .text("Level 1.1.2"),
               ]),
               .text("Level 1.2"),
           ]),
           .bulletPoints([
               .text("Level 2.1"),
           ]),
       ]),

       // Single Image
       Page(contents: [
           .image("images/sample.png"),
       ]),

       // Source Code
       Page(title: "Source Code Pro", contents: [
           .sourceCode("mock_data.swift"),
       ])
   ])
