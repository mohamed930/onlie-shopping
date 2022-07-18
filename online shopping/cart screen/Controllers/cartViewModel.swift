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
    
    
    
    func incrementAmountOperation (cartproduct: String, cartPrice: String, operation: Character, indexPath: IndexPath) -> Int {
        let product = productsInCartBehvaiour.value
        
        var oldcount = 0
        var ob: cartModel!
        
        for i in product {
            if i.productId == cartproduct {
                ob = i
                oldcount = i.count
                break
            }
        }
        
        if operation == "+" {
            oldcount += 1
        }
        else {
            oldcount -= 1
        }
        
        let result = RealmSwiftLayer.update {
            guard let ob = ob else { return }
            ob.count = oldcount
        }
        
        if result {
            let total = totalBehaviour.value
            
            if operation == "+" {
                let tamount = String(1 + Int((total?.productAmount)!)!)
                
                let oldTotal = Double(total!.totalAmount)!
                let tprice = String(round(oldTotal) + Double(cartPrice)!)
                
                let r = round(Double((total?.totalAmount)!)! * 21) / 100
                let result = String(r)
                
                let ob = totalModel(totalAmount: tprice, taxAmount: result, productAmount: tamount, productAmountWithoutTax: "")
                totalBehaviour.accept(ob)
            }
            else {
                let tamount = String(Int((total?.productAmount)!)! - 1)
                
                if oldcount <= 0 {
                    // Remove the product and reamove from Realmswift.
                    _ = RealmSwiftLayer.delete(ob)
                    removeItem(at: indexPath)
                }
                else {
                    let oldTotal = Double(total!.totalAmount)!
                    var tprice = ""
                    
                    if oldTotal > Double(cartPrice)! {
                        tprice = String(round(oldTotal) - Double(cartPrice)!)
                    }
                    else {
                        tprice = String(Double(cartPrice)! - round(oldTotal))
                    }
                    
                    let r = round(Double((total?.totalAmount)!)! * 21) / 100
                    let result = String(r)
                    
                    let ob = totalModel(totalAmount: tprice, taxAmount: result, productAmount: tamount, productAmountWithoutTax: "")
                    totalBehaviour.accept(ob)
                }
            }
            
            return oldcount
        }
        else {
            return 0
        }
    }
    
    func incrementAmountOperation(ob: productcartModel, operation: Character) -> Int {
        if operation == "+" {
            // first update in database
            let product = productsInCartBehvaiour.value
            let index = product.firstIndex { $0.productId == ob.productId }!
            let Choocedproduct = product[index]
            let newcount = Choocedproduct.count + 1
            let result = RealmSwiftLayer.update {
                Choocedproduct.count = newcount
            }
    
            
            if result {
                // update in total
                guard var oldtotal = totalBehaviour.value else { return 0}
                
                let totalprice = Double(oldtotal.productAmountWithoutTax)! + Double(ob.productPrice)!
                let totaltax = 21 * totalprice / 100
                let totalPriceAfterTax = totalprice + totaltax
                
                oldtotal.productAmount = String(Int(oldtotal.productAmount)! + 1)
                oldtotal.totalAmount   = String(format: "%0.2f", totalPriceAfterTax)
                oldtotal.taxAmount     = String(format: "%0.2f", totaltax)
                oldtotal.productAmountWithoutTax = String(format: "%0.2f", totalprice)
                self.totalBehaviour.accept(oldtotal)
                
                // update in UI in cell
                return newcount
            }
            
        }
        
        return 0
    }
    
    
    
    // MARK:- TODO:- This Method For Delete Cell from Array tableView.
    private func removeItem(at indexPath: IndexPath) {
        
        var sections = productsCarBehvaiour.value
        
        sections.remove(at: indexPath.row)

        productsCarBehvaiour.accept(sections)
    }
    // ------------------------------------------------
}
