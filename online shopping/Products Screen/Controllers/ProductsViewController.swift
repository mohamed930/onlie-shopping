//
//  ProductsViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import UIKit
import RxSwift
import RxGesture

class ProductsViewController: UIViewController {
    
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
        
        ConfigureCollectionView()
        BindToCollectionView()
        FetchDataOperation()
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
        
        flowLayout.itemSize = CGSize(width: size, height: size + 50)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func BindToCollectionView() {
        productviewmodel.productsBehaviourObserval.bind(to: collectionView.rx.items(cellIdentifier: CellIdentifier, cellType: productCell.self)) { row, branch , cell in
            cell.configureCell(product: branch)
        }.disposed(by: disposebag)
    }
    
    func FetchDataOperation() {
        productviewmodel.fetchDataOperation()
    }
}