import TruffautSupport

let presentation = Presentation(
   title: "presentation title",
   authors: ["Yan Li <eyeplum@gmail.com>", "@eyeplum"],
   pages: [
       Page(template: "default",
           title: "hello",
           subtitle: "say hello",
           contents: [
               .bulletPoints([
                   .image("./image/url.png"),
                   .text("hello"),
               ]),
           ]),
   ])
