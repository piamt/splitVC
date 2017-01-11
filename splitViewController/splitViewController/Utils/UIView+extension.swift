//
//  UIView+extension.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import UIKit
import Cartography

extension UIView {
    
    public func addBorder(color: UIColor) {
        self.layer.borderWidth = 10
        self.layer.borderColor = color.cgColor
    }
    
    public func addWhiteBorder() {
        self.addBorder(color: UIColor.white)
    }
    
    public func addText(text: String) {
        let textView = UITextView()
        textView.text = text
        textView.backgroundColor = self.backgroundColor
        self.addSubview(textView)
        
        constrain(self, textView) { parent, text in
            text.top == parent.top
            text.bottom == parent.bottom
            text.leading == parent.leading
            text.trailing == parent.trailing
        }
    }
    
    public func addImage(imageName: String) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        self.addSubview(imageView)
        
        constrain(self, imageView) { parent, image in
            image.top == parent.top + 10
            image.bottom == parent.bottom - 10
            image.leading == parent.leading + 10
            image.trailing == parent.trailing - 10
        }
    }
}
