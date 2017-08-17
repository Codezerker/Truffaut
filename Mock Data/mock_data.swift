import TruffautSupport

let codeSample =
"""
class PageViewController: NSViewController {

    private weak var contentStackView: NSStackView?

    var page: Page?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}
"""

let presentation = Presentation(
   title: "Presentation Title",
   authors: ["Yan Li"],
   pages: [
       // Cover
       Page(title: "Bonjour, Truffaut!", subtitle: "Yan Li @eyeplum"),

       // Simple Text
       Page(contents: [
           .text("Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
           .text("— Someone"),
       ]),

       // Basic Bullet Points
       Page(title: "hello", subtitle: "say hello", contents: [
           .text("hello 1"),
           .text("hello 2"),
           .text("你好 3"),
       ]),

       // Nested Bullet Points
       Page(title: "hello", subtitle: "say hello", contents: [
           .indent([
               .text("Level 1.1"),
               .indent([
                   .text("Level 1.1.1"),
                   .text("Level 1.1.2"),
               ]),
               .text("Level 1.2"),
           ]),
           .indent([
               .text("Level 2.1"),
           ]),
       ]),

       // Source Code
       Page(title: "Source Code", contents: [
           .sourceCode(codeSample),
       ]),

       // Nested Source Code
       Page(title: "Source Code", contents: [
           .text("A simple example:"),
           .indent([
               .sourceCode(codeSample),
           ]),
       ]),

       // Single Image
       Page(contents: [
           .image("images/sample.png"),
       ]),
   ])
