//
//  TasksTableViewController.swift
//  TaskTracker
//
//  Created by Влад Динеев on 28.02.2021.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    var selectedCount = 0
    var deleteButtonActive = false
    var taskPredicate: NSPredicate?
    var tasks = [Task]()

    override func viewDidLoad() {
        // Creating buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEdit))
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTask)),
                                              UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))]
        loadSavedData()
        super.viewDidLoad()
    }
    
    // Change filter (basically from CommitsApp)
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter tasks...", message: nil,
                                   preferredStyle: .actionSheet)
        // 1
        ac.addAction(UIAlertAction(title: "New", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 0")
            self.loadSavedData()
        })
        // 2
        ac.addAction(UIAlertAction(title: "In Progress", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 1")
            self.loadSavedData()
        })
        // 3
        ac.addAction(UIAlertAction(title: "Done", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 2")
            self.loadSavedData()
        })
        
        // 4
        ac.addAction(UIAlertAction(title: "Show all tasks", style: .default)
        { [unowned self] _ in
            self.taskPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Load tasks saved in core data
    func loadSavedData() {
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.predicate = taskPredicate
        request.sortDescriptors = [sort]
        
        do {
            tasks = try persistentContainer.viewContext.fetch(request)
            print("Got \(tasks.count) tasks")
            tableView.reloadData()
        } catch {
            print("Failed to load tasks")
        }
    }
    
    // MARK: - Buttons handling
    @objc func onAddTask(){
        if isEditing {
            onEdit()
        }
        performSegue(withIdentifier: "showCreateTask", sender: self.tableView)
    }
    
    @objc func onEdit(){
        if !isEditing {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onEdit))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEdit))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTask))
        }
        
        setEditing(!isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateTask" {
            let destView = segue.destination as? AddTaskViewController
            destView?.taskController = self
            destView?.persistentContainer = self.persistentContainer
        }
        
        if segue.identifier == "showDetails" {
            let destView = segue.destination as? DetailsViewController
            let index = sender as! IndexPath
            
            destView?.taskViewController = self
            destView?.currentTask = tasks[index.row]
            destView?.persistentContainer = persistentContainer
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        cell.textLabel!.text = tasks[indexPath.row].title
        cell.detailTextLabel!.text = tasks[indexPath.row].date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persistentContainer.viewContext.delete(tasks[indexPath.row])
            tableView.beginUpdates()
            saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            loadSavedData()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "showDetails", sender: indexPath)
        } else {
            selectedCount += 1
            if selectedCount > 0 && !deleteButtonActive {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteRows))
            }
        }
    }
    
    // Deleting rows from database
    @objc func deleteRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows  {
                persistentContainer.viewContext.delete(tasks[indexPath.row])
            }
            
            tableView.beginUpdates()
            saveContext()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            loadSavedData()
            tableView.endUpdates()
            
            selectedCount = 0
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTask))
        }
    }
    
    // User selecting the row
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !isEditing {
            return
        }
        
        selectedCount-=1;
        if selectedCount == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTask))
        }
    }
    
    // MARK: - Core Data Support
    
    lazy var persistentContainer: NSPersistentContainer = {
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
        let context = persistentContainer.viewContext
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
