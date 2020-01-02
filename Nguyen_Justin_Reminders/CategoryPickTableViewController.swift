//
//  CategoryPickTableViewController.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-04-15.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import UIKit

class CategoryPickTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MainTableViewController.editing)
    }

    //when cancel button is pressed, sends user back to NewTableViewController
    @IBAction func cancelPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToNewList", sender: self)
    }
    
    //sets number of sections to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //sets number of rows to 7 for the number of categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    //sets each row to show the name and icon of each category
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "iconPicker", for: indexPath)
        myCell.imageView?.image = UIImage(named: String(arrayIcon[indexPath.row].rawValue))
        myCell.textLabel?.text = arrayIcon[indexPath.row].rawValue
        return myCell
    }
    
    //sets selected row as current icon and sends user back to NewTableViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIcon = arrayIcon[indexPath.row]
        newIcon = true
        performSegue(withIdentifier: "unwindToNewList", sender: self)
    }
    
}
