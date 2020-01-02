//
//  checklistItemStructFile.swift
//  Nguyen_Justin_Reminders
//
//  Created by Justin Nguyen on 2019-04-06.
//  Copyright © 2019 Justin Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct checklistItem: Codable {
    var listItem: String?
    var reminder: Bool = false
    var reminderDate: Date?
}
