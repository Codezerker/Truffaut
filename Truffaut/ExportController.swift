//
//  ExportController.swift
//  Truffaut
//
//  Created by Yan Li on 23/07/2016.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation
import Quartz

protocol ExportControllerDataSource {
    
    func numberOfPagesToExport() -> Int
    func viewForPageToExport(atIndex index: Int) -> NSView?
}

struct ExportController {
    
    enum ExportingType {
        case pdf
        
        var fileExtension: String {
            switch self {
            case .pdf:
                return "pdf"
            }
        }
    }
    
    func exportToPDF(withDataSource dataSource: ExportControllerDataSource) -> PDFDocument {
        let pdfDocument = PDFDocument()
        let numberOfPages = dataSource.numberOfPagesToExport()
        for i in (0..<numberOfPages).reversed() {
            guard
                let pageView = dataSource.viewForPageToExport(atIndex: i),
                let pdfPage = exportViewToPDF(view: pageView) else {
                    continue
            }
            pdfDocument.insert(pdfPage, at: 0)
        }
        return pdfDocument
    }
}

fileprivate extension ExportController {
    
    fileprivate struct Layout {
        
        static let defaultExportContentSize = CGSize(width: 1440, height: 900)
    }
    
    fileprivate func exportViewToPDF(view: NSView) -> PDFPage? {
        view.frame = NSRect(origin: .zero, size: Layout.defaultExportContentSize)
        view.layoutSubtreeIfNeeded()
        
        let pdfData = view.dataWithPDF(inside: view.bounds)
        guard let pdfRep = NSPDFImageRep(data: pdfData) else {
            return nil
        }
        let pdfImage = NSImage(size: view.bounds.size)
        pdfImage.addRepresentation(pdfRep)
        return PDFPage(image: pdfImage)
    }
}
