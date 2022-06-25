//
//  imageCell.swift
//  online shopping
//
//  Created by Mohamed Ali on 25/06/2022.
//

import UIKit

class imageCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(image: String?) {
        
        productImageView.layer.borderColor = UIColor.black.cgColor
        productImageView.layer.borderWidth = 1
        
        DispatchQueue.main.async {
            guard let image = image else {
                self.productImageView.image = UIImage(named: "ProductImage")
                return
            }
            
            self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
        }
    }

}
