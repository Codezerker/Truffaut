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
  
  private var animating = false
  
  private var pages: [Slides.Page]? {
    return (windowController?.document as? Document)?.slides?.pages
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.wantsLayer = true
    
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
    
    guard !animating else {
      return
    }
    animating = true
    
    let page = pages[index]
    
    guard let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier] else {
      return
    }
    
    let pageViewController = template.createPageViewControllerWithPageTitle(
      page.title,
      bulletPoints: page.bulletPoints)
    pageViewController.view.wantsLayer = true
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

    let animationCompletion: dispatch_block_t = {
      self.currentPageViewController?.removeFromParentViewController()
      self.currentPageViewController?.view.removeFromSuperview()
      
      self.currentPage = index
      self.currentPageViewController = pageViewController
      
      self.animating = false
    }
    
    guard let currentView = currentPageViewController?.view else {
      view.addSubview(pageViewController.view)
      view.addConstraints(pageViewController.view.fullEdgeLayoutConstrains)
      addChildViewController(pageViewController)
      animationCompletion()
      
      return
    }
    
    let isMovingForward = (index > currentPage)
    view.addSubview(pageViewController.view, positioned: isMovingForward ? .Below : .Above, relativeTo: currentView)
    view.addConstraints(pageViewController.view.fullEdgeLayoutConstrains)
    addChildViewController(pageViewController)
    
    let fadeInAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    fadeInAnimation.fromValue = 0
    fadeInAnimation.toValue = 1
    fadeInAnimation.completionBlock = { _ in
      animationCompletion()
    }

    let fadeOutAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    fadeOutAnimation.toValue = 0

    let zoomInFactor = isMovingForward ? 0.8 : 1.2
    let zoomInAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
    zoomInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    zoomInAnimation.fromValue = NSValue(CGPoint: CGPoint(x: zoomInFactor, y: zoomInFactor))
    zoomInAnimation.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
    
    let zoomOutFactor = isMovingForward ? 1.2 : 0.8
    let zoomOutAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
    zoomOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    zoomOutAnimation.toValue = NSValue(CGPoint: CGPoint(x: zoomOutFactor, y: zoomOutFactor))

    guard let currentLayer = currentPageViewController?.view.layer,
              insertingLayer = pageViewController.view.layer else {
      animationCompletion()
      return
    }
    
    currentLayer.pop_addAnimation(fadeOutAnimation, forKey: "fade_out")
    currentLayer.pop_addAnimation(zoomOutAnimation, forKey: "zoom_in")
    insertingLayer.pop_addAnimation(fadeInAnimation, forKey: "fade_in")
    insertingLayer.pop_addAnimation(zoomInAnimation, forKey: "zoom_out")
  }
  
}
