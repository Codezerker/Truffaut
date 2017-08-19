//
//  PageViewController.swift
//  Truffaut
//
//  Created by Yan Li on 17/08/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit
import TruffautSupport

class PageViewController: NSViewController {

    @IBOutlet private weak var visualEffectView: NSVisualEffectView!
    private weak var contentStackView: NSStackView?
    
    var page: Page?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

fileprivate extension PageViewController {
    
    private struct LayoutConstants {
        static let pageMargin: CGFloat = 42
        static let spacing: CGFloat = 16
        static let indentOffset: CGFloat = 32
    }
    
    private func setUpViews() {
        guard let page = page else {
            return
        }
        
        let contentStackView = NSStackView(views: [])
        contentStackView.orientation = .vertical
        contentStackView.spacing = LayoutConstants.spacing
        visualEffectView.addSubview(contentStackView)
        self.contentStackView = contentStackView
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            contentStackView.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor),
            ])
        
        if page.contents != nil {
            layoutPage()
        } else {
            layoutPageAsCover()
        }
    }
    
    private func layoutPageAsCover() {
        guard let page = page,
              let contentStackView = contentStackView else {
            return
        }
        
        contentStackView.alignment = .centerX
        contentStackView.distribution = .gravityAreas
        
        let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
        titleLabel.font = Font.Cover.title
        titleLabel.textColor = TextColor.title
        contentStackView.addView(titleLabel, in: .center)
        
        let subtitleLabel = NSTextField(wrappingLabelWithString: page.subtitle ?? "")
        subtitleLabel.font = Font.Cover.subtitle
        subtitleLabel.textColor = TextColor.subtitle
        contentStackView.addView(subtitleLabel, in: .center)
    }
    
    private func layoutPage() {
        guard let page = page,
              let contents = page.contents,
              let contentStackView = contentStackView else {
            return
        }
        
        contentStackView.edgeInsets = NSEdgeInsets(top: LayoutConstants.pageMargin,
                                                   left: LayoutConstants.pageMargin,
                                                   bottom: LayoutConstants.pageMargin,
                                                   right: LayoutConstants.pageMargin)
        contentStackView.distribution = .gravityAreas
        
        let pageGravity: NSStackView.Gravity
        if let title = page.title {
            contentStackView.alignment = .leading
            let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
            titleLabel.font = Font.Page.title
            titleLabel.textColor = TextColor.title
            contentStackView.addView(titleLabel, in: .top)
            pageGravity = .top
        } else {
            contentStackView.alignment = .centerX
            pageGravity = .center
        }
        
        // FIXME: layout subtitle
        
        func addContent(content: Content, to stackView: NSStackView) {
            switch content {
            case .indent(let nestedContents):
                let indentStackView = NSStackView(views: [])
                indentStackView.orientation = .vertical
                indentStackView.alignment = .leading
                indentStackView.distribution = .gravityAreas
                indentStackView.edgeInsets = NSEdgeInsets(top: 0, left: LayoutConstants.indentOffset, bottom: 0, right: 0)
                for nestedContent in nestedContents {
                    addContent(content: nestedContent, to: indentStackView)
                }
                stackView.addView(indentStackView, in: pageGravity)
            case .text(let text):
                let label = NSTextField(wrappingLabelWithString: text)
                label.font = Font.Page.text
                label.textColor = TextColor.text
                stackView.addView(label, in: pageGravity)
            case .sourceCode(let source):
                let label = NSTextField(wrappingLabelWithString: source)
                label.font = Font.Page.source
                label.textColor = TextColor.source
                stackView.addView(label, in: pageGravity)
            default:
                // FIXME: layout image
                break
            }
        }
        
        for content in contents {
            addContent(content: content, to: contentStackView)
        }
    }
}
