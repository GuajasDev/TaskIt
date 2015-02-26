//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit

// @objc means you can have both optional and obligatory functions
@objc protocol TaskDetailViewControllerDelegate {
    // So basically if the delegate is the ViewController these functions are defined in the ViewController, but the responsability of running them and calling them relies on the TaskDetailViewController
    optional func taskDetailEdited()
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // MARK: Variables
    // REMEMBER to set the delegate variable!! It's an easy way to access the TaskDetailViewControllerDelegate
    var delegate: TaskDetailViewControllerDelegate?
    
    var detailTaskModel: TaskModel!
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        self.taskTextField.text = detailTaskModel.task
        self.subtaskTextField.text = detailTaskModel.subtask
        self.dueDatePicker.date = detailTaskModel.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions

    @IBAction func cancelBarButtonTapped(sender: UIBarButtonItem) {
        // Because TaskDetailViewController is still part of the navigationController (ie we have a header) we get access to all the navigationController functions
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneBarButtonTapped(sender: UIBarButtonItem) {
        
        // Create an AppDelegate instance
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        
        // Update the entity instance
        detailTaskModel.task = taskTextField.text
        detailTaskModel.subtask = subtaskTextField.text
        detailTaskModel.date = dueDatePicker.date
        detailTaskModel.completed = detailTaskModel.completed
        
        // Save the changes to CoreData
        appDelegate.saveContext()
        
        // Pop back to the ViewController
        self.navigationController?.popViewControllerAnimated(true)

        // delegate in this case is ViewController
        delegate?.taskDetailEdited!()
    }
}