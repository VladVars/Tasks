//
//  Task.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import Foundation
import RealmSwift


@objc final class Task: Object {
    @objc dynamic var task: String = ""
    @objc dynamic var time: Date?
    @objc dynamic var isDone: Bool = false
}
