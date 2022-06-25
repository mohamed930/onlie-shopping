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
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var productDetailsLabel: WKWebView!
    
    @IBOutlet weak var AddCartButton: UIButton!
    
    let disposebag = DisposeBag()
    let productdetailsviewmodel = productDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        SubscribeToBackButton()
        subscribeToresponse()
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
            
            if productDetails.inStock! {
                self.AddCartButton.isHidden = false
            }
            else {
                self.AddCartButton.isHidden = true
            }
            
            
        }).disposed(by: disposebag)
    }
    
    func loadData() {
        productdetailsviewmodel.FetchproductDetailsOperation()
    }
}
