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
  
  func exportToPDF(withDataSource dataSource: ExportControllerDataSource) -> PDFDocument {
    let pdfDocument = PDFDocument()
    let numberOfPages = dataSource.numberOfPagesToExport()
    for i in (0..<numberOfPages).reverse() {
      guard
        let pageView = dataSource.viewForPageToExport(atIndex: i),
        let pdfPage = exportViewToPDF(pageView) else {
        continue
      }
      pdfDocument.insertPage(pdfPage, atIndex: 0)
    }
    return pdfDocument
  }
}

private extension ExportController {
  
  private struct Layout {
    
    static let defaultExportContentSize = CGSize(width: 800, height: 600)
  }
  
  private func exportViewToPDF(view: NSView) -> PDFPage? {
    view.frame = NSRect(origin: .zero, size: Layout.defaultExportContentSize)
    view.layoutSubtreeIfNeeded()
    
    let pdfData = view.dataWithPDFInsideRect(view.bounds)
    guard let pdfRep = NSPDFImageRep(data: pdfData) else {
      return nil
    }
    let pdfImage = NSImage(size: view.bounds.size)
    pdfImage.addRepresentation(pdfRep)
    return PDFPage(image: pdfImage)
  }
}
