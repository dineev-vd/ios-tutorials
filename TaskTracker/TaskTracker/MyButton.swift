//
//  MyButton.swift
//  TaskTracker
//
//  Created by Влад Динеев on 01.03.2021.
//

import UIKit

@IBDesignable
class MyButton: UIButton {
    
    @IBInspectable
    var roundedCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = roundedCornerRadius
        }
    }
}
