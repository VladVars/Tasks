//
//  RealmManager.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import Foundation
import RealmSwift


final class RealmManager {
    private static let realm = try! Realm()
    class func startTransaction() {
        realm.beginWrite()
    }
    
    class func claseTransaction() {
        try? realm.commitWrite()
    }
    
    static func read() -> [Task] {
        let result = realm.objects(Task.self)
        return Array(result)
    }
    
    static func save(object: Task) {
       try? realm.write {
           realm.add(object)
        }
    }
    static func delete(object: Task) {
        let data = read()
        guard let objectToDelete = data.filter({ $0.task == object.task && $0.time == object.time}).first else { return }
        
        try? realm.write({
            realm.delete(objectToDelete)
        })
    }
}
