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
    
    
    func fetchDataOperation() {
        
        watcher = apollo.watch(query: AllproducsQuery() , resultHandler: { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsQuery.Data.Category.Product] else { return }
                
                var arr = Array<productModel>()
                
                for i in data {
                    arr.append(productModel(id: i.fragments.productsDetails.id, name: i.fragments.productsDetails.name, gallery: i.fragments.productsDetails.gallery ?? [], prices: i.fragments.productsDetails.prices))
                }
                
                var arr1 = self.productsBehaviour.value
                arr1.removeAll()
                arr1 = arr
                self.productsBehaviour.accept(arr1)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    func fetchDataClothesOperation() {
        
        watcherColthes = apollo.watch(query: AllproducsWithColthesTagQuery()) { response in
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsWithColthesTagQuery.Data.Category.Product] else { return }
                
                var arr = Array<productModel>()
                
                for i in data {
                    guard let gallery = i.fragments.productsDetails.gallery else {
                        return
                    }
                    arr.append(productModel(id: i.fragments.productsDetails.id, name: i.fragments.productsDetails.name, gallery: gallery, prices: i.fragments.productsDetails.prices))
                }
                
                var arr1 = self.productsBehaviour.value
                arr1.removeAll()
                arr1 = arr
                self.productsBehaviour.accept(arr1)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchDataTechOperation() {
        
        techColthes = apollo.watch(query: AllproducsWithTechTagQuery()) { response in
            switch response {
                
            case .success(let result):
                guard let data = result.data?.category?.products as? [AllproducsWithTechTagQuery.Data.Category.Product] else { return }
                
                var arr = Array<productModel>()
                
                for i in data {
                    guard let gallery = i.fragments.productsDetails.gallery else {
                        return
                    }
                    arr.append(productModel(id: i.fragments.productsDetails.id, name: i.fragments.productsDetails.name, gallery: gallery, prices: i.fragments.productsDetails.prices))
                }
                
                var arr1 = self.productsBehaviour.value
                arr1.removeAll()
                arr1 = arr
                self.productsBehaviour.accept(arr1)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}
