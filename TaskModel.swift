//
//  TaskModel.swift
//  TaskIt
//
//  Created by Diego Guajardo on 12/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import Foundation
import CoreData

// This line creates an Objective-C bridge in case we ever wanna use Objective-C in the future
@objc(TaskModel)

class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}