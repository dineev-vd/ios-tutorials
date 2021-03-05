//
//  DetailsViewController.swift
//  TaskTracker
//
//  Created by Влад Динеев on 01.03.2021.
//

import UIKit
import CoreData

// Controller for viewing details of task
class DetailsViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var statusLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var noteLabel: UILabel?
    
    var taskViewController: TasksTableViewController!
    var persistentContainer: NSPersistentContainer?
    var currentTask: Task!
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEdit))
        refresh()
        
        super.viewDidLoad()
    }
    
    
    
    @objc func onEdit() {
        performSegue(withIdentifier: "editTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            let dest = segue.destination as? AddTaskViewController
            dest?.details = self
            dest?.editTask = self.currentTask
            dest?.persistentContainer = self.persistentContainer
            dest?.taskController = self.taskViewController
        }
    }
    
    func getStatus(status: Int) -> String {
        switch status {
        case 0:
            return "New"
        case 1:
            return "In Progress"
        case 2:
            return "Done"
        default:
            return "New"
        }
    }
    
    func refresh(){
        nameLabel?.text = currentTask.title
        statusLabel?.text = getStatus(status: Int(currentTask.status))
        dateLabel?.text = currentTask.date
        noteLabel?.text = currentTask.note
    }
}
