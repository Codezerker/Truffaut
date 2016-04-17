//
//  SlidesViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class SlidesViewController: NSViewController {
  
  weak var windowController: NSWindowController?
  
  private var currentPage = 0
  private weak var currentPageViewController: NSViewController?
  
  private var pages: [Slides.Page]? {
    return (windowController?.document as? Document)?.slides?.pages
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerNotifications()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    show(pageAtIndex: currentPage)
  }
  
}

extension SlidesViewController {
  
  private func registerNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(showPrevious),
      name: MenuActionDispatcher.ActionType.Previous.notificationName,
      object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(showNext),
      name: MenuActionDispatcher.ActionType.Next.notificationName,
      object: nil)
  }
  
  @objc private func showPrevious() {
    show(pageAtIndex: currentPage - 1)
  }
  
  @objc private func showNext() {
    show(pageAtIndex: currentPage + 1)
  }
  
}

extension SlidesViewController {
  
  private func show(pageAtIndex index: Int) {
    guard let pages = pages else {
      return
    }
    
    guard index >= 0 && index < pages.count else {
      return
    }
    
    let page = pages[index]
    
    guard let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier] else {
        return
    }
    
    currentPageViewController?.removeFromParentViewController()
    currentPageViewController?.view.removeFromSuperview()
    
    let pageViewController = template.createPageViewControllerWithPageTitle(
      page.title,
      bulletPoints: page.bulletPoints)
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pageViewController.view)
    view.addConstraints(pageViewController.view.fullEdgeLayoutConstrains)
    addChildViewController(pageViewController)
    
    currentPage = index
    currentPageViewController = pageViewController
  }
  
}
