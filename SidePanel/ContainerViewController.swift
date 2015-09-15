//
//  ContainerViewController.swift
//  SidePanel
//
//  Created by Lorenzo Di Vita on 17/07/2015.
//  Copyright (c) 2015 ldi. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController
{
    // MARK: - Constants
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    // MARK: - Enum
    
    enum SlideOutState
    {
        case BothCollapsed
        case LeftPanelExpanded
        case RightPanelExpanded
    }
    
    
    // MARK: - Properties
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    var currentState: SlideOutState = .BothCollapsed
    var leftViewController: SidePanelViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Deal with center view controller and navigation
        self.centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("centerViewController") as! CenterViewController
        self.centerViewController.delegate = self
        self.centerNavigationController = UINavigationController(rootViewController: self.centerViewController)
        
        // Define center navigation view controller as child view into ContainerViewController
        self.view.addSubview(self.centerNavigationController.view)
        self.addChildViewController(self.centerNavigationController)
        self.centerNavigationController.didMoveToParentViewController(self)
        
        // Pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController)
    {
        sidePanelController.view.frame = CGRectMake(-200, 0, 200, sidePanelController.view.frame.height)
        
        self.view.insertSubview(sidePanelController.view, aboveSubview: self.view)
        self.addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.leftViewController?.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer)
    {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(self.view).x > 0)
        
        switch(recognizer.state)
        {
            case UIGestureRecognizerState.Began:
                if (currentState == .BothCollapsed)
                {
                    if (gestureIsDraggingFromLeftToRight) {
                        addLeftPanelViewController()
                    }
                }
            
            case UIGestureRecognizerState.Changed:
                if let leftViewController = self.leftViewController
                {
                    leftViewController.view.center.x = min(leftViewController.view.center.x + recognizer.translationInView(view).x, leftViewController.view.frame.width / 2)
                    recognizer.setTranslation(CGPointZero, inView: self.leftViewController!.view)
                }
            
            case UIGestureRecognizerState.Ended:
                if let leftViewController = self.leftViewController {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    animateLeftPanel(shouldExpand: gestureIsDraggingFromLeftToRight)
                }
            
            default:
                break
        }
    }
}

extension ContainerViewController : CenterViewControllerDelegate
{
    func toggleLeftPanel()
    {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            self.addLeftPanelViewController()
        }
        
        self.animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
    }
    
    func addLeftPanelViewController()
    {
        if (self.leftViewController == nil)
        {
            self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sidePanelViewController") as? SidePanelViewController
            self.addChildSidePanelController(self.leftViewController!)
        }
    }
    
    func addRightPanelViewController() {
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool)
    {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateLeftPanelXPosition(targetPosition: 0)
        }
        
        else {
            animateLeftPanelXPosition(targetPosition: -200) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
        
    }
    
    func animateRightPanel(shouldExpand shouldExpand: Bool) {
    }
}
