//
//  Task+CoreDataProperties.swift
//  TaskTracker
//
//  Created by Влад Динеев on 04.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var note: String?
    @NSManaged public var status: Int32

}

extension Task : Identifiable {

}
