//
//  Reminder.swift
//  realDataBase
//
//  Created by AFFIXUS IMAC1 on 10/17/18.
//  Copyright © 2018 AFFIXUS IMAC1. All rights reserved.
//

import Foundation
import RealmSwift

class Reminder: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
