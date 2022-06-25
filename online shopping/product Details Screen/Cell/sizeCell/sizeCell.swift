//
//  sizeCell.swift
//  online shopping
//
//  Created by Mohamed Ali on 25/06/2022.
//

import UIKit

class sizeCell: UICollectionViewCell {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func ConfigureSizeCell(sizeNumber: String) {
        sizeLabel.text = sizeNumber
        sizeLabel.isHidden = false
        sizeView.layer.borderColor = UIColor.black.cgColor
        sizeView.layer.borderWidth = 1
    }
    
    func ConfigureColorCell(colorCode: String) {
        
        sizeView.layer.backgroundColor = UIColor().hexStringToUIColor(hex: colorCode).cgColor
        
        sizeView.layer.borderColor = UIColor.clear.cgColor
        sizeView.layer.borderWidth = 0
        
        sizeLabel.isHidden = true
    }

}
