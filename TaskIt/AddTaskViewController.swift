//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // MARK: Variables
    
    var mainVC:ViewController!
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(sender: UIButton) {
        // Because AddTaskDetailViewController is NOT part of the navigationController (ie we don't have a header) we don't get access to all the navigationController functions (compare to the cancel button func in TaskDetailViewController)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: IBActions
    
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        // Create a new TaskModel instance with whatever the user added into the textFields and datePicker
        var task  = TaskModel(task: taskTextField.text, subTask: taskTextField.text, date: dueDatePicker.date, completed: false)
        
        // Add the task to the taskArray in the ViewController (using the mainVC property)
        mainVC.baseArray[0].append(task)
        
        // Dismiss the AddTaskViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
