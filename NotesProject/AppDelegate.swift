//
//  AppDelegate.swift
//  NotesProject
//
//  Created by Aleksandr on 03/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let noteListView = Assembler.createNoteListView()
        let navController = UINavigationController(rootViewController: noteListView.toPresent)

        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Сообщает делегату о завершении работы приложения
        CoreDataManager.instance.saveContext()
    }
}
