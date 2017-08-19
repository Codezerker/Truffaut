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
    
    weak var windowController: NSWindowController?
    
    fileprivate var currentPage = 0
    fileprivate weak var currentPageViewController: NSViewController?
    
    fileprivate var presentation: Presentation? {
        return (windowController?.document as? PresentationDocument)?.presentation
    }
    
    fileprivate var fileName: String? {
        return (windowController?.document as? PresentationDocument)?.fileNameWithoutExtension
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
                result.rawValue == NSFileHandlingPanelOKButton,
                let exportURL = openPanel.url else {
                    return
            }
            let pdf = ExportController().exportToPDF(withDataSource: self)
            pdf.write(to: exportURL)
        }
    }
}

extension SlidesViewController: ExportControllerDataSource {
    
    func numberOfPagesToExport() -> Int {
        guard let pages = presentation?.pages else {
            return 0
        }
        return pages.count
    }
    
    func viewForPageToExport(atIndex index: Int) -> NSView? {
        // FIXME: implement PDF view rendering
        return nil
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
        guard let pages = presentation?.pages,
              index >= 0 && index < pages.count else {
            return
        }
        
        currentPage = index
        
        let pageViewController = PageViewController()
        pageViewController.page = pages[index]
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        
        self.currentPageViewController?.removeFromParentViewController()
        self.currentPageViewController?.view.removeFromSuperview()
        
        self.currentPage = index
        self.currentPageViewController = pageViewController
    }
}
