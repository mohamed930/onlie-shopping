//
//  productsViewModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import Foundation
import RxCocoa
import RxSwift

class productsViewModel {
    
    private var productsBehaviour = BehaviorRelay<[productModel]>(value: [])
    var productsBehaviourObserval: Observable<[productModel]> {
        return productsBehaviour.asObservable()
    }
    
    func FetchData() {
        var arr = Array<productModel>()
        
        arr.append(productModel(id: "1", name: "medo", gallery: ["https://www.google.com/"], prices: [priceModel(amount: 120.42, currency: currencyModel(label: "USD", symbol: "$"))]))
        
        arr.append(productModel(id: "1", name: "medo", gallery: ["https://www.google.com/"], prices: [priceModel(amount: 120.42, currency: currencyModel(label: "USD", symbol: "$"))]))
        
        arr.append(productModel(id: "1", name: "medo", gallery: ["https://www.google.com/"], prices: [priceModel(amount: 120.42, currency: currencyModel(label: "USD", symbol: "$"))]))
        
        productsBehaviour.accept(arr)
    }
}
