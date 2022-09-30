//
//  productCell.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class productCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var inCartLabel: UILabel!
    @IBOutlet weak var outOfStockView: UIView!
    
    @IBOutlet weak var cartButton: UIButton!
    
    var AddButtonObserval : Observable<Void>{
           return self.cartButton.rx.tap.throttle(.milliseconds(1000), scheduler: MainScheduler.instance).asObservable()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (product: productModel) {
        productTitleLabel.text = product.name
        productPriceLabel.text = product.prices[0].currency.symbol + String(product.prices[0].amount)
        
        DispatchQueue.main.async {
            guard let image = product.gallery[0] else {
                self.productImageView.image = UIImage(named: "ProductImage")
                return
            }
            
            self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
        }
        
        if product.inStock {
            outOfStockView.isHidden = true
            
            if product.inCart {
                cartButton.isHidden = true
                inCartLabel.isHidden = false
            }
            else {
                cartButton.isHidden = false
                inCartLabel.isHidden = true
            }
        }
        else {
            outOfStockView.isHidden = false
            cartButton.isHidden = true
            inCartLabel.isHidden = true
        }
    }
}
