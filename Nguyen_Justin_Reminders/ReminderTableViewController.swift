 //
//  ReminderTableViewController.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-04-07.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import UIKit
import UserNotifications


class ReminderTableViewController: UITableViewController {

    //create outlets for UI items
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var reminderNameOutlet: UITextField!
    @IBOutlet weak var reminderNeeded: UISwitch!
    @IBOutlet weak var reminderNav: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //retrieves saved checklistArray and updates the date on date picker
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()
        updateDate()
        //creates a new value in array of items in a list
        if NewItemTableViewController.editing == false {
            currentItem = checklistArray[currentList].items.count
            checklistArray[currentList].items.append(checklistItem())
        } else {
        //shows the name of reminder being edited in reminderNameOutlet and navigation bar
            reminderNameOutlet.text = checklistArray[currentList].items[currentItem].listItem
            reminderNav.title = checklistArray[currentList].items[currentItem].listItem
            //shows that a reminder is set by setting switch to on
            if checklistArray[currentList].items[currentItem].reminder {
                reminderNeeded.isOn = true
            }
        }
        
    }
    
    //sets number of sections to 2
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //set number of rows to 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    //executes createReminder when pressed
    @IBAction func donePressed(_ sender: Any) {
        createReminder()
    }
    
    // if a new reminder is being created, deletes it from checklistArray and returns user to NewItemTableViewController
    @IBAction func cancelPressed(_ sender: Any) {
        if NewItemTableViewController.editing == false{
            checklistArray[currentList].items.remove(at: currentItem)
        }
        performSegue(withIdentifier: "unwindToNew", sender: self)
    }
    
    //function that updates the date on the date picker to date of current item reminder, or current date
    func updateDate () {
        guard NewItemTableViewController.editing && checklistArray[currentList].items[currentItem].reminder else {
            let currentDate = Date()
            datePickerOutlet.date = currentDate
            return
        }
        datePickerOutlet.date = checklistArray[currentList].items[currentItem].reminderDate!
    }
    
    //function that executes when done button is pressed
    func createReminder() {
        //if a name was used previously, sets a warning to user
        
        for index in 0..<checklistArray[currentList].items.count-1 {
            if reminderNameOutlet.text == checklistArray[currentList].items[index].listItem && index != currentItem{
                let alert = UIAlertController(title: "Invalid Reminder Name", message: "Please set a unique reminder name", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        //if a valid date and reminder name is entered, sets all the properties of a reminder item in checklistArray, sets a reminder and sends user to NewItemTableViewController
        if reminderNeeded.isOn && reminderNameOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && datePickerOutlet.date > Date(){
            checklistArray[currentList].items[currentItem].listItem = reminderNameOutlet.text
            checklistArray[currentList].items[currentItem].reminderDate = datePickerOutlet.date
            checklistArray[currentList].items[currentItem].reminder = true
            setReminder()
            NewItemTableViewController.editing = false
            performSegue(withIdentifier: "unwindToNew", sender: self)
        } else if reminderNameOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && reminderNeeded.isOn == false   {
            //if valid name entered and no reminder set, sets item value in checklistArray. removes any reminders previously set
            if NewItemTableViewController.editing && checklistArray[currentList].items[currentItem].reminder {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [checklistArray[currentList].items[currentItem].listItem!])
            }
            checklistArray[currentList].items[currentItem].listItem = reminderNameOutlet.text
            checklistArray[currentList].items[currentItem].reminder = false
            NewItemTableViewController.editing = false
            performSegue(withIdentifier: "unwindToNew", sender: self)
        } else if reminderNameOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            //if invalid name entered, warns user with a pop-up alert
            let alert = UIAlertController(title: "Missing Name", message: "Name Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if reminderNeeded.isOn && datePickerOutlet.date <= Date() {
            //if reminder date is set in the past, warns user with pop-up alert
            let alert = UIAlertController(title: "Invalid Reminder Time", message: "Please set a time in the future", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //prompts user to allow local notifcations
    @IBAction func remindPressed(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in})
    }
    
    //function creates the notification to be displayed and sets a time for it to be displayed. Recursion
    func setReminder() {
        if NewItemTableViewController.editing {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [checklistArray[currentList].items[currentItem].listItem!])
            NewItemTableViewController.editing = false
            setReminder()
        } else {
            checklistArray[currentList].items[currentItem].listItem = reminderNameOutlet.text
            let content = UNMutableNotificationContent()
            content.title = checklistArray[currentList].checklistName!
            content.body = checklistArray[currentList].items[currentItem].listItem!
            content.sound = UNNotificationSound.default
            let notifDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: datePickerOutlet.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
            let request = UNNotificationRequest(identifier: checklistArray[currentList].items[currentItem].listItem!, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }

    //saves any changes to checklistArray
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        save()
    }
    
}
