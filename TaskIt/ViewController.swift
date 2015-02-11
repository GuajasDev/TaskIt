//
//  ViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    // UITableViewDataSource and UITableViewDelegate are classes that define protocols. Apple added functions to this protocols and Apple (or the protocols  or callbacks) are going to be responsible for when to call this functions. We won't be writing self.tableview(...), that's Apple's job. We can help trigger some functions, like telling the table to refresh itself, but we won't be calling them explicitly.
    // In the real world, people on official business are often required to follow strict procedures when dealing with certain situations. Law enforcement officials, for example, are required to “follow protocol” when making enquiries or collecting evidence. In Object-Oriented Programming, objects can do the same. Swift allows you to define protocols, which declare the methods EXPECTED to be used for a particular situation, which means that the class must implement the required methods. A protocol declares methods and properties that are independent of any specific class.
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Constants
    
    // CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fetchedResultsController = getFetchedResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
    }
    
    // Called every time the view appears on screen (as opposed to viewDidLoad which only gets called when the view is created)
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called right before the new ViewController is presented on the screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            // Because we checked that we are going to the TaskDetailViewController (if statement), we can specify 'as TaskDetailViewController', which is required to do by the 'destinationViewController' segue property
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            
            // If we passed 'indexPath' as the sender in 'performSegueWithIdentifier(...)' (called in the 'didSelectRowAtIndexPath' function), we could have said 'let indexPath = sender as NSIndexPath' and then remove the ! from 'taskArray[indexPath!.row]' since it won't be an optional. Both ways are valid
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            //See 'cellForRowAtIndexPath' for an explanation on objectAtIndexPath
            let thisTask = self.fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            
            // Make the 'detailTaksModel' property in detailVC equal to 'thisTask'
            detailVC.detailTaskModel = thisTask
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC:AddTaskViewController = segue.destinationViewController as AddTaskViewController
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
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return how many rows there is in a chosen section
        return self.fetchedResultsController.sections![section].numberOfObjects // How many objects there are in the current section
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // If, for example, numberOfRowsInSection says there are 5 rows in section 0 then this function will be called 5 times. In each time indexPath.section = 0, but indexPath.row will be 0, 1, 2, 3, and 4.
        
        // objectAtIndexPath figures out which section and which row and returns the correct TaskModel instance, but it doesn't know it's a TaskModel instance so it needs to be specified using the 'as' keyword
        let thisTask = self.fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        // We know that the cell we are going to get back from myCell is of class TaskTableViewCell, so we specify it using the 'as' keyword
        var cell: TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskTableViewCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
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
        // Adds functionality when a table cell is swiped. See 'cellForRowAtIndexPath' for an explanation on objectAtIndexPath
        let thisTask = self.fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        if indexPath.section == 0 {
            thisTask.completed = true
        } else {
            thisTask.completed = false
        }
        
        // Remove the task that was swiped
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // If there are changes to our entities this function gets called so we can reload the data every time a change is made
        tableView.reloadData()
    }
    
    // MARK: Helpers
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        
        // Sort the properties by ascending order using the 'date' property of the TaskModel entity
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        // Sort the properties by ascending order using the 'completed' property of the TaskModel entity
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)

        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        // The getResultsController is now responsible for looking at the TaskModel instances and looking for chenges there, whenever there are any changes it will order them by date (as per the fetchRequest, specified in 'taskFetchRequest()'). Do this with the managedObjectContext (which was defined as a property). For 'sectionNameKeyPath' we pass in "completed" so the results controller will look at the completed property in TaskModel and realise it can have two options, either true or false, and so it will create two sections (one for each)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        
        return self.fetchedResultsController
    }
}