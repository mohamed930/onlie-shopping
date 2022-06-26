//
//  productDetailsViewModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 25/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo

class productDetailsViewModel {
    
    var idBehaviour = BehaviorRelay<String>(value: "")
    
    private var productDetailsBehvaiour = BehaviorRelay<ProductDetailsViewQuery.Data.Product?>(value: nil)
    var productDetailsBehaviourObserval: Observable<ProductDetailsViewQuery.Data.Product?> {
        return productDetailsBehvaiour.asObservable()
    }
    
    var imagesBehavriour = BehaviorRelay<[String]>(value: [])
    
    var sizeBehaviour = BehaviorRelay<[AttributeDetails.Item?]>(value: [])
    var ColorBehaviour = BehaviorRelay<[AttributeDetails.Item?]>(value: [])
    
    var pickedSizeBehaviour = BehaviorRelay<String?>(value: nil)
    var pickedColorBehaviour = BehaviorRelay<String?>(value: nil)
    
    private var savedResponseBehacviour = BehaviorRelay<String>(value: "")
    var SavedResponseBehaviourObserval: Observable<String> {
        return savedResponseBehacviour.asObservable()
    }
    
    var watcher: GraphQLQueryWatcher<ProductDetailsViewQuery>?
    
    func FetchproductDetailsOperation() {
        watcher = apollo.watch(query: ProductDetailsViewQuery(id: idBehaviour.value), resultHandler: { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .success(let result):
                
                guard let data = result.data?.product as? ProductDetailsViewQuery.Data.Product? else { return }
                
                self.productDetailsBehvaiour.accept(data)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func SaveDataToCart() {
        let uuid = UUID().uuidString
        
        let productData = cartModel(id: uuid, productId: idBehaviour.value, pickedSize: pickedSizeBehaviour.value, pickedColor: pickedColorBehaviour.value)
        
        print(RealmSwiftLayer.realmFileLocation) // Remove it.
        
        let response = RealmSwiftLayer.Save(productData)
        
        savedResponseBehacviour.accept(response)
    }
    
}
