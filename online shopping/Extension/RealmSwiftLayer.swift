//
//  RealmSwiftLayer.swift
//  recipe search
//
//  Created by Mohamed Ali on 26/02/2022.
//

import Foundation
import RealmSwift

class RealmSwiftLayer {
    
    static let realm = try! Realm()
    
    static let realmFileLocation = Realm.Configuration.defaultConfiguration.fileURL!
    
    // MARK: TODO: This Generatics Method For Save Message into RealmSwift.
    public static func Save<T: Object> (_ object: T) -> String{
        
        do {
            try realm.write {
                realm.add(object,update: .all)
            }
            return "Success"
        } catch {
            print("Error \(error.localizedDescription)")
            return "Failed"
        }
        
    }
    // ------------------------------------------------
    
    
    public static func objects<T: Object>() -> [T] {
        return realm.objects(T.self).filter({!$0.isInvalidated})
    }
    
    public static func update(_ block: () -> ()) -> Bool {
        do {
            try RealmSwiftLayer.realm.write(block)
            return true
        } catch let error {
            print("Updating failed with error ", error)
        }
        return false
    }
    
    public static func delete<T: Object>(_ object: T) -> Bool {
        guard !object.isInvalidated else { return true }
        
        do {
            try realm.write {
                realm.delete(object)
            }
            return true
        } catch let error {
            print("Writing of array failed for ", String(describing: T.self), " with error ", error)
        }
        return false
    }
    
    public static func deleteAll() -> Bool {
        
        do {
            try realm.write {
                realm.deleteAll()
            }
            return true
        } catch let error {
            print("Databse flush failed with ", error)
        }
        return false
    }
}
