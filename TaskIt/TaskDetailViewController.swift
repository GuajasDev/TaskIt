//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // MARK: Variables
    
    var mainVC: ViewController!
    var detailTaskModel: TaskModel!
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTextField.text = detailTaskModel.task
        self.subtaskTextField.text = detailTaskModel.subTask
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
        var task = TaskModel(task: taskTextField.text, subTask: subtaskTextField.text, date: dueDatePicker.date, completed: false)
        
        // Replace the instance in the ViewController's taskArray that is at the indexPath of the selected row with the new values saved in task
        mainVC.baseArray[0][mainVC.tableView.indexPathForSelectedRow()!.row] = task
        
        // Pop back to the ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
}