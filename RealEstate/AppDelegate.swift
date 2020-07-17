//
//  AppDelegate.swift
//  RealEstate
//
//  Created by Amit Kumar on 29/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        self.configureAppearances()
        self.autoLogin()
        return true
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
    
    
    
    private func configureAppearances() {
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
            ,NSAttributedString.Key.font : AppFont.bold.font(size: 18)], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.tabTitleUnselectedColor
            ,NSAttributedString.Key.font : UIFont.init(name: AppFont.regular.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.customGoldenColor
        ], for: .selected)
    }
    
    var topMostController : UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
    
    func redirectToSignIn() {
        AppUserDefault.removeCurrentUser()
        let storyBaord = UIStoryboard.init(name: AppStoryboard.registration.rawValue, bundle: nil)
        if let vc = storyBaord.instantiateInitialViewController() {
            let navigationVC = vc
            self.window?.rootViewController = navigationVC
            self.window?.makeKeyAndVisible()
        }
    }
    
    private func autoLogin() {
        if kSharedAuthToken != nil && SharedClass.shared.user != nil {
            let navigationVC = UINavigationController.init()
            navigationVC.isNavigationBarHidden = true
            
            if !(SharedClass.shared.user?.isEmailVerified ?? false) {
                let vc = OTPVerificationVC.instantiate(from: .registration)
                vc.isEmailUnVerified = true
                navigationVC.viewControllers = [vc]
                self.window?.rootViewController = navigationVC
                self.window?.makeKeyAndVisible()
            } else {
                if !(SharedClass.shared.user?.isProfileSetup ?? false) {
                    let vc = ProfileVC.instantiate(from: .home)
                    vc.isEditingEnabled = true
                    navigationVC.viewControllers = [vc]
                    self.window?.rootViewController = navigationVC
                    self.window?.makeKeyAndVisible()
                } else {
                    let storyBaord = UIStoryboard.init(name: AppStoryboard.home.rawValue, bundle: nil)
                    if let vc = storyBaord.instantiateInitialViewController() {
                        let navigationVC = vc
                        self.window?.rootViewController = navigationVC
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        } else {
            let storyBaord = UIStoryboard.init(name: AppStoryboard.registration.rawValue, bundle: nil)
            if let vc = storyBaord.instantiateInitialViewController() {
                let navigationVC = vc
                self.window?.rootViewController = navigationVC
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
}

