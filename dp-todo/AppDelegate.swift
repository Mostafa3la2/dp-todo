//
//  AppDelegate.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/4/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // this makes sure we create default categories only first time the app runs
        if !UserDefaults.standard.bool(forKey: "HasDefaultCategories"){
            initDefaultCategories { (success) in
                UserDefaults.standard.set(true, forKey: "HasDefaultCategories")
            }
        }
        //configuring notifications by first asking to allow notifications
        let options : UNAuthorizationOptions = [.alert,.badge,.sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted{
                print("something went wrong")
            }
        }
        
        if(UserDefaults.standard.bool(forKey: "notifications")){
        let content = UNMutableNotificationContent()
        content.title = "Have time to check your todo list?"
        content.sound = UNNotificationSound.default()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        //this time can be configured on a daily basis or calculated based on the completion date
        let date = dateFormatter.date(from: "8:37 PM")
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                print("cant send notification")
            }
        }
        
        }
        
        
        
        
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
        let container = NSPersistentContainer(name: "dp_todo")
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
    
    // function which pre populates primary categories
    func initDefaultCategories(completion:(_ finished:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let categoryWork = Category(context: managedContext)
        categoryWork.categoryName = "Work"
        categoryWork.categoryColour = "Red"
        let categoryHobby = Category(context: managedContext)
        categoryHobby.categoryName = "Hobby"
        categoryHobby.categoryColour = "Blue"
        let categoryHealth = Category(context: managedContext)
        categoryHealth.categoryName = "Health"
        categoryHealth.categoryColour = "Green"
        
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }

}

