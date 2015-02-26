//
//  SettingsViewController.swift
//  TaskIt
//
//  Created by Diego Guajardo on 20/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets

    @IBOutlet weak var capitaliseTableView: UITableView!
    @IBOutlet weak var completeNewTodoTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: Variables
    
    // MARK: Constants
    
    let kVersionNumber = "1.0"
    
    // MARK: - BODY
    
    // MARK: Initialisers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.capitaliseTableView.delegate = self
        self.capitaliseTableView.dataSource = self
        self.capitaliseTableView.scrollEnabled = false
        
        self.completeNewTodoTableView.delegate = self
        self.completeNewTodoTableView.dataSource = self
        self.completeNewTodoTableView.scrollEnabled = false
        
        //Set the title at on the Top Bar
        self.title = "Settings"
        
        self.versionLabel.text = "Version " + kVersionNumber
        
        // Override the 'Back' button
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
        self.navigationItem.leftBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Bar Button Actions
    
    func doneBarButtonItemPressed(barButtonItem: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // If each of the two tableViews had two rows, this function would be called four times; two for the first tableView (capitaliseTableView) and two for the second
        
        // Check which tabeView we are in
        if tableView == self.capitaliseTableView? {
            var capitaliseCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("capitaliseCell") as UITableViewCell!
            
            if indexPath.row == 0 {
                capitaliseCell.textLabel?.text = "No, do not Capitalize"
                capitaliseCell.textLabel?.textColor = UIColor.whiteColor()
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitaliseTaskKey) == false {
                    capitaliseCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitaliseCell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {    // indexPath.row == 1
                capitaliseCell.textLabel?.text = "Yes Capitalize!"
                capitaliseCell.textLabel?.textColor = UIColor.whiteColor()
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitaliseTaskKey) == true {
                    capitaliseCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitaliseCell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            
            return capitaliseCell
        } else {    // tableView == self.completeNewTodoTableView
            var completeNewTodoCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("completeNewTodoCell") as UITableViewCell!
            
            if indexPath.row == 0 {
                completeNewTodoCell.textLabel?.text = "Do not complete Task"
                completeNewTodoCell.textLabel?.textColor = UIColor.whiteColor()
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == false {
                    completeNewTodoCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    completeNewTodoCell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {    // indexPath.row == 1
                completeNewTodoCell.textLabel?.text = "Complete Task"
                completeNewTodoCell.textLabel?.textColor = UIColor.whiteColor()
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
                    completeNewTodoCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    completeNewTodoCell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            
            return completeNewTodoCell
        }
    }
    
    // We only need two rows in each tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: UITablViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.capitaliseTableView {
            return "Capitalize New Task?"
        } else {
            return "Complete New Task?"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.capitaliseTableView {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCapitaliseTaskKey)
            } else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCapitaliseTaskKey)
            }
        } else {    // completeNewTodoTableView
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCompleteNewTodoKey)
            } else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewTodoKey)
            }
        }
        
        // REMEMBER TO SAVE THE VALUES
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
}