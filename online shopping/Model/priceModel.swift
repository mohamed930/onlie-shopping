//
//  priceModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import Foundation

struct priceModel {
    var amount: Double
    var currency: currencyModel
}

struct currencyModel {
    var label: String
    var symbol: String
}
