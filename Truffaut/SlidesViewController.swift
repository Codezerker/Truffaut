//
//  SlidesViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa
import TruffautSupport

class SlidesViewController: NSViewController {
    
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    
    weak var windowController: NSWindowController?
    
    fileprivate var currentPage = 0
    fileprivate weak var currentPageViewController: NSViewController?
    
    fileprivate var presentation: Presentation? {
        return (windowController?.document as? Document)?.presentation
    }
    
    fileprivate var fileName: String? {
        return (windowController?.document as? Document)?.fileNameWithoutExtension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        
        visualEffectView.material = .light
        visualEffectView.isHidden = true
        
        registerNotifications()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        show(pageAtIndex: currentPage)
    }
    
}

extension SlidesViewController {
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showPrevious),
            name: NSNotification.Name(rawValue: MenuActionDispatcher.ActionType.Previous.notificationName),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNext),
            name: NSNotification.Name(rawValue: MenuActionDispatcher.ActionType.Next.notificationName),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateVisiblePage),
            name: NSNotification.Name(rawValue: Document.Notifications.update),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(export),
            name: NSNotification.Name(rawValue: MenuActionDispatcher.ActionType.Export.notificationName),
            object: nil)
    }
    
    @objc private func showPrevious() {
        show(pageAtIndex: currentPage - 1)
    }
    
    @objc private func showNext() {
        show(pageAtIndex: currentPage + 1)
    }
    
    @objc private func export() {
        guard let fileName = self.fileName else {
            return
        }
        let openPanel = NSSavePanel()
        openPanel.allowedFileTypes = [ExportController.ExportingType.pdf.fileExtension]
        openPanel.allowsOtherFileTypes = false
        openPanel.nameFieldStringValue = fileName
        openPanel.begin { result in
            guard
                result == NSFileHandlingPanelOKButton,
                let exportURL = openPanel.url else {
                    return
            }
            let pdf = ExportController().exportToPDF(withDataSource: self)
            pdf.write(to: exportURL)
        }
    }
    
    @objc private func updateVisiblePage() {
        print(#function)
        
//        guard let page = pages?[currentPage],
//            let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier],
//            let currentPageViewController = currentPageViewController else {
//                return
//        }
//        
//        template.setPageTitleFor(
//            currentPageViewController,
//            withTitle: page.title,
//            bulletPoints: page.bulletPoints)
    }
    
}

extension SlidesViewController: ExportControllerDataSource {
    
    func numberOfPagesToExport() -> Int {
        return 0
        
//        guard let pages = pages else {
//            return 0
//        }
//        return pages.count
    }
    
    func viewForPageToExport(atIndex index: Int) -> NSView? {
        return nil
        
//        guard let page = pages?[index],
//              let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier] else {
//            return nil
//        }
//        let pageViewController = template.createPageViewController()
//        template.setPageTitleFor(pageViewController,
//                                 withTitle: page.title,
//                                 bulletPoints: page.bulletPoints)
//        return pageViewController.view
    }
}

extension SlidesViewController {
    
    struct AnimationConstants {
        static let scaleFactorZoomIn  = 1.2
        static let scaleFactorZoomOut = 0.8
        
        static let scaleZoomIn  = CGPoint(x: scaleFactorZoomIn, y: scaleFactorZoomIn)
        static let scaleZoomOut = CGPoint(x: scaleFactorZoomOut, y: scaleFactorZoomOut)
        static let scaleNormal  = CGPoint(x: 1, y: 1)
    }
    
    fileprivate func show(pageAtIndex index: Int) {
//        guard let pages = pages else {
//            return
//        }
//        
//        guard index >= 0 && index < pages.count else {
//            return
//        }
//        
//        let page = pages[index]
//        
//        guard let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier] else {
//            return
//        }
//        
//        let pageViewController = template.createPageViewController()
//        
//        template.setPageTitleFor(
//            pageViewController,
//            withTitle: page.title,
//            bulletPoints: page.bulletPoints)
//        
//        pageViewController.view.wantsLayer = true
//        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(pageViewController.view)
//        view.addConstraints(pageViewController.view.fullEdgeLayoutConstrains)
//        addChildViewController(pageViewController)
//        
//        self.currentPageViewController?.removeFromParentViewController()
//        self.currentPageViewController?.view.removeFromSuperview()
//        
//        self.currentPage = index
//        self.currentPageViewController = pageViewController
    }
    
}
