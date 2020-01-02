//
//  GlobalVariables.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-04-06.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import Foundation
import UIKit

//array of all the lists created by user
var checklistArray: [checklist] = []
//keeps track of current list selected
var currentList: Int = -1
//keeps track of current reminder selected
var currentItem: Int = -1
//keeps track if newIcon is being picked
var newIcon: Bool = false
//keeps track of current icon/category selected
var currentIcon: icons = icons.general

//struct that holds properties of a list
struct checklist: Codable {
    var checklistName: String?
    var numItems: Int = 0
    var items: [checklistItem] = []
    var icon: icons = icons.general
}

//struct that hold properties of a reminder item
struct checklistItem: Codable {
    var listItem: String?
    var reminder: Bool = false
    var reminderDate: Date?
}

//enum to hold values of icons/categories
enum icons: String, Codable {
    case general, chores, alarm, work, birthday, entertainment, event
}

//array of each different icons/categories
let arrayIcon: [icons] = [.general, .chores, .alarm, .work, .birthday, .entertainment, .event]

// documentsDirectory and archiveURL create the path to store lists
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("checklist_test").appendingPathExtension("plist")

//create encoder to save data
let propertyListEncoder = PropertyListEncoder()

//function to save checklistArray
func save(){
    let encodedList = try? propertyListEncoder.encode(checklistArray)
    try? encodedList?.write(to: archiveURL, options: .noFileProtection)
}

//create decoder to recover saved data
let propertyListDecoder = PropertyListDecoder()

//function to retrieve saved data
func retrieve(){
    if let retrievedListData = try? Data(contentsOf: archiveURL),let decodedList = try? propertyListDecoder.decode([checklist].self, from: retrievedListData){
        checklistArray = decodedList
    }
}


