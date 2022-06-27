//
//  UIButton.swift
//  online shopping
//
//  Created by Mohamed Ali on 27/06/2022.
//

import UIKit

extension UIButton {
    func AddCornerRadiour(radious: CGFloat) {
        self.layer.cornerRadius = radious
        self.layer.masksToBounds = true
    }
}
