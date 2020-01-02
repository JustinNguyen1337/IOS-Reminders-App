//
//  NewTableViewController.swift
//  Nguyen_Justin_Reminders
//
//  Created by Period Four on 2019-04-03.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import UIKit



class NewTableViewController: UITableViewController {

    @IBOutlet weak var listTitleOutlet: UITextField!
    @IBOutlet weak var newChecklistNavigationItem: UINavigationItem!
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var categoryTextOutlet: UILabel!
    @IBOutlet var newTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MainTableViewController.editing)
       
    }

    //function to create an undwind segue to NewTableViewController
    @IBAction func unwindToNewList(for unwindSegue: UIStoryboardSegue) {
    }
    
    //retrieves saved data in viewWillAppear and sets up the tableview controller
    //if editing list, displays icon and name of current list
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()
        if MainTableViewController.editing && newIcon == false{
            newChecklistNavigationItem.title = checklistArray[currentList].checklistName
            listTitleOutlet.text = checklistArray[currentList].checklistName
            iconOutlet.image = UIImage(named: checklistArray[currentList].icon.rawValue)
            categoryTextOutlet.text = checklistArray[currentList].icon.rawValue.uppercased()
        } else if newIcon {
            //sets category to the new category/icon selected
            iconOutlet.image = UIImage(named: currentIcon.rawValue)
            categoryTextOutlet.text = currentIcon.rawValue.uppercased()
        } else {
            //sets category to .general when creating new list
            iconOutlet.image = UIImage(named: arrayIcon[0].rawValue)
            categoryTextOutlet.text = arrayIcon[0].rawValue.uppercased()
        }
        self.newTableView.reloadData()
    }

    //sets 2 sections, 1 for list name input, 1 for category
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //sets 1 row for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //function for done button
    @IBAction func donePressed(_ sender: Any) {
        //when player makes a new list, creates a new value in checklistArray and sets the list properties. Sends user back to mainTableViewController
        if listTitleOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && MainTableViewController.editing == false{
            currentList = checklistArray.count
            checklistArray.append(checklist())
            checklistArray[currentList].checklistName = listTitleOutlet.text
            checklistArray[currentList].icon = currentIcon
            performSegue(withIdentifier: "unwindToMain", sender: self)
        } else if
            //sets updated values to list being edited. Sends user back to mainTableViewController
            listTitleOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && MainTableViewController.editing {
            MainTableViewController.editing = false
            checklistArray[currentList].checklistName = listTitleOutlet.text
            if newIcon {
            checklistArray[currentList].icon = currentIcon
                newIcon = false
            }
            performSegue(withIdentifier: "unwindToMain", sender: self)
        } else if listTitleOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            //creates an alert warning user that there is no name input for the list
            let alert = UIAlertController(title: "Missing Name", message: "List Name Required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //function for cancel button that resets currentIcon and unwinds to MainTableViewController
    @IBAction func cancelPressed(_ sender: Any) {
        currentIcon = .general
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    //saves all changes to checklistArray and resets currentIcon
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        currentIcon = .general
        save()
    }
    
    
    
    
    
}
