//
//  productCell.swift
//  online shopping
//
//  Created by Mohamed Ali on 23/06/2022.
//

import UIKit
import Kingfisher

class productCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (product: productModel) {
        productTitleLabel.text = product.name
        productPriceLabel.text = product.prices[0].fragments.priceDetails.currency.symbol + String(product.prices[0].fragments.priceDetails.amount)
        
        DispatchQueue.main.async {
            guard let image = product.gallery[0] else {
                self.productImageView.image = UIImage(named: "ProductImage")
                return
            }
            
            self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
        }
    }
}
