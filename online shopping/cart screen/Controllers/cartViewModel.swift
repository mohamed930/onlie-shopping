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
    
    private var totalBehaviour = BehaviorRelay<totalModel?>(value: nil)
    var totalBehaviourObservsl: Observable<totalModel?> {
        return totalBehaviour.asObservable()
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
                        self.SetCartValues()
                        break
                    }
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            })
        }
    }
    
    
    
    func scrollToNextCell(collectionView: UICollectionView, action: String) {

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
    
    
    
    func SetCartValues() {
        let cart = productsCarBehvaiour.value
        
        var sum = 0.0
        var amount = 0
        for i in cart {
            sum += Double(Double(i.productAmount)! * Double(i.productPrice)!)
            amount += Int(i.productAmount)!
        }
        
        let tax = round(21*sum) / 100
        let totalAmountWithTax = tax + sum
        
        let ob = totalModel(totalAmount: String(format: "%0.2f", totalAmountWithTax), taxAmount: String(tax), productAmount: String(amount), productAmountWithoutTax: String(sum))
        totalBehaviour.accept(ob)
    }
    
    
    func incrementAmountOperation(ob: productcartModel, operation: Character,index: Int) -> Int {
        
        let product = productsInCartBehvaiour.value
        let index = product.firstIndex { $0.productId == ob.productId }!
        let Choocedproduct = product[index]
        
        if operation == "+" {
            // first update in database
            let newcount = Choocedproduct.count + 1
            
            // Update Total and RealmDatabse.
            UpdateInDatabaseAndUITotal(operation: "+", productCart: Choocedproduct, newcount: newcount, productPrice: ob.productPrice)
            
            // update in UI in cell
            return newcount
            
        }
        else {
            // first update in database
            let newcount = Choocedproduct.count - 1
            
            if newcount == 0 {
                // remove element from RealmSwift Database
                let result = RealmSwiftLayer.delete(Choocedproduct)
                
                if result {
                    // remove element from tableViewUI.
                    print("F: row Selected \(index)")
                    removeItem(at: ob)
                    
                    // updateInDataAndUITotal
                    UpdateInDatabaseAndUITotal(operation: "-", productCart: Choocedproduct, newcount: 0, productPrice: ob.productPrice)
                    
                    return 0
                    
                }
            }
            else {
                // Update Total and RealmDatabse.
                UpdateInDatabaseAndUITotal(operation: "-", productCart: Choocedproduct, newcount: newcount, productPrice: ob.productPrice)
                
                // update in UI in cell
                return newcount
            }
        }
        
        return 0
    }
    
    // we need operation to chooce logic - productCart to update element in RealmSwift - newcount to update the amount in Realmswift - productPrice to inceremt or decremnt the total price with picked product price.
    private func UpdateInDatabaseAndUITotal(operation: Character,productCart: cartModel, newcount: Int, productPrice: String) {
        var result = false
        if newcount != 0 {
            // Update Count in RealmDatabase.
            result = RealmSwiftLayer.update {
                productCart.count = newcount
            }
        }
        
        if result  || newcount == 0 {
            guard var oldtotal = totalBehaviour.value else { return }
            
            var totalprice = Double()
            var totalAmount = Int()
            
            // check the operation to increment the totalAmount or decrement it.
            if operation == "+" {
                totalprice = Double(oldtotal.productAmountWithoutTax)! + Double(productPrice)!
                totalAmount = Int(oldtotal.productAmount)! + 1
            }
            else {
                totalprice = Double(oldtotal.productAmountWithoutTax)! - Double(productPrice)!
                totalAmount = Int(oldtotal.productAmount)! - 1
            }
            
            // update in total
            let totaltax = 21 * totalprice / 100
            let totalPriceAfterTax = totalprice + totaltax
            
            oldtotal.productAmount = String(totalAmount)
            oldtotal.totalAmount   = String(format: "%0.2f", totalPriceAfterTax)
            oldtotal.taxAmount     = String(format: "%0.2f", totaltax)
            oldtotal.productAmountWithoutTax = String(format: "%0.2f", totalprice)
            totalBehaviour.accept(oldtotal)
        }
    }
    
    // MARK: TODO: This Method For Delete Cell from Array tableView.
    private func removeItem(at indexPath: productcartModel) {
        
        var sections = productsCarBehvaiour.value
        
        let index = sections.firstIndex { $0.productId == indexPath.productId }!
        
        sections.remove(at: index)

        productsCarBehvaiour.accept(sections)
    }
    // ------------------------------------------------
}
