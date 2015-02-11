//
//  ViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource and UITableViewDelegate are classes that define protocols. Apple added functions to this protocols and Apple (or the protocols  or callbacks) are going to be responsible for when to call this functions. We won't be writing self.tableview(...), that's Apple's job. We can help trigger some functions, like telling the table to refresh itself, but we won't be calling them explicitly.
    // In the real world, people on official business are often required to follow strict procedures when dealing with certain situations. Law enforcement officials, for example, are required to “follow protocol” when making enquiries or collecting evidence. In Object-Oriented Programming, objects can do the same. Swift allows you to define protocols, which declare the methods EXPECTED to be used for a particular situation, which means that the class must implement the required methods. A protocol declares methods and properties that are independent of any specific class.
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    
    // Arrays
    var baseArray:[[TaskModel]] = []
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        // we connected the TableView's delegate and data source to the View Controller using the storyboard, however if we wanted to use code we could do:
        self.tableView.dataSource = self
        self.tableView.delegate = self
        */
        
        let date1 = Date.from(year: 2015, month: 02, day: 11)
        let date2 = Date.from(year: 2015, month: 02, day: 12)
        let date3 = Date.from(year: 2015, month: 02, day: 10)
        
        let task1 = TaskModel(task: "Study French", subTask: "Verbs", date: date1, completed: false)
        let task2 = TaskModel(task: "Eat Dinner", subTask: "Burgers", date: date2, completed: false)
        
        let incompleteArray = [task1, task2, TaskModel(task: "Gym", subTask: "Leg day", date: date3, completed: false)]
        var completedArray = [TaskModel(task: "Code", subTask: "Task Project", date: date2, completed: true)]
        
        self.baseArray = [incompleteArray, completedArray]
    }
    
    // Called every time the view appears on screen (as opposed to viewDidLoad which only gets called when the view is created)
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // This is called a 'closure', it will organise the cells from most recent to furthest away
        self.baseArray[0] = self.baseArray[0].sorted {
            (taskOne: TaskModel, taskTwo: TaskModel) -> Bool in
            // Comparison logic here
            
            // Returns true if the first date of taskTwo is more recent (ie more time has passed since 1970)
            return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called right before the new ViewController is presented on the screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            // Because we checked that we are goint to the TaskDetailViewController (if statement), we can specify 'as TaskDetailViewController', which is required to do by the 'destinationViewController' segue property
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            
            // If we passed 'indexPath' as the sender in 'performSegueWithIdentifier(...)' (called in the 'didSelectRowAtIndexPath' function), we could have said 'let indexPath = sender as NSIndexPath' and then remove the ! from 'taskArray[indexPath!.row]' since it won't be an optional. Both ways are valid
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = self.baseArray[indexPath!.section][indexPath!.row]   // Remember baseArray is an array of arrays
            detailVC.detailTaskModel = thisTask
            
            // Pass this ViewController (the one we are in, hence self) to the mainVC property (which is of type ViewController) that is in detailVC
            detailVC.mainVC = self
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC:AddTaskViewController = segue.destinationViewController as AddTaskViewController
            
            // Pass this ViewController (the one we are in, hence self) to the mainVC property (which is of type ViewController) that is in addTaskVC
            addTaskVC.mainVC = self
        }
    }
    
    // MARK: IBActions
    
    @IBAction func addBarButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }

    // MARK: UITableViewSource
    // NOTE: Have a look at extensions, like on http: //stackoverflow.com/questions/24017316/pragma-mark-in-swift
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return how many sections there will be
        return self.baseArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return how many rows there is in a chosen section
        return self.baseArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // If, for example, numberOfRowsInSection says there are 5 rows in section 0 then this function will be called 5 times. In each time indexPath.section = 0, but indexPath.row will be 0, 1, 2, 3, and 4.
        
        let thisTask = self.baseArray[indexPath.section][indexPath.row] // Remember baseArray is an array of arrays
        
        // We know that the cell we are going to get back from myCell is of class TaskTableViewCell, so we specify it using the 'as' keyword
        var cell: TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskTableViewCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subTask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Called when we tap a row in our UITableView (hence didSelectRowAtIndexPath). So if we tap on the 3rd row of the 2nd section then indexPath.section = 2 and indexPath.row = 3
        
        println(indexPath.row)
        
        // We use 'self' because we are not passing anything, but if we wanted to use 'override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)' then we can pass an object and use it in that function
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "To do"
        } else {
            return "Completed"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Adds functionality when a table cell is swiped
        let thisTask:TaskModel = baseArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            // Currently inside the incompleteArray
            
            var newTask = TaskModel(task: thisTask.task, subTask: thisTask.subTask, date: thisTask.date, completed: true)
            
            // Add it to the completedArray, indexed at 1 in the baseArray
            self.baseArray[1].append(newTask)
        } else {
            // Currently inside the completeArray
            
            var newTask = TaskModel(task: thisTask.task, subTask: thisTask.subTask, date: thisTask.date, completed: false)
            
            // Add it to the incompleteArray, indexed at 0 in the baseArray
            self.baseArray[0].append(newTask)
        }
        
        // Remove the task that was swiped
        self.baseArray[indexPath.section].removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
}




















