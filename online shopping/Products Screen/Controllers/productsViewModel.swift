//
//  productsViewModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Apollo

class productsViewModel {
    
    private var productsBehaviour = BehaviorRelay<[productModel]>(value: [])
    var productsBehaviourObserval: Observable<[productModel]> {
        return productsBehaviour.asObservable()
    }
    
    var watcher: GraphQLQueryWatcher<AllproducsQuery>?
    var watcherColthes: GraphQLQueryWatcher<AllproducsWithColthesTagQuery>?
    var techColthes: GraphQLQueryWatcher<AllproducsWithTechTagQuery>?
    
    private func ConvertToArray<T: GraphQLSelectionSet>(data: [T]) {
        var arr = Array<productModel>()
        
        for i in data {
            let prices = i.resultMap["prices"] as! [[String: Any]]

            var pricesArr = Array<priceModel>()

            for j in prices {

                let element = j["currency"].jsonValue as! [String: String]
                pricesArr.append(priceModel(amount: j["amount"] as! Double, currency: currencyModel(symbol: element["symbol"]!)))
            }

            arr.append(productModel(id: i.resultMap["id"] as! String , name: i.resultMap["name"] as! String,inStock: (i.resultMap["inStock"] as! Bool), gallery: i.resultMap["gallery"] as! [String?], prices: pricesArr))
        }
        
        var arr1 = self.productsBehaviour.value
        arr1.removeAll()
        arr1 = arr
        self.productsBehaviour.accept(arr1)
    }
    
    
    func fetchDataOperation() {
        
        watcher = apollo.watch(query: AllproducsQuery() , resultHandler: { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsQuery.Data.Category.Product] else { return }
                
                self.ConvertToArray(data: data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    func fetchDataClothesOperation() {
        
        watcherColthes = apollo.watch(query: AllproducsWithColthesTagQuery()) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsWithColthesTagQuery.Data.Category.Product] else { return }
                
                self.ConvertToArray(data: data)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchDataTechOperation() {
        
        techColthes = apollo.watch(query: AllproducsWithTechTagQuery()) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsWithTechTagQuery.Data.Category.Product] else { return }
                
                self.ConvertToArray(data: data)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}
