//
//  productDetailsViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 25/06/2022.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class productDetailsViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var productImageCollectionViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var productDetailsLabel: WKWebView!
    
    @IBOutlet weak var AddCartButton: UIButton!
    
    let disposebag = DisposeBag()
    let productdetailsviewmodel = productDetailsViewModel()
    let nibFileName = "imageCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        SubscribeToBackButton()
        subscribeToresponse()
        ConfigureImageCollectionView()
        SubscribeToImageCollectionView()
        SubscribeToSelectImage()
        loadData()
    }
    
    func SubscribeToBackButton() {
        BackButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.dismiss(animated: true)
            
        }).disposed(by: disposebag)
    }
    
    func subscribeToresponse() {
        productdetailsviewmodel.productDetailsBehaviourObserval.subscribe(onNext: { [weak self] productDetails in
            guard let self = self else { return }
            
            guard let productDetails = productDetails else { return }
            
            self.productNameLabel.text = productDetails.name
            self.productBrandLabel.text = productDetails.brand
            self.PriceLabel.text =  productDetails.prices[0].fragments.priceDetails.currency.symbol + String(productDetails.prices[0].fragments.priceDetails.amount)
            
            let header = """
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                        <style>
                            body {
                                font-family: "Roboto";
                                font-size: 24px;
                            }
                        </style>
                    </head>
                    <body style = "text-Alignment = "center">
                    """
            
            self.productDetailsLabel.loadHTMLString(header + productDetails.description + "</body>", baseURL: nil)
            
            DispatchQueue.main.async {
                guard let image = productDetails.gallery?[0] else {
                    self.productImageView.image = UIImage(named: "ProductImage")
                    return
                }
                
                self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
            }
            
            guard let images = productDetails.gallery else { return }
            
            if images.count > 1 {
                self.productImageCollectionViewHight.constant = 65
            }
            else {
                self.productImageCollectionViewHight.constant = 0
            }
            
            self.productdetailsviewmodel.imagesBehavriour.accept(images.arrayWithoutFirstElement() as! [String])
            
            if productDetails.inStock! {
                self.AddCartButton.isHidden = false
            }
            else {
                self.AddCartButton.isHidden = true
            }
            
            
        }).disposed(by: disposebag)
    }
    
    func ConfigureImageCollectionView() {
        
        productImagesCollectionView.register(UINib(nibName: nibFileName, bundle: nil), forCellWithReuseIdentifier: nibFileName)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        var size = 0
        
        if self.view.frame.height == 667 {
            size = Int(((productImagesCollectionView.frame.size.width - 10) / CGFloat(4)))
        }
        else if self.view.frame.height == 568 {
            size = Int((productImagesCollectionView.frame.size.width / CGFloat(4)) - 5)
        }
        else {
            size = Int((productImagesCollectionView.frame.size.width / CGFloat(4)) + 15)
        }
        
        flowLayout.itemSize = CGSize(width: size, height: Int(productImagesCollectionView.frame.size.height - 10))
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        productImagesCollectionView.collectionViewLayout = flowLayout
    }
    
    func SubscribeToImageCollectionView() {
        productdetailsviewmodel.imagesBehavriour.bind(to: productImagesCollectionView.rx.items(cellIdentifier: nibFileName, cellType: imageCell.self)) { row, branch , cell in
            cell.configureCell(image: branch)
        }.disposed(by: disposebag)
    }
    
    func SubscribeToSelectImage() {
        Observable.zip(productImagesCollectionView.rx.itemSelected, productImagesCollectionView.rx.modelSelected(String?.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let image = branch else {
                        self.productImageView.image = UIImage(named: "ProductImage")
                        return
                    }
                    
                    self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
                }
//                print(selectedIndex[1], branch.UserName)
        }
        .disposed(by: disposebag)
    }
    
    func loadData() {
        productdetailsviewmodel.FetchproductDetailsOperation()
    }
}


extension Array {
    func arrayWithoutFirstElement() -> Array {
        if count != 0 { // Check if Array is empty to prevent crash
            var newArray = Array(self)
            newArray.removeFirst()
            return newArray
        }
        return []
    }
}
