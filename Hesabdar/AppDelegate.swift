//
//  AppDelegate.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let defaults = UserDefaults()
    let bar = UITabBarController()
    let button = UIButton(type: .custom)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let transTable = TransactionTableViewController(nibName: "TransactionTableViewController", bundle: nil)
        let accountTable = AccountTableViewController(nibName: "AccountTableViewController", bundle: nil)
        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
        
        let nav1 = UINavigationController()
        let nav2 = UINavigationController()
        let nav3 = UINavigationController()
        
        nav1.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
        nav2.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
        nav3.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
        
        let model = Model()
        UIBarButtonItem.appearance().setTitleTextAttributes(model.font(size: 15), for: .normal)
        
        nav1.viewControllers = [transTable]
        nav2.viewControllers = [accountTable]
        nav3.viewControllers = [home]
        
        bar.tabBar.isTranslucent = false
        bar.viewControllers = [nav1, nav3, nav2]
        bar.tabBar.items?[0].image = UIImage(named: "transaction")
        bar.tabBar.items?[0].selectedImage = UIImage(named: "transaction_selected")
        bar.tabBar.items?[0].imageInsets.top = 5
        bar.tabBar.items?[0].imageInsets.bottom = -5
        bar.tabBar.items?[2].image = UIImage(named: "account")
        bar.tabBar.items?[2].selectedImage = UIImage(named: "account_selected")
        bar.tabBar.items?[2].imageInsets.top = 5
        bar.tabBar.items?[2].imageInsets.bottom = -5
        
        goToHome()
        
        let size: CGFloat = 55
        let point = bar.tabBar.center
        button.frame = CGRect(x: point.x - size/2, y: point.y - size/2 + 10, width: size, height: size)
        button.layer.cornerRadius = size/2
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 0, green: 192/255, blue: 0, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "home"), for: .normal)
        bar.view.addSubview(button)
        button.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.7
        button.layer.masksToBounds = false
        
        if defaults.value(forKey: "FirstTime") == nil {
            let help = HelpViewController(nibName: "HelpViewController", bundle: nil)
            window?.rootViewController = help
            defaults.set(true, forKey: "FirstTime")
        } else {
            window?.rootViewController = bar
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func goToHome() {
        bar.selectedIndex = 1
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Hesabdar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

