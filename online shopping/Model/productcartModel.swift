//
//  productcartModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 28/06/2022.
//

import Foundation

struct productcartModel {
    var productId: String
    var productName: String
    var productBrand: String
    var productPriceSynmbol: String
    var productPrice: String
    var productAmount: String
    var produtsImage: [String?]
    var productSize: [SizeModel]? = []
    var procutColor: [SizeModel]? = []
}

struct SizeModel {
    var value: String
    var displayText: String
    var selected: Bool
}
