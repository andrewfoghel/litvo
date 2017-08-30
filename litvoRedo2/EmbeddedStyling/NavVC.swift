//
//  NavVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/15/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

var navbarHeight = CGFloat()
var navText = String()


class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "Avenir Next", size: width/16)]
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = litvoGreen
        self.navigationBar.isTranslucent = false
        
        navbarHeight = self.navigationBar.frame.height
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
