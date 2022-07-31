//
//  ProductsViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import UIKit
import RxSwift
import RxGesture

class ProductsViewController: UIViewController, representToHomeScreen , CountdataPassBack {
    
    @IBOutlet weak var WomanLabel: UILabel!
    @IBOutlet weak var WomanLine: UIView!
    
    @IBOutlet weak var manLabel: UILabel!
    @IBOutlet weak var manLine: UIView!
    
    @IBOutlet weak var KidsLabel: UILabel!
    @IBOutlet weak var KidsLine: UIView!
    
    @IBOutlet weak var BadgeView: UIImageView!
    @IBOutlet weak var numberpfProductsLabel: UILabel!
    
    @IBOutlet weak var cartButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lines: Array<UIView>?
    var titlesLabels: Array<UILabel>?
    let disposebag = DisposeBag()
    let CellnibName = "productCell"
    let CellIdentifier = "Cell"
    let productviewmodel = productsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lines = [WomanLine,manLine,KidsLine]
        titlesLabels = [WomanLabel,manLabel,KidsLabel]
        
        
        AddTapGeuseterToFilter()
        ConfigureCollectionView()
        BindToCollectionView()
        SubscribeToCollectionViewScelection()
        SubsctibeToCartBadgeCount()
        FetchDataOperation()
        FetchNotificationCenter()
        SubscribeToCartButtonAction()
    }
    
    func AddTouchRecognizeAction(index: Int,label: UILabel,completion: @escaping (Bool) -> ()) {
        AddGuester(label: label) { [weak self] send in
            guard let self = self else { return }
            
            self.titlesLabels![index].textColor = UIColor().hexStringToUIColor(hex: "#5ECE7B")
            self.lines![index].backgroundColor = UIColor().hexStringToUIColor(hex: "#5ECE7B")
            
            for i in 0..<self.lines!.count {
                if i == index {
                    continue
                }
                else {
                    self.lines![i].backgroundColor = UIColor.white
                    self.titlesLabels![i].textColor = UIColor.black
                }
            }
            
            completion(true)
        }
    }
    
    private func AddGuester(label: UILabel,completion: @escaping (Bool) ->()) {
        label.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            completion(true)
        }).disposed(by: disposebag)
    }
    
    func AddTapGeuseterToFilter() {
        AddTouchRecognizeAction(index: 0, label: WomanLabel) { response in
            if response {
                self.FetchDataOperation()
            }
        }
        AddTouchRecognizeAction(index: 1, label: manLabel) { response in
            if response {
                self.productviewmodel.fetchDataClothesOperation()
            }
            
        }
        AddTouchRecognizeAction(index: 2, label: KidsLabel) {response in
            if response {
                self.productviewmodel.fetchDataTechOperation()
            }
        }
    }
    
    func ConfigureCollectionView() {
        collectionView.register(UINib(nibName: CellnibName, bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
        
        collectionView.backgroundColor = UIColor.clear
                
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        var size = 0
        
        if self.view.frame.height == 667 {
            size = Int(((collectionView.frame.size.width - 10) / CGFloat(2)))
        }
        else if self.view.frame.height == 568 {
            size = Int((collectionView.frame.size.width / CGFloat(2)) - 5)
        }
        else {
            size = Int((collectionView.frame.size.width / CGFloat(2)) + 15)
        }
        
        flowLayout.itemSize = CGSize(width: size, height: size + 70)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func BindToCollectionView() {
        productviewmodel.productsBehaviourObserval.bind(to: collectionView.rx.items(cellIdentifier: CellIdentifier, cellType: productCell.self)) { row, branch , cell in
            cell.configureCell(product: branch)
        }.disposed(by: disposebag)
    }
    
    func SubscribeToCollectionViewScelection() {
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(productModel.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                let story = UIStoryboard(name: "productDetails", bundle: nil)
                
                let next = story.instantiateViewController(withIdentifier: "productDetailsViewController") as! productDetailsViewController
                
                next.productdetailsviewmodel.idBehaviour.accept(branch.id)
                next.productdetailsviewmodel.productInCartBehaviour.accept(branch.inCart)
                let productsCart: [cartModel] = self.productviewmodel.FetchDataFormRealm()
                if branch.inCart {
                    let index = productsCart.firstIndex{$0.productId == branch.id}
                    next.productdetailsviewmodel.productCartBehaviour.accept(productsCart[index!])
                }

                next.productdetailsviewmodel.productLoactionBehaviour.accept(selectedIndex[1])
                
                next.delegate = self
                
                next.modalPresentationStyle = .fullScreen
                
                self.present(next, animated: true)
                
//                print(selectedIndex[1], branch.UserName)
        }
        .disposed(by: disposebag)
    }
    
    func SubsctibeToCartBadgeCount() {
        productviewmodel.numberofProductBehaviour.asObservable().subscribe { [weak self] (count: Int) in
            guard let self = self else { return }
            
            if count > 0 {
                self.BadgeView.isHidden = false
                self.numberpfProductsLabel.isHidden = false
                self.numberpfProductsLabel.text = String(count)
            }
            else {
                self.BadgeView.isHidden = true
                self.numberpfProductsLabel.isHidden = true
            }
        }.disposed(by: disposebag)
    }
    
    func FetchDataOperation() {
        productviewmodel.fetchDataOperation()
    }
    
    func FetchNotificationCenter() {
        productviewmodel.FetchTheNotificationFormUser()
    }
    
    func sendToBack(flag: Bool,location: Int,count: Int,action: Bool) {
        print("F: \(location)")
        if flag {
            let ccount = productviewmodel.numberofProductBehaviour.value
            var newcount = 0
            if action {
                newcount = ccount + count
            }
            else {
                newcount = ccount - count
            }
            
            productviewmodel.numberofProductBehaviour.accept(newcount)
            
            productviewmodel.updateInCart(index: location)
        }
        
    }
    
    func FetchtotalCount(totalCount: String) {
        print(totalCount)
        guard let totalAmount = Int(totalCount) else {
            print("Error in Converting")
            return
        }
        productviewmodel.numberofProductBehaviour.accept(totalAmount)
    }
    
    func SubscribeToCartButtonAction() {
        cartButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let story = UIStoryboard(name: "cart", bundle: nil)
            let nextVc = story.instantiateViewController(withIdentifier: "cartViewController") as! cartViewController
            nextVc.cartviewmodel.productsInCartBehvaiour.accept(self.productviewmodel.FetchDataFormRealm())
            nextVc.modalPresentationStyle = .fullScreen
            nextVc.delegate = self
            self.present(nextVc, animated: true)
            
        }).disposed(by: disposebag)
    }
}
