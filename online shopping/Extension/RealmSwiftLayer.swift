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
}
