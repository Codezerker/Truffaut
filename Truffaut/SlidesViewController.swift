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
    fileprivate weak var currentPageViewController: PageViewController?
    
    fileprivate var presentation: Presentation? {
        return (windowController?.document as? PresentationDocument)?.presentation
    }
    
    fileprivate var fileName: String? {
        return (windowController?.document as? PresentationDocument)?.fileNameWithoutExtension
    }
    
    fileprivate var documentFolderURL: URL? {
        guard let document = windowController?.document,
              let documentURL = document.fileURL,
              let folderURL = documentURL?.deletingLastPathComponent() else {
            return nil
        }
        return folderURL
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reload(nil)
    }
}

extension SlidesViewController {
    
    @IBAction func showPreviousPage(_ sender: Any?) {
        show(pageAtIndex: currentPage - 1)
    }
    
    @IBAction func showNextPage(_ sender: Any?) {
        show(pageAtIndex: currentPage + 1)
    }
    
    @IBAction func reload(_ sender: Any?) {
        (windowController?.document as? PresentationDocument)?.reload { [weak self] in
            guard let validSelf = self else {
                return
            }
            validSelf.show(pageAtIndex: validSelf.currentPage)
        }
    }
    
    // FIXME:
    // because the document view for the page view is flipped, the PDF image is messed up.
    // Disable export for now.
    /*
    @IBAction func exportPresentationToPDF(_ sender: Any?) {
        guard let fileName = self.fileName else {
            return
        }
        let openPanel = NSSavePanel()
        openPanel.allowedFileTypes = [ExportController.ExportingType.pdf.fileExtension]
        openPanel.allowsOtherFileTypes = false
        openPanel.nameFieldStringValue = fileName
        openPanel.begin { result in
            guard result == NSApplication.ModalResponse.OK,
                  let exportURL = openPanel.url else {
                return
            }
            let pdf = ExportController().exportToPDF(withDataSource: self)
            pdf.write(to: exportURL)
        }
    }
    */
}

extension SlidesViewController: ExportControllerDataSource {
    
    func numberOfPagesToExport() -> Int {
        guard let pages = presentation?.pages else {
            return 0
        }
        return pages.count
    }
    
    private struct ExportLayout {
        static let width: CGFloat = 1280
        static let height: CGFloat = 720
    }
    
    func viewForPageToExport(atIndex index: Int) -> NSView? {
        guard let page = presentation?.pages[index],
              let documentFolderURL = documentFolderURL else {
            return nil
        }
        let pageViewController = PageViewController(page: page, imageBaseURL: documentFolderURL, isExporting: true)
        return pageViewController.view
    }
}

extension SlidesViewController {
    
    fileprivate func show(pageAtIndex index: Int) {
        guard let pages = presentation?.pages,
              let documentFolderURL = documentFolderURL,
              index >= 0 && index < pages.count else {
            return
        }
        
        currentPage = index
        
        let pageViewController = PageViewController(page: pages[index], imageBaseURL: documentFolderURL)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        
        self.currentPageViewController?.removeFromParent()
        self.currentPageViewController?.view.removeFromSuperview()
        
        self.currentPage = index
        self.currentPageViewController = pageViewController
    }
}
