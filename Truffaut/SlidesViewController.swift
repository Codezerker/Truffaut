//
//  SlidesViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa
import TSMarkdownParser

class SlidesViewController: NSViewController {
  
  @IBOutlet weak var visualEffectView: NSVisualEffectView!
  
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
    visualEffectView.material = .UltraDark
    
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
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(updateVisiblePage),
      name: Document.Notifications.update,
      object: nil)
  }
  
  @objc private func showPrevious() {
    show(pageAtIndex: currentPage - 1)
  }
  
  @objc private func showNext() {
    show(pageAtIndex: currentPage + 1)
  }
  
  @objc private func updateVisiblePage() {
    print(#function)
    
    guard let page = pages?[currentPage],
          let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier],
          let currentPageViewController = currentPageViewController else {
      return
    }
    
    template.setPageTitleForViewController(
      currentPageViewController,
      withTitle: page.title,
      bulletPoints: page.bulletPoints)
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
    
    let pageViewController = template.createPageViewController()
    
    template.setPageTitleForViewController(
      pageViewController,
      withTitle: page.title,
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

    let moveInAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
    moveInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    moveInAnimation.fromValue = NSValue(CGPoint: isMovingForward ? AnimationConstants.scaleZoomOut : AnimationConstants.scaleZoomIn)
    moveInAnimation.toValue = NSValue(CGPoint: AnimationConstants.scaleNormal)
    
    let moveOutAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
    moveOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    moveOutAnimation.toValue = NSValue(CGPoint: isMovingForward ? AnimationConstants.scaleZoomIn : AnimationConstants.scaleZoomOut)

    guard let currentLayer = currentPageViewController?.view.layer,
          let insertingLayer = pageViewController.view.layer else {
      animationCompletion()
      return
    }
    
    currentLayer.pop_addAnimation(fadeOutAnimation, forKey: "fade_out")
    currentLayer.pop_addAnimation(moveOutAnimation, forKey: "zoom_in")
    insertingLayer.pop_addAnimation(fadeInAnimation, forKey: "fade_in")
    insertingLayer.pop_addAnimation(moveInAnimation, forKey: "zoom_out")
  }
  
}
