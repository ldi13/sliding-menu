//
//  CenterViewController.swift
//  SidePanel
//
//  Created by Lorenzo Di Vita on 17/07/2015.
//  Copyright (c) 2015 ldi. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate: class
{
    func toggleLeftPanel()
    func toggleRightPanel()
    func addLeftPanelViewController()
    func addRightPanelViewController()
    func animateLeftPanel(shouldExpand shouldExpand: Bool)
    func animateRightPanel(shouldExpand shouldExpand: Bool)
}

class CenterViewController: UIViewController
{
    // MARK: - Properties
    
    weak var delegate: CenterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func leftBarButtonItemWasPressed(sender: UIBarButtonItem)
    {
        print("leftBarButtonItemWasPressed")
        self.delegate.toggleLeftPanel()
    }
}
