//
//  ViewController.swift
//  TaskTracker
//
//  Created by Влад Динеев on 28.02.2021.
//

import UIKit
import CoreData

// Controller for adding/editing a task
class AddTaskViewController: UIViewController {
    @IBOutlet public var taskNameField: UITextField!
    @IBOutlet public var datePicker: UIDatePicker!
    @IBOutlet public var noteField: UITextField!
    @IBOutlet public var statusField: UISegmentedControl!
    @IBOutlet public var mainLabel: UILabel!
    
    @IBAction func onTaskCreate(){
        makeTask(container: self.persistentContainer)
    
        self.taskController.saveContext()
        self.taskController.loadSavedData()
        self.taskController.tableView.reloadData()
               
        if((details) != nil){
            details?.refresh()
        }
        
        self.dismiss(animated: true)
    }
    
    var taskController: TasksTableViewController!
    var details: DetailsViewController?
    var persistentContainer: NSPersistentContainer!
    var editTask: Task?
    
    override func viewDidLoad() {
        if(editTask == nil){
            if(taskNameField.text == nil || taskNameField.text!.isEmpty) {
                taskNameField.text = "New task"
            }
            
            datePicker.date = Date()
            noteField.text = ""
            statusField.setEnabled(true, forSegmentAt: 0)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            
            taskNameField.text = editTask?.title
            datePicker.date = formatter.date(from: editTask?.date ?? "") ?? Date()
            noteField.text = editTask?.note
            statusField.selectedSegmentIndex = Int(editTask!.status)
            mainLabel.text = "Edit task"
        }
        
        super.viewDidLoad()
    }
    
    // Create Task object or edit existing
    func makeTask(container: NSPersistentContainer) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        var title: String = taskNameField.text ?? ""
        let date: String = formatter.string(from: datePicker.date)
        let status: Int = statusField.selectedSegmentIndex
        let note: String = noteField.text ?? ""
        title = title.isEmpty ? "Unnamed task" : title
        let task = editTask ?? Task(context: container.viewContext)
        
        task.title = title
        task.note = note
        task.date = date
        task.status = Int32(status)
    }
}

