//
//  UITextField+Utilities.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

extension UITextField {
   
    func addBottomBorder() {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.separator.cgColor
        borderStyle = .none
        
        layer.addSublayer(bottomLine)
    }
}
