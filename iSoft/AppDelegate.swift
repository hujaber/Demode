//
//  AppDelegate.swift
//  iSoft
//
//  Created by Hussein Jaber on 24/9/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import DrawerController
import GoogleMaps
import Alamofire
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import IQKeyboardManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var drawerController: DrawerController?
    let googleMapsAPIKey = "AIzaSyA0SyEEHGL0aEWdd7hzxQaxlknLioDezUU"
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        prepareDrawer()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let tabBar: UITabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CenterView") as! UITabBarController
        
        let loginScreen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UINavigationController
        if (User.getCurrentUser() != nil) {
            window?.rootViewController = tabBar
        } else {
            window?.rootViewController = loginScreen
        }
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor.myBlueColor()
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.myBlueColor()
        window?.makeKeyAndVisible()
        GMSServices.provideAPIKey(googleMapsAPIKey)
        Fabric.with([Crashlytics.self])
        UIApplication.shared.statusBarStyle = .lightContent
        //IQKeyboardManager.sharedManager().enable = true
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
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
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: Custom Functions
    
    func prepareDrawer() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "StoreView") as! UINavigationController
        let leftView = storyBoard.instantiateViewController(withIdentifier: "LeftView") as! UINavigationController
        drawerController = DrawerController.init(centerViewController: viewController, leftDrawerViewController:leftView)
        drawerController?.maximumLeftDrawerWidth = 1
       // drawerController?.openDrawerGestureModeMask = OpenDrawerGestureMode.bezelPanningCenterView
       // drawerController?.closeDrawerGestureModeMask = CloseDrawerGestureMode.all
        drawerController?.shouldStretchDrawer = false
        drawerController?.bezelRange = 50
        drawerController?.animationVelocity = 500
    }


}

