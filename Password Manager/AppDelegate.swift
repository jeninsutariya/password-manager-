//
//  AppDelegate.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var visibleViewController: UIViewController? {
        var currentVc = UIApplication.shared.keyWindow?.rootViewController
        while let presentedVc = currentVc?.presentedViewController {
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        return currentVc
    }
    lazy var persitentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Password Manager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolver error \(error)")
            }
        })
        return container
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

