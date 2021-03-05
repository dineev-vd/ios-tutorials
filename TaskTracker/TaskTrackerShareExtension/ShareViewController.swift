//
//  ShareViewController.swift
//  TaskTrackerShareExtension
//
//  Created by Влад Динеев on 01.03.2021.
//

import UIKit
import Social
import CoreData
import MobileCoreServices

// Custom controller for share extension
class ShareViewController: AddTaskViewController {
    
    override func viewDidLoad() {
        let item = extensionContext?.inputItems[0] as! NSExtensionItem
        let text = item.attachments?.first!
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTaskCreate))
        text!.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler:{(result, error) in
            DispatchQueue.main.async {
                self.taskNameField.text = result as? String
            }
        })
        super.viewDidLoad()

    }
    
    @objc func onCancel() {
        self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }
      
    @objc override func onTaskCreate() {
        makeTask(container: container)
        saveContext()
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    // MARK: - Core Data support
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.nis-ios.TaskTracker")!.appendingPathComponent("TaskTracker.sqlite"))]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
