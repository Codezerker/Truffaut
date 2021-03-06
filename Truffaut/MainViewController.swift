//
//  ViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var pathControl: NSPathControl!
    
    weak var windowController: MainWindowController?
    
    private lazy var slidesWindowController: SlidesWindowController = {
        return SlidesWindowController.loadFromStoryboard()
    }()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let fileURL = (windowController?.document as? PresentationDocument)?.fileURL {
            pathControl.url = fileURL
        }
    }
    
    @IBAction func showSlides(_ sender: AnyObject?) {
        windowController?.document?.addWindowController(slidesWindowController)
        slidesWindowController.showWindow(nil)
        
        windowController?.window?.orderOut(nil)
    }
}
