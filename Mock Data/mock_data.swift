let slides = Slides(pages: [
	// Cover
	Cover(title: "Testing Swift", bulletPoints: ["Swift Parsing"]),
	
	// Page 1
	Page(title: "Hello 1", bulletPoints: [
			"Point 1.1",
			"Point 1.2",
			"Point 1.3",
			"Point 1.4",
			"Point 1.5",
			]),

	// Page 2
	Page(title: "Hello 2", bulletPoints: [
			"Point 2.1",
			"Point 2.2",
			"Point 2.3",
			"Point 2.4",
			"Point 2.5",
			]),

  // Tests
  Page(title: "中文内容测试", bulletPoints: [
    "Unicode is great",
    "String is hard",
    "中文处理很难",
  ]),
])
