//
//  NewItemTableViewController.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-04-07.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

class NewItemTableViewController: UITableViewController {

    //outlets for navigation bar and table view
    @IBOutlet weak var listNavigationOutlet: UINavigationItem!
    @IBOutlet var newItemOutlet: UITableView!
    
    //variable used to identify if a list item is being edited
    static var editing = false
    
    //sets editing to false
    override func viewDidLoad() {
        super.viewDidLoad()
        NewItemTableViewController.editing = false
    }

    //sets navigation bar title to name of list, retrieves saved data, and updates table view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()
        listNavigationOutlet.title = checklistArray[currentList].checklistName
        self.newItemOutlet.reloadData()
    }

    //sets number of sections to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //returns number of rows equal to number of items in list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistArray[currentList].items.count
    }

    //sets each row to show name of list items
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath)
        cell.textLabel?.text = checklistArray[currentList].items[indexPath.row].listItem
        return cell
    }
    
    //sends user to ReminderTableViewController, sets editing to true, and sets current Item to the index referring to list item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewItemTableViewController.editing = true
        currentItem = indexPath.row
        performSegue(withIdentifier: "listToReminder", sender: self)
    }
    
    //function used to delete a list item when user slides cell to the left. Removes an existent notifications and saves checklistArray
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if checklistArray[currentList].items[indexPath.row].reminder {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [checklistArray[currentList].items[indexPath.row].listItem!])
            }
            checklistArray[currentList].items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }
    
    //sends user back to MainTableViewController
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromList", sender: self)
    }
    
    //sends user to ReminderTableViewController to make a new reminder item
    @IBAction func newPressed(_ sender: Any) {
        performSegue(withIdentifier: "listToReminder", sender: self)
    }
    
    //function to create and unwind segue
    @IBAction func unwindToNewItem(segue:UIStoryboardSegue) {
    }
    
    
    
    
}
