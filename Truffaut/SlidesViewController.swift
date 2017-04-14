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
        return (windowController?.document as? PresentationDocument)?.presentation
    }
    
    fileprivate var fileName: String? {
        return (windowController?.document as? PresentationDocument)?.fileNameWithoutExtension
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
    
    @IBAction func showPreviousPage(_ sender: Any?) {
        show(pageAtIndex: currentPage - 1)
    }
    
    @IBAction func showNextPage(_ sender: Any?) {
        show(pageAtIndex: currentPage + 1)
    }
    
    @IBAction func exportPresentationToPDF(_ sender: Any?) {
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
}

extension SlidesViewController {
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateVisiblePage),
                                               name: PresentationDocument.Notifications.update,
                                               object: nil)
    }
    
    @objc private func updateVisiblePage() {
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
