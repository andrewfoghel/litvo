//
//  AppDelegate.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/13/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleMaps
import GooglePlaces

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var errorIsShowing = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyArJH5nakEjsUQNXHM3sl823p_c-5I6Cig")
        GMSPlacesClient.provideAPIKey("AIzaSyArJH5nakEjsUQNXHM3sl823p_c-5I6Cig")
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //facebook
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    
    func errorView(message: String, color: UIColor){
        if !errorIsShowing{
            errorIsShowing = true
            
            //red background
            let errorViewHeight = self.window!.bounds.height/14.2
            let errorViewY = 0 - errorViewHeight
            
            let errorView = UIView()
            errorView.frame = CGRect(x: 0, y: errorViewY, width: self.window!.bounds.width, height: errorViewHeight)
            errorView.backgroundColor = color
            self.window!.addSubview(errorView)
            
            let errorLabelWidth = errorView.bounds.width
            let errorLabelHeight = errorView.bounds.height + UIApplication.shared.statusBarFrame.height/2
            
            let errorLbl = UILabel()
            errorLbl.frame.size.width = errorLabelWidth
            errorLbl.frame.size.height = errorLabelHeight
            errorLbl.numberOfLines = 0
            
            errorLbl.text = message
            errorLbl.font = UIFont(name: "Avenir Next", size: width/30)
            errorLbl.textColor = .white
            errorLbl.textAlignment = .center
            
            errorView.addSubview(errorLbl)
            
            //animate error view
            UIView.animate(withDuration: 0.2, animations: {
                errorView.frame.origin.y = 0
            }, completion: { (success) in
                if success{
                    UIView.animate(withDuration: 0.1, delay: 2, options: .curveLinear, animations: {
                        errorView.frame.origin.y = errorViewY
                    }, completion: { (success) in
                        if success{
                            errorView.removeFromSuperview()
                            errorLbl.removeFromSuperview()
                            self.errorIsShowing = false
                        }
                    })
                }
            })
            
        }
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

