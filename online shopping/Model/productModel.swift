//
//  productModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import Foundation
//import Apollo

struct productModel {
    var id: String
    var name: String
    var inStock: Bool
    var inCart: Bool
    var gallery: [String?]
//    var prices: [ProductsDetails.Price]
    var prices: [priceModel]
}
