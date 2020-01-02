//
//  MainTableViewController.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-03-31.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import UIKit
import UserNotifications




class MainTableViewController: UITableViewController {

    //outlets for tableView and button for new list
    @IBOutlet var mainTableOutlet: UITableView!
    @IBOutlet weak var newOutlet: UIBarButtonItem!
    
    //variable to let app know if mainTableViewController is editing a list
    static var editing = false
    
    //function to allow unwind segue to mainTableViewController
    @IBAction func unwindToMain(for unwindSegue: UIStoryboardSegue) {
    }
    
    //segues to newTableView to edit/create new lists
    @IBAction func newButton(_ sender: Any) {
        performSegue(withIdentifier: "mainToNew", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrieves saved data
        retrieve()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //updates data shown on mainTable
        self.mainTableOutlet.reloadData()
        MainTableViewController.editing = false
    }

    //sets number of sections to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //displays as many rows as checklists
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistArray.count
    }
    
    //formats each cell to display list icon, name, and category
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "checklistItem", for: indexPath)
        myCell.textLabel?.text = checklistArray[indexPath.row].checklistName
        myCell.imageView?.image = UIImage(named: checklistArray[indexPath.row].icon.rawValue)
        myCell.detailTextLabel?.text = checklistArray[indexPath.row].icon.rawValue.uppercased()
        return myCell
    }

    //sends to table view of list contents when list cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentList = indexPath.row
        performSegue(withIdentifier: "mainToReminder", sender: self)
    }
    
    //recognizes that user is editing a list and sends to newtableview to edit selected list
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        currentList = indexPath.row
        MainTableViewController.editing = true
        performSegue(withIdentifier: "mainToNew", sender: self)
    }
    
    //deletes a list and its row when user slides cell to the left. Deletes any pending notifaction and removes the list from the checklistArray
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            for index in 0..<checklistArray[indexPath.row].items.count{
                if checklistArray[indexPath.row].items[index].reminder {
                    print(index)
             
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [checklistArray[indexPath.row].items[index].listItem!])
                }
            }
            checklistArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //saves changes to checklistArray
            save()
        }
    }
    
    
    
    

}
