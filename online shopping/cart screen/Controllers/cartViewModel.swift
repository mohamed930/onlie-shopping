//
//  cartViewModel.swift
//  online shopping
//
//  Created by Mohamed Ali on 28/06/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Apollo

class cartViewModel {
    
    var productsInCartBehvaiour = BehaviorRelay<[cartModel]>(value: [])
    
    private var productsCarBehvaiour = BehaviorRelay<[productcartModel]>(value: [])
    var productsCarBehvaiourObserval: Observable<[productcartModel]> {
        return productsCarBehvaiour.asObservable()
    }
    
    var watcher: GraphQLQueryWatcher<ProductDetailsViewQuery>?
    
    
    func FetchDataOperation() {
        var productsCart = Array<productcartModel>()
        
        print("FCount: \(productsInCartBehvaiour.value.count)")
        
        for i in productsInCartBehvaiour.value {
            watcher = apollo.watch(query: ProductDetailsViewQuery(id: i.productId), resultHandler: { response in
                switch response {
                    
                case .success(let success):
                    guard let success = success.data?.product as? ProductDetailsViewQuery.Data.Product else { return }
                    
                    var Sizes = Array<SizeModel>()
                    var Colors = Array<SizeModel>()
                    
                    for attribute in success.attributes! {

                        if attribute?.fragments.attributeDetails.name == "Size" || attribute?.fragments.attributeDetails.name == "Capacity" {

                            guard let items = attribute?.fragments.attributeDetails.items else { return }

                            for item in items {
                                var ob : SizeModel?
                                if item?.value == i.pickedSize {
                                    ob = SizeModel(value: (item!.value)!, displayText: item!.displayValue!, selected: true)
                                }
                                else {
                                    ob = SizeModel(value: (item!.value)!, displayText: item!.displayValue!, selected: false)
                                }

                                Sizes.append(ob!)
                            }

                        }
                        else if attribute?.fragments.attributeDetails.name == "Color" {

                            guard let items = attribute?.fragments.attributeDetails.items else { return }

                            for item in items {
                                var ob : SizeModel?
                                if item?.displayValue == i.pickedColor {
                                    ob = SizeModel(value: (item!.value)!, displayText: item!.displayValue!, selected: true)
                                }
                                else {
                                    ob = SizeModel(value: (item!.value)!, displayText: item!.displayValue!, selected: false)
                                }

                                Colors.append(ob!)
                            }
                        }
                    }
                    
                    let productObject = productcartModel(productId: i.productId, productName: success.name, productBrand: success.brand, productPriceSynmbol: success.prices[0].fragments.priceDetails.currency.symbol, productPrice: String(success.prices[0].fragments.priceDetails.amount), productAmount: String(i.count), produtsImage: success.gallery ?? [], productSize: Sizes , procutColor: Colors)
                    
                    productsCart.append(productObject)
                    
                    if productsCart.count == self.productsInCartBehvaiour.value.count {
                        self.productsCarBehvaiour.accept(productsCart)
                        break
                    }
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            })
        }
    }
    
    func scrollToNextCell(collectionView: UICollectionView, action: String){

        //get cell size
        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height);

        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset

        if action == "inc" {
            //scroll to next cell
            collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
        else if action == "dec" {
            //scroll to prev cell
            collectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }
}
