//
//  cartModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 26/06/2022.
//

import Foundation
import RealmSwift

class cartModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var productId: String = ""
    @objc dynamic var pickedSize: String? = nil
    @objc dynamic var pickedColor: String? = nil
    @objc dynamic var count: Int = 1
    
    override init() {
        
    }
    
    init(id: String, productId: String, pickedSize: String? , pickedColor: String?) {
        self.id = id
        self.productId = productId
        self.pickedSize = pickedSize
        self.pickedColor = pickedColor
        self.count = 1
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
