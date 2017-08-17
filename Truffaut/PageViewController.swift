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

    private weak var contentStackView: NSStackView?
    
    var page: Page?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

fileprivate extension PageViewController {
    
    private struct LayoutConstants {
        static let pageMargin: CGFloat = 32
    }
    
    private func setUpViews() {
        guard let page = page else {
            return
        }
        
        let contentStackView = NSStackView(views: [])
        contentStackView.orientation = .vertical
        view.addSubview(contentStackView)
        self.contentStackView = contentStackView
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
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
        contentStackView.addView(titleLabel, in: .center)
        
        let subtitleLabel = NSTextField(wrappingLabelWithString: page.subtitle ?? "")
        subtitleLabel.font = Font.Cover.subtitle
        contentStackView.addView(subtitleLabel, in: .center)
    }
    
    private func layoutPage() {
        guard let page = page,
              let contentStackView = contentStackView else {
            return
        }
        
        contentStackView.edgeInsets = NSEdgeInsets(top: LayoutConstants.pageMargin,
                                                   left: LayoutConstants.pageMargin,
                                                   bottom: LayoutConstants.pageMargin,
                                                   right: LayoutConstants.pageMargin)
        contentStackView.alignment = .leading
        
        let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
        titleLabel.alignment = .center
        titleLabel.font = Font.Page.title
        contentStackView.addView(titleLabel, in: .top)
        
        // FIXME: layout subtitle
        // FIXME: layout image
        // FIXME: layout indent
        
        
    }
}
