//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit
import CoreData

// Both of these functions are required by any class that conforms to the protocol
protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCancelled(message: String)
}

class AddTaskViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // MARK: Variables
    
    // REMEMBER to set the delegate variable!! It's an easy way to access the TaskDetailViewControllerDelegate
    var delegate: AddTaskViewControllerDelegate?
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(sender: UIButton) {
        // Because AddTaskDetailViewController is NOT part of the navigationController (ie we don't have a header) we don't get access to all the navigationController functions (compare to the cancel button func in TaskDetailViewController)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // VERY important that this is called AFTER  the AddTaskViewController is dismissed, because the class that conforms to the delegate is ViewController, which is not on the window hierarchy UNTIL the AddTaskViewController is dismissed
        delegate?.addTaskCancelled("Task was not added!")
    }
    
    //MARK: IBActions
    
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        // Get access to the AppDelegate. UIApplication represents our entire application and it has an instance called 'sharedApplication()', from that we can get the delegate of the entire application which is (in this case) AppDelegate. We then specify it is AppDelegate using the 'as' keyword.
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        
        // Accecss the managedObjectContext
        let managedObjectContext = appDelegate.managedObjectContext
        
        // Create an entityDescription and pass in the entity name and the managedObjectContext (which we got from our AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        
        // Create a TaskModel instance, which we do by passing in our entityDescription instance and insert it into the managedObjectContext
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        // Access the TaskModel properties
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitaliseTaskKey) == true {
            task.task = taskTextField.text.capitalizedString
        } else {
            task.task = taskTextField.text
        }
        
        task.subtask = subtaskTextField.text
        task.date = dueDatePicker.date
        task.completed = false
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            task.completed = true
        } else {
            task.completed = false
        }
        
        // Save any changes that we made to the entity
        appDelegate.saveContext()
        
        // Request ALL instances of TaskModel
        var request = NSFetchRequest(entityName: "TaskModel")
        
        // We assign nil to the error because we only wanna create it if an error exists
        var error: NSError? = nil
        
        // Get ALL the instances from the request we made to the entitty and save them in an NSArray. We put an '&' sign before error, this way if there IS an error it gets saved into that instance, otherwise it is nil (as specified above)
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
        
        // Dismiss the AddTaskViewController
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // VERY important that this is called AFTER  the AddTaskViewController is dismissed, because the class that conforms to the delegate is ViewController, which is not on the window hierarchy UNTIL the AddTaskViewController is dismissed
        delegate?.addTask("Task Added!")
    }
}