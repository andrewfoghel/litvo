//
//  TabVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/15/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

var tabBarHeight = CGFloat()

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //color of items in tab bar
        self.tabBar.tintColor = .white
        //color of background of tabbar
        self.tabBar.barTintColor = litvoGreen
        self.tabBar.isTranslucent = false
        
        tabBarHeight = self.tabBar.frame.height
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        //new color for all icons
        for item in self.tabBar.items! {
            if let image = item.image{
                item.image = image.imageColorForTabBar(color: UIColor.black).withRenderingMode(.alwaysOriginal)
            }
        }
        
    }
}

//customize uiimage - icon for tabbar
extension UIImage {
    
    func imageColorForTabBar(color: UIColor) -> UIImage {
        //declare size, UIGraphics is for when you are going to change something
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
